import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/core/interfaces/utility.dart';
import '../../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../../infrastructure/dal/services/api/api_response.dart';
import '../../../../../infrastructure/dal/services/api/api_service.dart';
import '../../../../../infrastructure/dal/services/controllers/photo_controller.dart';
import '../../../../../infrastructure/dal/services/location/location_services.dart';
import '../../../../../infrastructure/dal/services/controllers/note_controller.dart';
import '../../../../../infrastructure/dal/services/timer/timer_services.dart';
import '../../../../../infrastructure/theme/app_colors.dart';

class SiteDetailsController extends GetxController {
  TimerService timerService = TimerService();
  final isCheckedIn = false.obs;
  final elapsedSeconds = 0.obs;
  final totalSeconds = 0.obs;

  late PhotoController photoController;
  final NoteController noteController = NoteController();
  final loading = false.obs;
  final siteId = ''.obs;
  final siteData = {}.obs;
  final siteName = 'loading'.obs;
  final location = ''.obs;
  final siteLatitude = 0.0.obs;
  final siteLongitude = 0.0.obs;

  final isAlreadyCheckIn = false.obs;
  final checkStatus = ''.obs;

  final userLatitude = 0.0.obs;
  final userLongitude = 0.0.obs;
  final checkInTime = '-'.obs;
  final checkOutTime = '-'.obs;
  final isCheckInLoading = false.obs;
  final isCheckOutLoading = false.obs;

  Future<void> initSiteDetails() async {
    loading.value = true;
    if (siteId.value != '') {
      await getSiteDetails();
      noteController.loadNotes();
      await checkInRecordUser();
    }
    loading.value = false;
  }

  Future<void> getSiteDetails() async {
    try {
      siteData.value = {};
      final response = await ApiResponse().getSiteDetailsById(siteId);
      printLog('site details response = $response');
      if (response.isNotEmpty) {
        siteData.addAll(response);
        printLog('site data = $siteData');
        if (siteData.containsKey('siteName')) {
          siteName.value = siteData['siteName'];
          printLog('site siteName = $siteName');
        }
        if (siteData.containsKey('location')) {
          location.value = siteData['location'];
          printLog('site location = $location');
        }
        if (siteData.containsKey('latitude')) {
          siteLatitude.value = siteData['latitude'];
          printLog('site siteLatitude = $siteLatitude');
        }
        if (siteData.containsKey('longitude')) {
          siteLongitude.value = siteData['longitude'];
          printLog('site siteLongitude = $siteLongitude');
        }
      }
    } catch (e) {
      printLog('Error while fetching site details by id :$e');
    }
  }

  Future<void> checkInRecordUser() async {
    final res = await ApiResponse().getCheckInRecordUser(siteId);
    printLog('checkInRecordUser res->$res');
    if (res.isNotEmpty) {
      await photoController.initData(res, siteId.toString());

      if (res.containsKey('checkInRecordResponseDTO') &&
          res['checkInRecordResponseDTO'] != null) {
        final record = {}.obs;
        record.addAll(res['checkInRecordResponseDTO']);

        checkInTime.value = Utility().getTime(record['checkInTime']);
        checkOutTime.value = Utility().getTime(record['checkOutTime']);

        totalSeconds.value = record['totalSeconds'];
        elapsedSeconds.value = totalSeconds.value;

        // ✅ Call updateNote only if notes is not empty
        final notes = record['notes'];
        printLog('notes res->$notes');
        if (notes != null && notes.toString().trim().isNotEmpty) {
          noteController.updateNote(siteId.toString(), notes);
          printLog('notes->$notes');
        }
      }

      if (res.containsKey('alreadyCheckIn')) {
        isAlreadyCheckIn.value = res['alreadyCheckIn'];
        printLog('isAlreadyCheckIn ->$isAlreadyCheckIn');
      }

      if (res.containsKey('status') && res['status'] != null) {
        checkStatus.value = res['status'];
        printLog('checkStatus ->$checkStatus');

        if (res['status'] == 'CHECKED_IN') {
          isCheckedIn.value = true;
          if (totalSeconds.value != 0) {
            timerService.start(
              initial: totalSeconds.value,
              onTick: (newSeconds) {
                elapsedSeconds.value = newSeconds;
              },
            );
          }
        }
        if (res['status'] == 'CHECKED_OUT') {
          isCheckedIn.value = false;
          timerService.stop();
        }
      }
    }
  }

  String get timeInHMS => Utility().getTimeInHMS(elapsedSeconds.value);

  Future<void> getMyLocation() async {
    final result = await LocationService.instance.getUserLocation();
    printLog('location $result');
    if (result != null) {
      userLatitude.value = result.latitude ?? 0.0;
      userLongitude.value = result.longitude ?? 0.0;
    }
  }

  Future<void> checkIn() async {
    isCheckInLoading.value = true;
    await getMyLocation();

    if (userLatitude.value == 0.0 || userLongitude.value == 0.0) {
      isCheckInLoading.value = false;
      return;
    }

    await noteController.loadNotes();
    int id = int.parse(siteId.toString());
    final note = noteController.getNote(siteId.toString()) ?? '';
    printLog('check In id->$id, note$note');

    final data = {
      "siteId": id,
      "notes": note.replaceAll('\\n', '<br>'),
      "locationDTO": {
        "latitude": userLatitude.toDouble(),
        "longitude": userLongitude.toDouble(),
      }
    };
    printLog('check In data->$data');
    try {
      final result = await ApiService().post(
        'check-in-record/check-in',
        body: data,
      );
      printLog('result $result');
      if (result['status'] == true) {
        await checkInRecordUser();
        checkInTime.value = Utility().getTime(result['data']['checkInTime']);
        printLog('checkInTime $checkInTime');

        isCheckedIn.value = true;
        elapsedSeconds.value = 0;

        timerService.start(
          initial: 0,
          onTick: (newSeconds) {
            elapsedSeconds.value = newSeconds;
          },
        );
        printLog(
            'isCheckedIn: $isCheckedIn elapsedSeconds: ${elapsedSeconds.value}');
      }
      isCheckInLoading.value = false;
    } catch (e) {
      isCheckInLoading.value = false;
      printLog('Error while post check in: $e');
    }
  }

  Future<void> checkOut() async {
    isCheckOutLoading.value = true;

    await noteController.loadNotes();
    int id = int.parse(siteId.toString());
    final note = noteController.getNote(siteId.toString()) ?? '';
    printLog('check Out id->$id, note$note');

    final data = {
      "siteId": id,
      "notes": note.replaceAll('\\n', '<br>'),
    };
    printLog('check Out data->$data');

    try {
      final result = await ApiService().patch(
        'check-in-record',
        body: data,
      );
      printLog('result $result');

      if (result['status'] == true) {
        await checkInRecordUser();
        checkInTime.value = Utility().getTime(result['data']['checkInTime']);
        checkOutTime.value = Utility().getTime(result['data']['checkOutTime']);
        printLog('checkInTime $checkInTime, checkOutTime $checkOutTime');

        isCheckedIn.value = false;
        timerService.stop();
      }
      isCheckOutLoading.value = false;
    } catch (e) {
      isCheckOutLoading.value = false;
      printLog('Error while post patch in: $e');
    }
  }

  Widget buildCheckButton() {
    if (isAlreadyCheckIn.value == false) {
      return checkInButton();
    } else {
      if (checkStatus.value == 'CHECKED_OUT') {
        return checkInButton();
      } else {
        return checkOutButton();
      }
    }
  }

  Widget checkInButton() {
    return ElevatedButton(
      onPressed: () {
        checkIn();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isCheckInLoading.value == true
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: AppColors.white,
                ),
                SizedBox(width: 10),
                TextWidget(
                  text: 'Check In',
                  textColor: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
    );
  }

  Widget checkOutButton() {
    return ElevatedButton(
      onPressed: () {
        checkOut();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.red[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isCheckOutLoading.value == true
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: AppColors.white,
                ),
                SizedBox(width: 10),
                TextWidget(
                  text: 'Check Out',
                  textColor: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
    );
  }

  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    siteId.value = args['siteId'] ?? '';
    Get.put(NoteController());
    photoController = Get.put(PhotoController());
    initSiteDetails();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    timerService.dispose();
    Utility().reloadActiveSite();
    super.onClose();
  }
}
