import 'package:chatapp/app/data/color/color.dart';
import 'package:chatapp/app/modules/dashboard/views/dashboard_chat_view.dart';
import 'package:chatapp/app/modules/dashboard/views/dashboard_contact_view.dart';
import 'package:chatapp/app/modules/dashboard/views/dashboard_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    return Scaffold(
      backgroundColor: whiteColor,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: [
          DashboardChatView(),
          DashboardContactView(),
          DashboardSettingsView(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: [
            navBarItem("icon_chat", "Chats", 0),
            navBarItem("icon_groups", "Contacts", 1),
            navBarItem("icon_settings", "Settings", 2),
          ],
          currentIndex: controller.page.value,
          selectedItemColor: mainColor,
          backgroundColor: whiteColor,
          elevation: 0,
          unselectedItemColor: Colors.grey,
          unselectedFontSize: 14,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          onTap: (index) {
            controller.onItemClick(index);
            controller.pageController.jumpToPage(index);
          },
          key: controller.bottomNavKey,
        ),
      ),
    );
  }

  BottomNavigationBarItem navBarItem(name, label, index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SvgPicture.asset(
          "assets/images/${name}.svg",
          color: (controller.page == index) ? mainColor : Colors.grey,
        ),
      ),
      label: label,
    );
  }
}
