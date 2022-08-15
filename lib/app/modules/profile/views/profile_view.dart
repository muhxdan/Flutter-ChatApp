import 'dart:io';
import 'package:chatapp/app/data/color/color.dart';
import 'package:chatapp/app/modules/addProfile/controllers/add_profile_controller.dart';
import 'package:chatapp/app/modules/profile/data/list_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final addProfileC = Get.put(AddProfileController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Profile"),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        backgroundColor: mainColor,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(controller.auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No data',
                ),
              );
            } else {
              var userData = snapshot.data;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      addProfileC.showPicker(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: (userData!["image"] == "")
                          ? SvgPicture.asset(
                              "assets/images/avatar.svg",
                              width: 130,
                            )
                          : Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: mainColor,
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                userData["image"],
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: List.generate(
                      listData.length,
                      (index) {
                        TextEditingController controllerText =
                            TextEditingController(
                          text: (index == 0)
                              ? userData["name"]
                              : (index == 1)
                                  ? userData["status"]
                                  : userData["number"],
                        );
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: ListTile(
                            onTap: () {
                              (index != 2)
                                  ? Get.bottomSheet(
                                      BottomSheet(
                                        formKey: formKey,
                                        controllerText: controllerText,
                                        index: index,
                                      ),
                                      barrierColor: Colors.transparent,
                                      backgroundColor: mainColor,
                                      isDismissible: true,
                                    )
                                  : null;
                            },
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: listData[index].leading,
                            ),
                            title: Text(
                              (index == 0)
                                  ? userData["name"]
                                  : (index == 1)
                                      ? userData["status"]
                                      : userData["number"],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: listData[index].trailing,
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  BottomSheet({
    Key? key,
    required this.formKey,
    required this.controllerText,
    required this.index,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController controllerText;
  final index;
  final addProfileC = Get.put(AddProfileController());
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: (addProfileC.isEmojiVisible.value) ? 500 : 200,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Enter your name",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name is required";
                        } else if (value.length > 25) {
                          return "Name must not be more than 25 char";
                        }
                        return null;
                      },
                      cursorColor: whiteColor,
                      focusNode: addProfileC.focusNode,
                      controller: controllerText,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(bottom: -20, left: 12, right: 12),
                        border: borderInput(),
                        enabledBorder: borderInput(),
                        focusedBorder: borderInput(),
                        errorBorder: borderInput(),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: IconButton(
                      iconSize: 27,
                      splashRadius: 20,
                      color: mainColor,
                      onPressed: () {
                        addProfileC.onEmojiClicked();
                        addProfileC.focusNode.unfocus();
                        addProfileC.focusNode.canRequestFocus = true;
                      },
                      icon: Icon(
                        Icons.emoji_emotions_rounded,
                        color: whiteColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: mainColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 0,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.updateUser(index, controllerText.text);
                    Get.back();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: mainColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 0,
                  ),
                ),
              ],
            ),
            Offstage(
              offstage: !addProfileC.isEmojiVisible.value,
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (Category category, Emoji emoji) {
                    controllerText.text += emoji.emoji;
                  },
                  config: Config(
                    columns: 7,
                    bgColor: whiteColor,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    noRecents: Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    buttonMode: ButtonMode.CUPERTINO,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder borderInput() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    );
  }
}
