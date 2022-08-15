import 'package:chatapp/app/data/color/color.dart';
import 'package:chatapp/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

final dashboardC = Get.put(DashboardController());

class ListData {
  Icon? leading;
  Icon? trailing;

  ListData({
    required this.leading,
    required this.trailing,
  });
}

List<ListData> listData = [
  ListData(
    leading: Icon(CupertinoIcons.person_fill, color: whiteColor),
    trailing: Icon(CupertinoIcons.pen, color: mainColor),
  ),
  ListData(
    leading: Icon(CupertinoIcons.info_circle_fill, color: whiteColor),
    trailing: Icon(CupertinoIcons.pen, color: mainColor),
  ),
  ListData(
    leading: Icon(CupertinoIcons.phone_fill, color: whiteColor),
    trailing: null,
  ),
];
