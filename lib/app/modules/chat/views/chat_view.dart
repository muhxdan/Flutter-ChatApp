import 'dart:io';
import 'package:chatapp/app/data/color/color.dart';
import 'package:chatapp/app/modules/addProfile/controllers/add_profile_controller.dart';
import 'package:chatapp/app/modules/dashboard/views/dashboard_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final dataUser = Get.arguments;
  final TextEditingController chatC = TextEditingController();
  final addProfileC = Get.put(AddProfileController());
  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        toolbarHeight: 65,
        title: ListTile(
          onTap: () {},
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: (dataUser[0] == "")
                ? SvgPicture.asset(
                    "assets/images/avatar.svg",
                    width: 45,
                  )
                : Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: mainColor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      dataUser[0],
                    ),
                  ),
          ),
          title: Text(
            dataUser[1],
            style: TextStyle(
              color: whiteColor,
            ),
            maxLines: 1,
          ),
        ),
        titleSpacing: -20,
        leading: GestureDetector(
          onTap: () => Get.offAll(() => DashboardView()),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (addProfileC.isEmojiVisible.isTrue) {
            addProfileC.isEmojiVisible.value = false;
          } else {
            Get.offAll(() => DashboardView());
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chats")
                      .doc(dataUser[3])
                      .collection('messages')
                      .doc(dataUser[2])
                      .collection('data')
                      .orderBy("date", descending: false)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return Center(
                          child: Text("Say Hi to your friends :)"),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          bool isMe = snapshot.data.docs[index]['senderUid'] ==
                              dataUser[3];
                          return Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? mainColor
                                      : Color(
                                          0xFFF5F5F5,
                                        ),
                                  borderRadius: isMe
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(5),
                                        )
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 20),
                                      constraints: BoxConstraints(
                                        maxWidth: 180,
                                        minWidth: 30,
                                      ),
                                      child: (snapshot.data.docs[index]
                                                  ['type'] ==
                                              "image")
                                          ? Container(
                                              width: 200,
                                              height: 200,
                                              child: Image.network(
                                                snapshot.data.docs[index]
                                                    ['image'],
                                              ),
                                            )
                                          : Text(
                                              snapshot.data.docs[index]
                                                  ['message'],
                                              style: TextStyle(
                                                color: isMe
                                                    ? Colors.white
                                                    : blackColor,
                                              ),
                                            ),
                                    ),
                                    Text(
                                      DateFormat.jm().format(
                                        DateTime.parse(
                                          snapshot.data.docs[index]['date'],
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isMe
                                            ? whiteColor.withOpacity(.8)
                                            : blackColor.withOpacity(.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatC,
                      minLines: 1,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        prefixIcon: IconButton(
                          onPressed: () {
                            addProfileC.onEmojiClicked();
                            addProfileC.focusNode.unfocus();
                            addProfileC.focusNode.canRequestFocus = true;
                          },
                          splashRadius: 20,
                          icon: Icon(
                            Icons.emoji_emotions,
                            color: mainColor,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.showPicker(
                              context,
                              dataUser[2],
                              dataUser[3],
                            );
                          },
                          splashRadius: 20,
                          icon: Icon(
                            Icons.camera_alt,
                            color: mainColor,
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      focusNode: addProfileC.focusNode,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      splashRadius: 1,
                      onPressed: () {
                        String message = chatC.text;
                        chatC.clear();
                        controller.sendMessage(
                          dataUser[2],
                          dataUser[3],
                          message,
                        );
                      },
                      icon: Icon(
                        Icons.send,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Offstage(
                offstage: !addProfileC.isEmojiVisible.value,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (Category category, Emoji emoji) {
                      chatC.text += emoji.emoji;
                    },
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
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
    );
  }
}
