import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../infrastructure/dal/daos/printlog.dart';
import '../../../infrastructure/dal/daos/setStorage/storage.dart';
import '../../../infrastructure/dal/daos/widgets/snackbar_widget.dart';
import '../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../infrastructure/dal/services/firebase/firebase_push_notification.dart';
import '../../../infrastructure/dal/services/middleware/biometric_auth.dart';
import '../../../infrastructure/navigation/bindings/controller_handler.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../tabs/explore/controllers/explore.controller.dart';
import '../../tabs/homeTab/home/controllers/home.controller.dart';
import '../../tabs/jobActivity/controllers/job_activity.controller.dart';
import '../../tabs/my_list/controllers/my_list.controller.dart';
import '../../tabs/profileTab/profile/controllers/profile.controller.dart';
import '../../tabs/scheduleTab/schedule/controllers/schedule.controller.dart';
import '../../tabs/timeTrack/controllers/time_track.controller.dart';
import '../../screens.dart';

class DashboardController extends GetxController {
  late BiometricAuth biometricAuth;
  final loading = false.obs;
  final currentIndex = 0.obs;
  final userRole = ''.obs;
  final neverShowBiometricSheet = false.obs;

  Future<void> initDashboard() async {
    loading.value = true;
    userRole.value = GetStorage().read('userRole').toString().toLowerCase();
    printLog('userRole $userRole');
    await biometricAccessLogic();
    loading.value = false;
  }

  // List<Widget> get pages =>
  //     userRole.value == 'employee' ? memberPages : adminPages;

  // final List<Widget> adminPages = [
  //   HomeScreen(),
  //   JobActivityScreen(),
  //   TimeTrackScreen(),
  //   ScheduleScreen(),
  //   ProfileScreen()
  // ];

  // final List<Widget> memberPages = [
  //   HomeScreen(),
  //   TimeTrackScreen(),
  //   ScheduleScreen(),
  //   ProfileScreen()
  // ];

  final List<Widget> pages = [
    HomeScreen(),
    ExploreScreen(),
    MyListScreen(),
    ProfileScreen()
  ];

  void changeTab(int index) {
    currentIndex.value = index;
    controllerMap[index]?.handle();
  }

  /// Get the controller map based on user role
  // Map<int, ControllerHandler> get controllerMap =>
  //     userRole.value == 'employee' ? memberControllerMap : adminControllerMap;

  final Map<int, ControllerHandler> controllerMap = {
    0: ControllerHandler<HomeController>(
      creator: () => HomeController(),
      onFound: (controller) => controller.refreshHome(),
    ),
    1: ControllerHandler<ExploreController>(
      creator: () => ExploreController(),
      onFound: (controller) => controller.refreshExplore(),
    ),
    2: ControllerHandler<MyListController>(
      creator: () => MyListController(),
      onFound: (controller) => controller.refreshMyList(),
    ),
    3: ControllerHandler<ProfileController>(
      creator: () => ProfileController(),
      onFound: (controller) => controller.refreshProfile(),
    ),
  };

  // final Map<int, ControllerHandler> adminControllerMap = {
  //   0: ControllerHandler<HomeController>(
  //     creator: () => HomeController(),
  //     onFound: (controller) => controller.refreshHome(),
  //   ),
  //   1: ControllerHandler<JobActivityController>(
  //     creator: () => JobActivityController(),
  //     onFound: (controller) => controller.refreshJobActivity(),
  //   ),
  //   2: ControllerHandler<TimeTrackController>(
  //     creator: () => TimeTrackController(),
  //     onFound: (controller) => controller.refreshTimeTrack(),
  //   ),
  //   3: ControllerHandler<ScheduleController>(
  //     creator: () => ScheduleController(),
  //     onFound: (controller) => controller.refreshSchedule(),
  //   ),
  //   4: ControllerHandler<ProfileController>(
  //     creator: () => ProfileController(),
  //     onFound: (controller) => controller.refreshProfile(),
  //   ),
  // };

  // final Map<int, ControllerHandler> memberControllerMap = {
  //   0: ControllerHandler<HomeController>(
  //     creator: () => HomeController(),
  //     onFound: (controller) => controller.refreshHome(),
  //   ),
  //   1: ControllerHandler<TimeTrackController>(
  //     creator: () => TimeTrackController(),
  //     onFound: (controller) => controller.refreshTimeTrack(),
  //   ),
  //   2: ControllerHandler<ScheduleController>(
  //     creator: () => ScheduleController(),
  //     onFound: (controller) => controller.refreshSchedule(),
  //   ),
  //   3: ControllerHandler<ProfileController>(
  //     creator: () => ProfileController(),
  //     onFound: (controller) => controller.refreshProfile(),
  //   ),
  // };

  Future<void> biometricAccessLogic() async {
    neverShowBiometricSheet.value =
        GetStorage().read('neverEnableBiometric') == true ||
            GetStorage().read('isBiometricEnabled') == true;

    await Future.delayed(
      Duration(milliseconds: 100),
    );

    if (neverShowBiometricSheet.value == false) {
      biometricAccessBottomSheet();
    }
  }

  Future<void> biometricAccessBottomSheet() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Get.bottomSheet(
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: SvgPicture.asset(
                    'assets/images/fingerprint.svg',
                    width: 60,
                    height: 60,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextWidget(
                    text: 'Biometric Access',
                    textColor: AppColors.text[900],
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextWidget(
                    text:
                        'Now you can use your biometric to quickly login access to the app.',
                    textAlign: TextAlign.center,
                    textColor: AppColors.text[900],
                    fontSize: 14,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool hasSetup = await biometricAuth.isBiometricSetup();

                    if (hasSetup) {
                      Storage().setIsBiometricEnabled(isBiometricEnabled: true);
                      Get.back();
                      SnackbarWidget(
                        title: "Biometric Enabled",
                        message: "Fingerprint access is now enabled.",
                      );
                    } else {
                      Storage()
                          .setIsBiometricEnabled(isBiometricEnabled: false);
                      Get.back();
                      SnackbarWidget(
                        title: '"Biometric Not Setup',
                        message:
                            'Please set up fingerprint in your device settings first.',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand[700],
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: TextWidget(
                    text: 'Enable Biometric Access',
                    textColor: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 10),
                  child: TextWidget(
                    text: 'or',
                    textColor: AppColors.text[900],
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Storage().setIsBiometricEnabled(isBiometricEnabled: false);
                    Storage()
                        .setNeverEnableBiometric(neverEnableBiometric: true);
                    Get.back();
                  },
                  child: TextWidget(
                    text: 'Never Ask Again',
                    textColor: AppColors.brand[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> refreshDashboard() async {
    biometricAuth = Get.put(BiometricAuth());
    controllerMap[0]?.handle();
    initDashboard();
  }

  @override
  void onInit() async {
    super.onInit();
    // biometricAuth = Get.put(BiometricAuth());
    controllerMap[0]?.handle();
    // FirebasePushNotification().initNotifications();
    // initDashboard();
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
