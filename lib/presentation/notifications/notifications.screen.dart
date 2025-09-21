import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../infrastructure/theme/app_colors.dart';
import 'controllers/notifications.controller.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});
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
            text: 'Notifications',
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
                          text: 'Check-In',
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.text[800],
                        ),
                      ),
                      Tab(
                        child: TextWidget(
                          text: 'Check-Out',
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
                    controller.checkInLoading.value == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: controller.checkInNotificationList.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                        .checkInNotificationList.length,
                                    itemBuilder: (context, index) {
                                      final checkIn = controller
                                          .checkInNotificationList[index];

                                      // Check if this is the first entry or if the date has changed
                                      bool isNewCheckInDate = (index == 0) ||
                                          (checkIn['notificationDate'] !=
                                              controller
                                                      .checkInNotificationList[
                                                  index -
                                                      1]['notificationDate']);

                                      bool isLastCheckInItem = index ==
                                          controller.checkInNotificationList
                                                  .length -
                                              1;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isNewCheckInDate)
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              child: TextWidget(
                                                text: controller
                                                    .getMessageForDate(DateTime
                                                        .tryParse(checkIn[
                                                            'notificationDate'])),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          controller.buildNotificationWidget(
                                              checkIn, 'checkin'),
                                          if (isNewCheckInDate &&
                                              !isLastCheckInItem)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              child: const Divider(
                                                color: AppColors.gray,
                                                thickness: 2,
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  )
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Center(
                                      child: TextWidget(
                                        text:
                                            'There are no Checked In notifications available.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                          ),
                    controller.checkOutLoading.value == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: controller
                                    .checkOutNotificationList.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                        .checkOutNotificationList.length,
                                    itemBuilder: (context, index) {
                                      final checkOut = controller
                                          .checkOutNotificationList[index];

                                      // Check if this is the first entry or if the date has changed
                                      bool isNewCheckOutDate = (index == 0) ||
                                          (checkOut['notificationDate'] !=
                                              controller
                                                      .checkOutNotificationList[
                                                  index -
                                                      1]['notificationDate']);

                                      bool isLastCheckOutItem = index ==
                                          controller.checkOutNotificationList
                                                  .length -
                                              1;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isNewCheckOutDate)
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              child: TextWidget(
                                                text: controller
                                                    .getMessageForDate(DateTime
                                                        .tryParse(checkOut[
                                                            'notificationDate'])),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          controller.buildNotificationWidget(
                                              checkOut, 'checkout'),
                                          if (isNewCheckOutDate &&
                                              !isLastCheckOutItem)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              child: const Divider(
                                                color: AppColors.gray,
                                                thickness: 2,
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  )
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Center(
                                      child: TextWidget(
                                        text:
                                            'There are no Checked Out notifications available.',
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
