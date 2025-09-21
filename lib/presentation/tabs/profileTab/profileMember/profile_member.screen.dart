import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../domain/core/interfaces/utility.dart';
import '../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import 'controllers/profile_member.controller.dart';

class ProfileMemberScreen extends GetView<ProfileMemberController> {
  const ProfileMemberScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            text: 'Members',
            textColor: const Color(0xFF182230),
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
            preferredSize: Size.fromHeight(50),
            child: Column(
              children: [
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white, // Background color of tab
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: AppColors.gray, // Active tab color
                      borderRadius:
                          BorderRadius.circular(25), // Rounded active tab
                    ),
                    labelColor: AppColors.black,
                    unselectedLabelColor: AppColors.black,
                    textScaler: TextScaler.linear(1.0),
                    overlayColor: WidgetStateProperty.all(AppColors.white),
                    tabs: [
                      Tab(
                        child: TextWidget(
                          text: 'Active',
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.text[800],
                        ),
                      ),
                      Tab(
                        child: TextWidget(
                          text: 'Inactive',
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.text[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Obx(
          () => controller.loading.value == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                      ),
                      child: controller.checkedInList.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.checkedInList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var active = controller.checkedInList[index];
                                return SizedBox(
                                  child: ListTile(
                                    onTap: () {},
                                    leading: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.brand[50],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: TextWidget(
                                              text: Utility().getInitials(
                                                  fullName:
                                                      active['userName']!),
                                              textColor:
                                                  const Color(0xFF344054),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                  color: AppColors.brand[900],
                                                  shape: BoxShape.circle),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    title: TextWidget(
                                      text: '${active['userName']}',
                                      textColor: AppColors.text[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    subtitle: TextWidget(
                                      text:
                                          '${active['userRole'].toString().capitalize}',
                                      textColor: AppColors.text,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Center(
                                child: TextWidget(
                                  text:
                                      'There are no checked in members available.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: controller.checkedOutList.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.checkedOutList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var inactive = controller.checkedOutList[index];
                                return SizedBox(
                                  child: ListTile(
                                    onTap: () {},
                                    leading: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.brand[50],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: TextWidget(
                                          text: Utility().getInitials(
                                              fullName: inactive['userName']!),
                                          textColor: const Color(0xFF344054),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    title: TextWidget(
                                      text: '${inactive['userName']}',
                                      textColor: AppColors.text[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    subtitle: TextWidget(
                                      text:
                                          '${inactive['userRole'].toString().capitalize}',
                                      textColor: AppColors.text,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Center(
                                child: TextWidget(
                                  text:
                                      'There are no checked out members available.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
