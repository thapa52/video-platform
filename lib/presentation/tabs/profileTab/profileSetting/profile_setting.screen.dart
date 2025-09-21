import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../domain/core/interfaces/utility.dart';
import '../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import 'controllers/profile_setting.controller.dart';

class ProfileSettingScreen extends GetView<ProfileSettingController> {
  const ProfileSettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.text,
          ),
        ),
        toolbarHeight: 100,
        title: TextWidget(
          text: 'Profile Setting',
          textColor: Color(0xFF182230),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarDividerColor: AppColors.white,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Divider(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 154,
                width: 154,
                decoration: BoxDecoration(
                  color: AppColors.brand[100],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: TextWidget(
                    text: Utility()
                        .getInitials(fullName: GetStorage().read('userName')),
                    textColor: Color(0xFF344054),
                    fontSize: 42,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextWidget(
                text: 'Your Profile',
                textColor: Color(0xFF182230),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10, bottom: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextWidget(
                text:
                    'You can update your personal information and change PIN as required. ',
                textColor: Color(0xFF667085),
                fontSize: 14,
              ),
            ),
            ListTile(
              onTap: () {
                Get.toNamed('personal-information');
              },
              leading: Icon(
                Icons.person_2_outlined,
                color: AppColors.text[700],
              ),
              title: TextWidget(
                text: 'Personal Information',
                textColor: AppColors.text[900],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF667085),
                size: 20,
              ),
            ),
            Divider(),
            // ListTile(
            //   onTap: () {},
            //   leading: Icon(
            //     Icons.security,
            //     color: AppColors.text[700],
            //   ),
            //   title: TextWidget(
            //     text: 'Login & Security',
            //     textColor: AppColors.text[900],
            //     fontSize: 14,
            //     fontWeight: FontWeight.w500,
            //   ),
            //   trailing: Icon(
            //     Icons.arrow_forward_ios_rounded,
            //     color: Color(0xFF667085),
            //     size: 20,
            //   ),
            // ),
            // Divider(),
          ],
        ),
      ),
    );
  }
}
