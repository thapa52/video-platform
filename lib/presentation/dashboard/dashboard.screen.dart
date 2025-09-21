import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app_colors.dart';
import 'controllers/dashboard.controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Obx(
          () {
            return AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              toolbarHeight: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: controller.currentIndex.value == 4
                    ? Color(0xFFE3F1D1)
                    : Colors.white,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.black,
                systemNavigationBarDividerColor: Colors.black,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.black,
          elevation: 10,
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            if (index < controller.pages.length) {
              // Prevent invalid index selection
              controller.changeTab(index);
            }
          },
          selectedItemColor: AppColors.red,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: "My List",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
          //  controller.userRole.value == 'employee'
          //     ? [
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.home_outlined),
          //           label: "Home",
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.timer_outlined),
          //           label: "Time Track",
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.calendar_today_outlined),
          //           label: "Schedule",
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.person),
          //           label: "Profile",
          //         ),
          //       ]
          //     : [
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.home_outlined),
          //           label: "Home",
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.access_time),
          //           label: "Activity",
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.timer_outlined),
          //           label: "Time Track",
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.calendar_today_outlined),
          //           label: "Schedule",
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.person),
          //           label: "Profile",
          //         ),
          //       ],
        ),
      ),
      body: Obx(
        () {
          int index = controller.currentIndex.value;
          if (index < 0 || index >= controller.pages.length) {
            index = 0; // Reset to a valid index
            controller.currentIndex.value = 0;
          }
          return controller.pages[index];
        },
      ),
    );
  }
}
