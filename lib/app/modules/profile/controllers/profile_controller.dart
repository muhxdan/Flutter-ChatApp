import 'package:chatapp/app/data/firebase/firebase.dart';
import 'package:chatapp/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final dashboardC = Get.put(DashboardController());
  final auth = FirebaseAuth.instance;
  final service = FirebaseService();

  Future<void> updateUser(index, data) async {
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    if (index == 0) {
      await ref.doc(auth.currentUser!.uid).update({'name': data});
    } else if (index == 1) {
      await ref.doc(auth.currentUser!.uid).update({'status': data});
    } else {
      await ref.doc(auth.currentUser!.uid).update({'number': data});
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
