import 'dart:io';

import 'package:chatapp/app/data/color/color.dart';
import 'package:chatapp/app/data/firebase/firebase.dart';
import 'package:chatapp/app/data/model/chat_model.dart';
import 'package:chatapp/app/data/utils/permission.dart';
import 'package:chatapp/app/data/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatController extends GetxController {
  PermissionService permission = PermissionService();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseService service = FirebaseService();
  var selectedImage = "".obs;
  var isSelectedImage = false.obs;
  var index = 1;

  void getImage(ImageSource source, contactUid, userUid) async {
    switch (source) {
      case ImageSource.camera:
        File file = await imageFromCamera(true);
        selectedImage.value = file.path;
        isSelectedImage.value = true;
        String link = await service.sendImage(
          'dataImage/image${index++}',
          auth.currentUser!.uid,
          File(selectedImage.value),
        );
        sendMessage(contactUid, userUid, link);
        break;
      case ImageSource.gallery:
        File file = await imageFromGallery(true);
        selectedImage.value = file.path;
        isSelectedImage.value = true;
        String link = await service.sendImage(
          'dataImage/image${index++}',
          auth.currentUser!.uid,
          File(selectedImage.value),
        );
        sendMessage(contactUid, userUid, link);
        break;
    }
  }

  void sendMessage(contactUid, userUid, message) async {
    var chatModel = (isSelectedImage.value)
        ? ChatModel(
            senderUid: userUid,
            receiverUid: contactUid,
            message: '',
            date: DateTime.now().toIso8601String(),
            isRead: false,
            image: message,
            type: "image",
          )
        : ChatModel(
            senderUid: userUid,
            receiverUid: contactUid,
            message: message,
            date: DateTime.now().toIso8601String(),
            isRead: false,
            image: '',
            type: "text",
          );
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(userUid)
        .collection('messages')
        .doc(contactUid)
        .collection('data')
        .add(chatModel.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(userUid)
          .collection('messages')
          .doc(contactUid)
          .set({
        'last_message': message,
        'type': (isSelectedImage.value) ? "image" : "text",
      });
    });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(contactUid)
        .collection('messages')
        .doc(userUid)
        .collection("data")
        .add(chatModel.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(contactUid)
          .collection('messages')
          .doc(userUid)
          .set({
        'last_message': message,
        'type': (isSelectedImage.value) ? "image" : "text",
      });
    });
    isSelectedImage.value = false;
    selectedImage.value = '';
  }

  void showPicker(BuildContext context, contactUid, userUid) {
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
                        getImage(ImageSource.gallery, contactUid, userUid);
                      } else {
                        print("Storage Permission denied");
                      }
                      break;
                    case PermissionStatus.granted:
                      getImage(ImageSource.gallery, contactUid, userUid);
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
                        getImage(ImageSource.camera, contactUid, userUid);
                      } else {
                        print("Camera Permission denied");
                      }
                      break;
                    case PermissionStatus.granted:
                      getImage(ImageSource.camera, contactUid, userUid);
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
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
