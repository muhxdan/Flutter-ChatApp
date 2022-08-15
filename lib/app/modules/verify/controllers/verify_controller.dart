import 'package:chatapp/app/data/firebase/firebase.dart';
import 'package:get/get.dart';

class VerifyController extends GetxController {
  FirebaseService firebase = FirebaseService();
  void verifyOTP(String otp) async {
    try {
      await firebase.verifyOtp(otp);
    } catch (e) {
      Get.snackbar("Message", e.toString());
    }
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
  void onClose() {}
}
