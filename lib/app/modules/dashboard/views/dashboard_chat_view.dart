import 'package:chatapp/app/data/color/color.dart';
import 'package:chatapp/app/modules/chat/views/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

class DashboardChatView extends GetView {
  final auth = FirebaseAuth.instance;
  get uid => auth.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text('ChatMe'),
        backgroundColor: mainColor,
        elevation: 0,
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(uid)
              .collection('messages')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return Center(
                  child: Text("No Chats Available !"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var friendId = snapshot.data.docs[index].id;
                  var type = snapshot.data.docs[index]['type'];
                  var lastMsg = snapshot.data.docs[index]['last_message'];
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(friendId)
                        .get(),
                    builder: (context, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        var friend = asyncSnapshot.data;
                        return ListTile(
                          leading: Container(
                            width: 50,
                            decoration: BoxDecoration(
                              color: mainColor,
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: (friend["image"] == "")
                                  ? SvgPicture.asset(
                                      "assets/images/avatar.svg",
                                    )
                                  : Image.network(
                                      friend['image'],
                                      height: 50,
                                      width: 50,
                                    ),
                            ),
                          ),
                          title: Text(friend['name']),
                          subtitle: Container(
                            child: Text(
                              (type == "image") ? "Image" : "$lastMsg",
                              style: TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onTap: () {
                            Get.to(
                              () => ChatView(),
                              arguments: [
                                friend['image'],
                                friend['name'],
                                friend['uId'],
                                uid,
                              ],
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  );
                },
              );
            }
            return Center(
              child: LinearProgressIndicator(
                color: mainColor,
                backgroundColor: whiteColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
