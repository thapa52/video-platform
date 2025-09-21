import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'controllers/profile.controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   toolbarHeight: 0,
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarColor: AppColors.white,
      //     statusBarIconBrightness: Brightness.dark,
      //     systemNavigationBarColor: AppColors.white,
      //     systemNavigationBarDividerColor: AppColors.white,
      //     systemNavigationBarIconBrightness: Brightness.light,
      //   ),
      // ),
      // body: SafeArea(
      //   child: SingleChildScrollView(
      //     child: Container(
      //       decoration: BoxDecoration(
      //         color: const Color(0xFFFCFCFD),
      //       ),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           SizedBox(
      //             height: 250,
      //             width: double.infinity,
      //             child: Stack(
      //               children: [
      //                 Align(
      //                   alignment: Alignment.topCenter,
      //                   child: Container(
      //                     height: 180,
      //                     width: double.infinity,
      //                     decoration: BoxDecoration(
      //                       color: AppColors.brand[100],
      //                       borderRadius: const BorderRadius.vertical(
      //                         bottom: Radius.elliptical(200, 50),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Align(
      //                   alignment: Alignment.bottomCenter,
      //                   child: Container(
      //                     height: 154,
      //                     width: 154,
      //                     decoration: BoxDecoration(
      //                       color: AppColors.brand[100],
      //                       shape: BoxShape.circle,
      //                       border: Border.all(
      //                         color: AppColors.white,
      //                         width: 6,
      //                       ),
      //                     ),
      //                     child: Center(
      //                       child: TextWidget(
      //                         text: Utility().getInitials(
      //                             fullName: GetStorage().read('userName')),
      //                         textColor: Color(0xFF344054),
      //                         fontSize: 56,
      //                         fontWeight: FontWeight.w600,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           Container(
      //             margin: EdgeInsets.only(top: 20),
      //             child: TextWidget(
      //               text: '${GetStorage().read('userName')}',
      //               textColor: Color(0xFF182230),
      //               fontSize: 20,
      //               fontWeight: FontWeight.w600,
      //             ),
      //           ),
      //           Container(
      //             margin: EdgeInsets.only(top: 10),
      //             child: TextWidget(
      //               text: '${GetStorage().read('userRole')}',
      //               textColor: Color(0xFF475467),
      //               fontSize: 14,
      //             ),
      //           ),
      //           Container(
      //             width: double.infinity,
      //             margin: EdgeInsets.only(top: 30, left: 20, right: 20),
      //             child: TextWidget(
      //               text: 'Profile',
      //               textColor: AppColors.text,
      //               fontSize: 14,
      //               fontWeight: FontWeight.w500,
      //             ),
      //           ),
      //           Container(
      //             width: double.infinity,
      //             margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      //             padding: EdgeInsets.symmetric(vertical: 10),
      //             decoration: BoxDecoration(
      //               color: AppColors.white,
      //               borderRadius: BorderRadius.circular(8),
      //             ),
      //             child: Column(
      //               children: [
      //                 ListTile(
      //                   onTap: () {
      //                     Get.toNamed('profile-setting');
      //                   },
      //                   leading: Icon(
      //                     Icons.person,
      //                     color: AppColors.text[700],
      //                   ),
      //                   title: TextWidget(
      //                     text: 'Profile Setting',
      //                     textColor: Color(0xFF313131),
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                   trailing: Icon(
      //                     Icons.arrow_forward_ios_rounded,
      //                     color: AppColors.text[700],
      //                     size: 20,
      //                   ),
      //                 ),
      //                 Obx(
      //                   () => controller.userRole.value == 'employee'
      //                       ? Container()
      //                       : Padding(
      //                           padding:
      //                               const EdgeInsets.symmetric(horizontal: 20),
      //                           child: Divider(),
      //                         ),
      //                 ),
      //                 Obx(
      //                   () => controller.userRole.value == 'employee'
      //                       ? Container()
      //                       : ListTile(
      //                           onTap: () {
      //                             Get.toNamed('profile-member');
      //                           },
      //                           leading: Icon(
      //                             Icons.person_2_outlined,
      //                             color: AppColors.text[700],
      //                           ),
      //                           title: TextWidget(
      //                             text: 'Members',
      //                             textColor: Color(0xFF313131),
      //                             fontSize: 14,
      //                             fontWeight: FontWeight.w500,
      //                           ),
      //                           trailing: Icon(
      //                             Icons.arrow_forward_ios_rounded,
      //                             color: AppColors.text[700],
      //                             size: 20,
      //                           ),
      //                         ),
      //                 ),
      //                 // Padding(
      //                 //   padding: const EdgeInsets.symmetric(horizontal: 20),
      //                 //   child: Divider(),
      //                 // ),
      //                 // ListTile(
      //                 //   leading: Icon(
      //                 //     Icons.ssid_chart,
      //                 //     color: AppColors.text[700],
      //                 //   ),
      //                 //   title: TextWidget(
      //                 //     text: 'Report',
      //                 //     textColor: Color(0xFF313131),
      //                 //     fontSize: 14,
      //                 //     fontWeight: FontWeight.w500,
      //                 //   ),
      //                 //   trailing: Icon(
      //                 //     Icons.arrow_forward_ios_rounded,
      //                 //     color: AppColors.text[700],
      //                 //     size: 20,
      //                 //   ),
      //                 // ),
      //               ],
      //             ),
      //           ),
      //           GestureDetector(
      //             onTap: () {
      //               controller.confirmLogout();
      //             },
      //             child: Container(
      //               margin: EdgeInsets.only(top: 60, left: 20, right: 20),
      //               padding: EdgeInsets.all(20),
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.circular(8),
      //               ),
      //               child: Row(
      //                 children: [
      //                   Icon(
      //                     Icons.logout,
      //                     color: Color(0xFF475467),
      //                   ),
      //                   SizedBox(
      //                     width: 10,
      //                   ),
      //                   TextWidget(
      //                     text: 'Log out',
      //                     textColor: Color(0xFF475467),
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
