import 'package:chatapp/app/data/color/color.dart';
import 'package:chatapp/app/data/firebase/firebase.dart';
import 'package:chatapp/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:chatapp/app/modules/profile/views/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

class DashboardSettingsView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
        backgroundColor: mainColor,
        elevation: 0,
      ),
      backgroundColor: whiteColor,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(controller.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("No data"),
              );
            } else {
              var userData = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: (userData!["image"] == "")
                              ? SvgPicture.asset(
                                  "assets/images/avatar.svg",
                                  width: 70,
                                )
                              : Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    userData["image"],
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData["name"],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              userData["status"],
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        listSettings(
                          Icons.person,
                          "Account",
                          Icons.arrow_forward_ios,
                          () {
                            Get.to(() => ProfileView());
                          },
                          false,
                        ),
                        listSettings(
                          Icons.help,
                          "Help",
                          Icons.arrow_forward_ios,
                          () {},
                          false,
                        ),
                        listSettings(
                          Icons.dangerous,
                          "Logout",
                          Icons.arrow_forward_ios,
                          () {
                            Get.dialog(AlertDialog(
                              title: Text("Logout"),
                              content: Text("Are you sure you want to logout?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FirebaseService().logOut(context);
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            ));
                          },
                          true,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }

  Material listSettings(lIcon, title, tIcon, onTap, isLogout) {
    return Material(
      color: whiteColor,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (isLogout == true) ? Colors.red : mainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              lIcon,
              size: 30,
              color: whiteColor,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            (isLogout == true) ? null : tIcon,
            color: mainColor,
          ),
        ),
      ),
    );
  }
}
