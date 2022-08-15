import 'dart:io';
import 'package:chatapp/app/data/model/user_model.dart';
import 'package:chatapp/app/modules/verify/views/verify_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  Future<void> sendOtp(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        print("User verified");
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message!);
      },
      codeSent: (String verificationId, int? resendToken) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString("code", verificationId);
        Get.to(() => VerifyView(phoneNumber: number));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOtp(String otp) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? verificationId = preferences.getString("code");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otp);
    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.offAllNamed('/add-profile');
  }

  Future<void> logOut(BuildContext context) async {
    try {
      final User? firebaseUser = await FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        FirebaseAuth.instance
            .signOut()
            .then((value) => {Get.offAllNamed('/signin')});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUser(UserModel userModel) async {
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    DocumentSnapshot contacts = await FirebaseFirestore.instance
        .collection("contacts")
        .doc(userModel.uId)
        .get();
    SharedPreferences.getInstance()
        .then((value) => value.setString("number", userModel.number));
    if (contacts.exists) {
    } else {
      await FirebaseFirestore.instance
          .collection("contacts")
          .doc(userModel.uId)
          .set({
        "contacts": [],
      });
    }
    return await ref.doc(userModel.uId).set(userModel.toJson());
  }

  Future<String> uploadUserImage(String path, String uid, File file) async {
    Reference storage = FirebaseStorage.instance.ref(uid).child(path);
    UploadTask task = storage.putFile(file);
    TaskSnapshot snapshot = await task;
    String link = await snapshot.ref.getDownloadURL();
    return link;
  }

  Future<String> sendImage(String path, String uid, File file) async {
    Reference storage = FirebaseStorage.instance.ref(uid).child(path);
    UploadTask task = storage.putFile(file);
    TaskSnapshot snapshot = await task;
    String link = await snapshot.ref.getDownloadURL();
    return link;
  }
}
