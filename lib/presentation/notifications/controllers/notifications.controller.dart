import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/core/interfaces/utility.dart';
import '../../../infrastructure/dal/daos/printlog.dart';
import '../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../infrastructure/dal/services/api/api_response.dart';
import '../../../infrastructure/theme/app_colors.dart';

class NotificationsController extends GetxController {
  final loading = false.obs;
  final checkInLoading = false.obs;
  final checkOutLoading = false.obs;
  final checkInNotificationList = [].obs;
  final checkOutNotificationList = [].obs;

  Future<void> initNotifications() async {
    loading.value = true;
    getCheckInNotifications();
    getCheckOutNotifications();
    loading.value = false;
  }

  Future<void> getCheckInNotifications() async {
    checkInLoading.value = true;
    try {
      final response =
          await ApiResponse().getNotifications(status: 'CHECKED_IN');
      printLog('checkedIn response->$response');
      checkInNotificationList.value = [];
      if (response.isNotEmpty) {
        checkInNotificationList.addAll(response['checkInRecordDTO']);
        printLog('checkInNotificationList->$checkInNotificationList');
      }
      checkInLoading.value = false;
    } catch (e) {
      checkInLoading.value = false;
    }
  }

  Future<void> getCheckOutNotifications() async {
    checkOutLoading.value = true;
    try {
      final response =
          await ApiResponse().getNotifications(status: 'CHECKED_OUT');
      printLog('checkedOut response->$response');
      checkOutNotificationList.value = [];
      if (response.isNotEmpty) {
        checkOutNotificationList.addAll(response['checkInRecordDTO']);
        printLog('checkOutNotificationList->$checkOutNotificationList');
      }
      checkOutLoading.value = false;
    } catch (e) {
      checkOutLoading.value = false;
    }
  }

  String getMessageForDate(DateTime? date) {
    printLog('date $date');
    if (date == null) return '';

    if (DateUtils.isSameDay(date, DateTime.now())) {
      return 'Today';
    } else {
      return Utility().getFullDate(date.toString());
    }
  }

  buildNotificationWidget(data, String type) {
    final isCheckOut = type.toLowerCase() == 'checkout';

    final time = Utility().getTime(
      isCheckOut ? data['checkOutTime'] : data['checkInTime'],
    );

    final label = isCheckOut ? 'Check-Out' : 'Check-In';
    final labelColor = isCheckOut ? AppColors.red[700] : AppColors.brand[700];

    return ListTile(
      leading: isCheckOut
          ? Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: AppColors.brand[50],
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: Alignment.center,
                child: TextWidget(
                  text: Utility().getInitials(fullName: data['fullName']),
                  textColor: const Color(0xFF344054),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            )
          : Container(
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
                      text: Utility().getInitials(fullName: data['fullName']),
                      textColor: const Color(0xFF344054),
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
                          color: AppColors.brand[900], shape: BoxShape.circle),
                    ),
                  )
                ],
              ),
            ),
      title: TextWidget(
        text: '${data['fullName']}',
        textColor: AppColors.text[900],
        fontWeight: FontWeight.w500,
      ),
      subtitle: TextWidget(
        text: '${data['siteName']}',
        textColor: AppColors.text,
      ),
      trailing: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextWidget(
              text: time,
              textColor: AppColors.text[900],
              fontWeight: FontWeight.w500,
            ),
            TextWidget(
              text: label,
              textColor: labelColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refreshNotifications() async {
    await initNotifications();
  }

  @override
  void onInit() {
    super.onInit();
    initNotifications();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
