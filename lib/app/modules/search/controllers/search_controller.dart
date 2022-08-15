import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final searchC = TextEditingController();
  List searchResult = [];
  var isLoading = false.obs;
  final auth = FirebaseAuth.instance;
  get uid => auth.currentUser!.uid;

  void onSearch() async {
    var collection =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection("users")
        .where("number", isEqualTo: searchC.text)
        .get()
        .then((value) {
      if (value.docs.length < 1) {
        isLoading.value = false;
        Get.snackbar("Message", "Cannot find the number");
        return;
      } else if (collection.data()!["number"] == searchC.text) {
        isLoading.value = false;
        Get.snackbar("Message", "The number is your number");
        searchResult.clear();
        return;
      }
      value.docs.forEach((users) {
        searchResult.add(users.data());
      });
      isLoading.value = false;
    });
  }

  void onSave(index) async {
    isLoading.value = true;
    var collection =
        await FirebaseFirestore.instance.collection("contacts").doc(uid).get();
    if (collection
        .data()!["contacts"]
        .contains(searchResult[index]["number"])) {
      isLoading.value = false;
      Get.snackbar("Message", "Number already exists");
      return;
    }
    isLoading.value = false;
    Get.snackbar("Message", "Added to your contact");
    FirebaseFirestore.instance.collection("contacts").doc(uid).update({
      "contacts": FieldValue.arrayUnion([searchResult[index]["number"]]),
    });
    searchC.clear();
    searchResult.clear();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchC.clear();
  }
}
