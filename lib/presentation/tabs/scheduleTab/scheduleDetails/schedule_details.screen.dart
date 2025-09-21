import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../domain/core/interfaces/utility.dart';
import '../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../infrastructure/dal/services/map/map_service.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import 'controllers/schedule_details.controller.dart';

class ScheduleDetailsScreen extends GetView<ScheduleDetailsController> {
  const ScheduleDetailsScreen({super.key});
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
        title: Obx(
          () => TextWidget(
            text: '${controller.userName}',
            textColor: const Color(0xFF182230),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
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
      body: Obx(
        () => controller.loading.value == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Date:',
                            textColor: AppColors.text[900],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          TextWidget(
                            text: Utility()
                                .getFullDate(controller.date.toString()),
                            textColor: AppColors.text[900],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Time',
                            textColor: AppColors.text[900],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          TextWidget(
                            text: Utility().getTimeInHMS(
                                controller.totalSeconds.value.toInt()),
                            textColor: AppColors.brand[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Check In:  ${controller.checkInTime.value}',
                            textColor: AppColors.text[900],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          TextWidget(
                            text:
                                'Check Out:  ${controller.checkOutTime.value}',
                            textColor: AppColors.text[900],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextWidget(
                        text: '${controller.siteName}',
                        textColor: AppColors.text[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextWidget(
                        text: '${controller.siteLocation}',
                        textColor: AppColors.text,
                        fontSize: 14,
                      ),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.all(20),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MapWidget(
                        latitude: controller.siteLatitude.value,
                        longitude: controller.siteLongitude.value,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
