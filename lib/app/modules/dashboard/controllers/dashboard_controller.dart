import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  late PageController pageController;
  GlobalKey bottomNavKey = GlobalKey();
  var page = 0.obs;
  final auth = FirebaseAuth.instance;
  get uid => auth.currentUser!.uid;

  void onItemClick(int index) {
    if (index != page.value) page(index);
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
