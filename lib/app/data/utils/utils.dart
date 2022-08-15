import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File> imageFromCamera(bool isCropped) async {
  File? result;
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(
    source: ImageSource.camera,
    preferredCameraDevice: CameraDevice.rear,
    imageQuality: 85,
  );

  if (pickedFile != null) {
    result = File(pickedFile.path);
    if (isCropped) result = await cropImage(result);
  }

  return result!;
}

Future<File> imageFromGallery(bool isCropped) async {
  File? result;
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
  );

  if (pickedFile != null) {
    result = File(pickedFile.path);
    if (isCropped) result = await cropImage(result);
  }

  return result!;
}

Future<File> cropImage(File imageFile) async {
  late File result;
  File? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: Color(0xFF246BFD),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));

  result = croppedFile!;
  return result;
}
