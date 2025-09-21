import 'package:get/get.dart';

import '../../../../../domain/core/interfaces/utility.dart';
import '../../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../../infrastructure/dal/services/api/api_response.dart';

class ScheduleDetailsController extends GetxController {
  final loading = false.obs;
  final id = ''.obs;
  final userName = 'loading'.obs;
  final date = ''.obs;

  final shiftSchedule = {}.obs;
  final userSiteStatus = {}.obs;

  final siteName = ''.obs;
  final siteLocation = ''.obs;
  final siteLatitude = 0.0.obs;
  final siteLongitude = 0.0.obs;

  final totalSeconds = 0.obs;
  final checkInTime = '-'.obs;
  final checkOutTime = '-'.obs;

  Future<void> initScheduleDetails() async {
    loading.value = true;
    printLog('id $id');
    await shiftById();
    loading.value = false;
  }

  Future<void> shiftById() async {
    shiftSchedule.value = {};
    userSiteStatus.value = {};
    try {
      final res = await ApiResponse().getShiftById(id);
      printLog('res shift data by id $res');

      if (res.isNotEmpty) {
        shiftSchedule.addAll(res['shiftSchedule']);
        userSiteStatus.addAll(res['userSiteStatus']);

        date.value = shiftSchedule['date'];

        if (shiftSchedule.containsKey('user') &&
            shiftSchedule['user'] != null) {
          userName.value =
              '${shiftSchedule['user']['firstName']} ${shiftSchedule['user']['lastName']}';
        }

        if (shiftSchedule.containsKey('site') &&
            shiftSchedule['site'] != null) {
          siteName.value = shiftSchedule['site']['siteName'];
          siteLocation.value = shiftSchedule['site']['location'];
          siteLatitude.value = shiftSchedule['site']['latitude'];
          siteLongitude.value = shiftSchedule['site']['longitude'];
        }

        if (userSiteStatus.containsKey('checkInRecordResponseDTO') &&
            userSiteStatus['checkInRecordResponseDTO'] != null) {
          final record = {}.obs;
          record.addAll(userSiteStatus['checkInRecordResponseDTO']);

          totalSeconds.value = record['totalSeconds'];
          checkInTime.value = Utility().getTime(record['checkInTime']);
          checkOutTime.value = Utility().getTime(record['checkOutTime']);
        }
      }
    } catch (e) {
      printLog('Error while fetching shift details by id: $e');
    }
  }

  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    id.value = args['id'] ?? '';
    initScheduleDetails();
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
