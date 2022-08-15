import 'package:get/get.dart';

import '../controllers/add_profile_controller.dart';

class AddProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProfileController>(
      () => AddProfileController(),
    );
  }
}
