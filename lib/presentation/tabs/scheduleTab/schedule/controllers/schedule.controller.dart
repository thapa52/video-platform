import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../domain/core/interfaces/utility.dart';
import '../../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../../infrastructure/dal/services/api/api_response.dart';
import '../../../../../infrastructure/theme/app_colors.dart';

class ScheduleController extends GetxController {
  final selectedTabIndex = 0.obs;
  final userRole = ''.obs;
  final loading = false.obs;
  final teamShift = [].obs;
  final mineShift = [].obs;

  Future<void> initSchedule() async {
    loading.value = true;
    userRole.value = GetStorage().read('userRole').toString().toLowerCase();
    printLog('userRole $userRole');
    await shiftToday();
    userRole.value == 'employee' ? '' : await shiftTeam();
    loading.value = false;
  }

  Future<void> shiftToday() async {
    final res = await ApiResponse().getShiftToday();
    printLog('res today $res');
    if (res.isNotEmpty) {
      mineShift.value = [];
      mineShift.addAll(res);
    }
  }

  Future<void> shiftTeam() async {
    final res = await ApiResponse().getShiftTeam();
    printLog('res team $res');
    if (res.isNotEmpty) {
      teamShift.value = [];
      teamShift.addAll(res);
      printLog('res teamShift $teamShift');
    }
  }

  Future<void> refreshSchedule() async {
    print("Refreshing schedule...");
    await initSchedule();
  }

  buildShiftWidget(data) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('schedule-details',
            arguments: {'id': data['id'].toString()});
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.brand[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.brand[700],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextWidget(
                      text: Utility().getDay(data['date']).toString(),
                      textColor: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    TextWidget(
                      text: Utility().getMonthName(data['date']),
                      textColor: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: AppColors.brand[100],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: TextWidget(
                                text: Utility().getInitials(
                                  firstName: data['user']['firstName'],
                                  lastName: data['user']['lastName'],
                                ),
                                textColor: Color(0xFF344054),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextWidget(
                                text:
                                    '${data['user']['firstName']} ${data['user']['lastName']}',
                                textColor: AppColors.text[900],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 5),
                              TextWidget(
                                text: '${data['user']['role']}',
                                textColor: AppColors.text,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.map,
                          color: AppColors.text[700],
                        ),
                        SizedBox(width: 10),
                        TextWidget(
                          text: '${data['site']['siteName']}',
                          textColor: AppColors.text[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMineScheduleWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: mineShift.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: mineShift.length,
              itemBuilder: (context, index) {
                var mine = mineShift[index];
                return buildShiftWidget(mine);
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: SvgPicture.asset(
                    'assets/images/schedule-meeting.svg',
                    width: 100,
                    height: 100,
                  ),
                ),
                TextWidget(
                  text: 'No Shift Today',
                  textColor: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
    );
  }

  Widget buildTeamScheduleWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: teamShift.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: teamShift.length,
              itemBuilder: (context, index) {
                var team = teamShift[index];
                return buildShiftWidget(team);
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: SvgPicture.asset(
                    'assets/images/schedule-meeting.svg',
                    width: 100,
                    height: 100,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextWidget(
                    text: 'No Shift Today',
                    textColor: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('add-schedule-shift');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand[700],
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        color: AppColors.white,
                      ),
                      SizedBox(width: 10),
                      TextWidget(
                        text: 'Add a Shift',
                        textColor: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void onInit() {
    refreshSchedule();
    super.onInit();
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
