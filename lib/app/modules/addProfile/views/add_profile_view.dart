import 'dart:io';

import 'package:chatapp/app/data/color/color.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/add_profile_controller.dart';

class AddProfileView extends GetView<AddProfileController> {
  final GlobalKey<FormState> userNameKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Get.put(AddProfileController());
    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    Container(
                      height: AppBar().preferredSize.height,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "User Profile",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: blackColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (userNameKey.currentState!.validate()) {
                                controller.uploadUserData();
                              }
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: mainColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 50),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller.showPicker(context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: (controller.selectedImage.value == "")
                              ? Container(
                                  margin: EdgeInsets.all(30),
                                  child: SvgPicture.asset(
                                    "assets/images/camera.svg",
                                    color: Colors.white,
                                  ),
                                )
                              : Image.file(
                                  File(controller.selectedImage.value),
                                ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Form(
                            key: userNameKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Name is required";
                                } else if (value.length > 25) {
                                  return "Name must not be more than 25 char";
                                }
                                return null;
                              },
                              cursorColor: mainColor,
                              focusNode: controller.focusNode,
                              controller: controller.nameController,
                              decoration: InputDecoration(
                                hintText: "Your name",
                                contentPadding: EdgeInsets.only(bottom: -20),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: IconButton(
                            iconSize: 27,
                            splashRadius: 20,
                            color: mainColor,
                            onPressed: () {
                              controller.onEmojiClicked();
                              controller.focusNode.unfocus();
                              controller.focusNode.canRequestFocus = true;
                            },
                            icon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.emoji_emotions_rounded,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Offstage(
                        offstage: !controller.isEmojiVisible.value,
                        child: SizedBox(
                          height: 250,
                          child: EmojiPicker(
                            onEmojiSelected: (Category category, Emoji emoji) {
                              controller.nameController.text += emoji.emoji;
                            },
                            config: Config(
                              columns: 7,
                              emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                              noRecents: const Text(
                                'No Recents',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black26),
                                textAlign: TextAlign.center,
                              ),
                              buttonMode: ButtonMode.CUPERTINO,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
