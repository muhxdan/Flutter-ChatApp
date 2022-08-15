import 'package:chatapp/app/data/color/color.dart';
import 'package:chatapp/app/modules/chat/views/chat_view.dart';
import 'package:chatapp/app/modules/search/controllers/search_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DashboardContactView extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    Get.put(SearchController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
        elevation: 0,
        backgroundColor: mainColor,
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () => Get.toNamed("/search"),
            icon: Icon(Icons.person_add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("contacts")
            .doc(controller.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var dataContact = snapshot.data;
            if (List.from(dataContact["contacts"]).isEmpty) {
              return Center(
                child: Text("No contact available!"),
              );
            }
            return StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, AsyncSnapshot asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return Center(
                    child: LinearProgressIndicator(
                      color: mainColor,
                      backgroundColor: whiteColor,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: asyncSnapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    final dataUser = asyncSnapshot.data!.docs[index];
                    if (asyncSnapshot.hasData) {
                      for (var i = 0;
                          i < List.from(dataContact["contacts"]).length;
                          i++) {
                        if (dataContact["contacts"][i] == dataUser["number"]) {
                          return ListTile(
                            onTap: () {
                              Get.to(() => ChatView(), arguments: [
                                dataUser["image"],
                                dataUser["name"],
                                dataUser["uId"],
                                controller.uid,
                              ]);
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: (dataUser["image"] == "")
                                  ? SvgPicture.asset(
                                      "assets/images/avatar.svg",
                                      width: 55,
                                    )
                                  : Container(
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        dataUser["image"],
                                      ),
                                    ),
                            ),
                            title: Text(dataUser["name"]),
                            subtitle: Text(dataUser["number"]),
                          );
                        }
                      }
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
    );
  }
}


// StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection("users").snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Center(
//               child: Text("No data"),
//             );
//           } else {
//             var userData = snapshot.data!.docs;
//             return Container(
//               padding: EdgeInsets.symmetric(vertical: 10),
//               child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('contacts')
//                     .doc(controller.uid)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Container(
//                       child: Text('waiting'),
//                     );
//                   }

//                   if (List.from(snapshot.data!["contacts"]).isNotEmpty) {
//                     return Container(
//                       child: ListView(
//                         children: userData.map(
//                           (data) {
//                             for (var index = 0;
//                                 index <
//                                     List.from(snapshot.data!["contacts"])
//                                         .length;
//                                 index++) {
//                               if (snapshot.data!["contacts"][index] ==
//                                   data["number"]) {
//                                 return ListTile(
//                                   onTap: () {
//                                     Get.to(() => ChatView(), arguments: [
//                                       data["image"],
//                                       data["name"],
//                                       data["uId"],
//                                       controller.uid,
//                                     ]);
//                                   },
//                                   leading: Container(
//                                     width: 55,
//                                     height: 55,
//                                     decoration: BoxDecoration(
//                                       color: mainColor,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(50),
//                                       child: Image.network(
//                                         data["image"],
//                                       ),
//                                     ),
//                                   ),
//                                   title: Text(data["name"]),
//                                   subtitle: Text(data["number"]),
//                                 );
//                               }
//                             }
//                             return Container();
//                           },
//                         ).toList(),
//                       ),
//                     );
//                   }
//                   return Center(
//                     child: Text("No Contact"),
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),