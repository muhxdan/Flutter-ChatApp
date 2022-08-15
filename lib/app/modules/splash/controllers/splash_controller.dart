import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final auth = FirebaseAuth.instance;
  get uid => auth.currentUser!.uid;

  void checkData() async {
    if (auth.currentUser != null) {
      try {
        await FirebaseFirestore.instance.doc("users/$uid").get().then((doc) {
          if (doc.exists) {
            Get.offAllNamed('/dashboard');
          } else {
            Get.offAllNamed('/add-profile');
          }
        });
      } catch (e) {}
    } else {
      Get.offAllNamed('/signin');
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 3)).then(
      (value) => checkData(),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
