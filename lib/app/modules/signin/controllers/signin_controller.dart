import 'package:chatapp/app/data/firebase/firebase.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  FirebaseService firebase = FirebaseService();
  var isLoading = false.obs;
  var selectedImage = "".obs;
  var phoneNumber = '';

  void sendOtp() async {
    isLoading.toggle();
    try {
      await firebase.sendOtp(phoneNumber);
      await Future.delayed(
        const Duration(milliseconds: 4000),
      );
    } catch (e) {
      Get.snackbar("Message", e.toString());
    }
    isLoading.toggle();
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
