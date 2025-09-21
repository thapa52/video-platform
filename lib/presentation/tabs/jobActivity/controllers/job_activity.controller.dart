import 'package:get/get.dart';

import '../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../infrastructure/dal/services/api/api_response.dart';

class JobActivityController extends GetxController {
  final loading = false.obs;
  final checkedInLoading = false.obs;
  final checkedOutLoading = false.obs;
  final checkedInList = [].obs;
  final checkedOutList = [].obs;

  Future<void> initJobActivity() async {
    loading.value = true;
    await getCheckedInList();
    await getCheckedOutList();
    loading.value = false;
  }

  Future<void> getCheckedInList() async {
    checkedInLoading.value = true;
    try {
      final response =
          await ApiResponse().getCheckInTimeShift(status: 'checked_in');
      printLog('checkedIn response->$response');
      checkedInList.value = [];
      if (response.isNotEmpty) {
        checkedInList.addAll(response);
        printLog('checkedInList->$checkedInList');
      }
      checkedInLoading.value = false;
    } catch (e) {
      checkedInLoading.value = false;
      printLog('Error while fetching checked in list-> $e');
    }
  }

  Future<void> getCheckedOutList() async {
    checkedOutLoading.value = true;
    try {
      final response =
          await ApiResponse().getCheckInTimeShift(status: 'checked_out');
      printLog('checkedout response->$response');
      checkedOutList.value = [];
      if (response.isNotEmpty) {
        checkedOutList.addAll(response);
        printLog('checkedOutList->$checkedOutList');
      }
      checkedOutLoading.value = false;
    } catch (e) {
      checkedOutLoading.value = false;
      printLog('Error while fetching checked out list-> $e');
    }
  }

  Future<void> refreshJobActivity() async {
    printLog('refresh Job Activity');
    await initJobActivity();
  }

  @override
  void onInit() {
    initJobActivity();
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
