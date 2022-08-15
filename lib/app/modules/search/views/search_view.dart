import 'package:chatapp/app/data/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: whiteColor,
        title: Container(
          margin: EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Expanded(
                child: Form(
                  key: _phoneKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Phone number is required";
                      } else if (value[0] != "+") {
                        return "example : +6289xxxxxxxxxx";
                      } else if (value.length < 14) {
                        return "Must be 11 or 12 digits";
                      } else if (value.length > 15) {
                        return "Must be 11 or 12 digits";
                      } else {
                        return null;
                      }
                    },
                    controller: controller.searchC,
                    decoration: InputDecoration(
                      enabledBorder: inputBorder(blackColor, 1),
                      focusedBorder: inputBorder(mainColor, 2),
                      border: inputBorder(mainColor, 2),
                      hintText: "Search phone number",
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    autofocus: true,
                    cursorColor: mainColor,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_phoneKey.currentState!.validate()) {
                    controller.onSearch();
                  }
                },
                child: Text("Search"),
                style: ElevatedButton.styleFrom(
                  primary: mainColor,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            controller.searchResult.clear();
            controller.searchC.clear();
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ),
        ),
        elevation: 0,
      ),
      body: Obx(
        () => Container(
          width: Get.width,
          child: Column(
            children: [
              (!controller.isLoading.value)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: controller.searchResult.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Get.dialog(AlertDialog(
                                title: Text(
                                    "Add ${controller.searchResult[index]["name"]}"),
                                content: Text(
                                    "Are you sure you want to add ${controller.searchResult[index]["name"]} to your contact?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.onSave(index);
                                      Get.back();
                                    },
                                    child: Text("Yes"),
                                  ),
                                ],
                              ));
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: (controller.searchResult[index]["image"] ==
                                      "")
                                  ? SvgPicture.asset(
                                      "assets/images/avatar.svg",
                                      width: 50,
                                    )
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        controller.searchResult[index]["image"],
                                      ),
                                    ),
                            ),
                            title: Text(controller.searchResult[index]["name"]),
                            subtitle:
                                Text(controller.searchResult[index]["number"]),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: LinearProgressIndicator(
                        color: mainColor,
                        backgroundColor: whiteColor,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder inputBorder(color, double width) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
