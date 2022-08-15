import 'dart:io';
import 'package:chatapp/app/data/color/color.dart';
import 'package:chatapp/app/data/firebase/firebase.dart';
import 'package:chatapp/app/data/model/user_model.dart';
import 'package:chatapp/app/data/utils/permission.dart';
import 'package:chatapp/app/data/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProfileController extends GetxController {
  PermissionService permission = PermissionService();
  FirebaseService service = FirebaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  FocusNode focusNode = FocusNode();
  var isKeyboardVisible = false.obs;
  var isEmojiVisible = false.obs;
  var selectedImage = "".obs;
  var isSelectedImage = false.obs;
  final nameController = TextEditingController();

  void onEmojiClicked() => isEmojiVisible.toggle();

  void getImage(ImageSource source) async {
    switch (source) {
      case ImageSource.camera:
        File file = await imageFromCamera(true);
        selectedImage.value = file.path;
        isSelectedImage.value = true;
        getIsSelected();
        break;
      case ImageSource.gallery:
        File file = await imageFromGallery(true);
        selectedImage.value = file.path;
        isSelectedImage.value = true;
        getIsSelected();
        break;
    }
  }

  void getIsSelected() async {
    String link = await service.uploadUserImage(
      'profile/image',
      auth.currentUser!.uid,
      File(selectedImage.value),
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'image': link});
  }

  get numberUser => auth.currentUser!.phoneNumber;
  void uploadUserData() async {
    if (selectedImage.value == "") {
      var userModel = UserModel(
        uId: auth.currentUser!.uid,
        name: nameController.text,
        image: "",
        number: numberUser.toString(),
        status: "Hello",
      );
      await service.createUser(userModel);
    } else {
      String link = await service.uploadUserImage(
        'profile/image',
        auth.currentUser!.uid,
        File(selectedImage.value),
      );
      var userModel = UserModel(
        uId: auth.currentUser!.uid,
        name: nameController.text,
        image: link,
        number: numberUser.toString(),
        status: "Hello",
      );
      await service.createUser(userModel);
    }
    Get.offAllNamed('/dashboard');
  }

  void showPicker(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          color: Colors.white,
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: mainColor,
                ),
                title: const Text("Photo Library"),
                onTap: () async {
                  Navigator.pop(context);
                  var status = await permission.isStoragePermissionOk();
                  switch (status) {
                    case PermissionStatus.denied:
                      var status = await Permission.storage.request().isDenied;
                      if (status) {
                        getImage(ImageSource.gallery);
                      } else {
                        print("Storage Permission denied");
                      }
                      break;
                    case PermissionStatus.granted:
                      getImage(ImageSource.gallery);
                      break;
                    case PermissionStatus.restricted:
                      print("Storage Permission denied");
                      break;
                    case PermissionStatus.limited:
                      print("Storage Permission denied");
                      break;
                    case PermissionStatus.permanentlyDenied:
                      await openAppSettings();
                      break;
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  color: mainColor,
                ),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  var status = await permission.isCameraPermissionOk();
                  switch (status) {
                    case PermissionStatus.denied:
                      var status = await Permission.camera.request().isDenied;
                      if (status) {
                        getImage(ImageSource.camera);
                      } else {
                        print("Camera Permission denied");
                      }
                      break;
                    case PermissionStatus.granted:
                      getImage(ImageSource.camera);
                      break;
                    case PermissionStatus.restricted:
                      print("Camera Permission denied");
                      break;
                    case PermissionStatus.limited:
                      print("Camera Permission denied");
                      break;
                    case PermissionStatus.permanentlyDenied:
                      await openAppSettings();
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojiVisible.value = false;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.dispose();
  }
}
