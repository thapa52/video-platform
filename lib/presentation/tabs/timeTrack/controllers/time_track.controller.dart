import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/core/interfaces/utility.dart';
import '../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../infrastructure/dal/daos/widgets/note_widget.dart';
import '../../../../infrastructure/dal/daos/widgets/photo_widget.dart';
import '../../../../infrastructure/dal/daos/widgets/snackbar_widget.dart';
import '../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../infrastructure/dal/daos/widgets/type_ahead_widget.dart';
import '../../../../infrastructure/dal/services/api/api_response.dart';
import '../../../../infrastructure/dal/services/api/api_service.dart';
import '../../../../infrastructure/dal/services/controllers/photo_controller.dart';
import '../../../../infrastructure/dal/services/location/location_services.dart';
import '../../../../infrastructure/dal/services/map/map_service.dart';
import '../../../../infrastructure/dal/services/controllers/note_controller.dart';
import '../../../../infrastructure/dal/services/timer/timer_services.dart';
import '../../../../infrastructure/theme/app_colors.dart';

class TimeTrackController extends GetxController {
  final selectedTabIndex = 0.obs;

  Future<void> refreshTimeTrack() async {
    printLog("Refreshing tracking...");
    await tracking();
    await timesheet();
  }

  // TimeSheet section

  final selectedDates = <DateTime?>[].obs;
  final isTimesheetLoading = false.obs;
  final checkOutList = [].obs;
  final checkInList = [].obs;
  final onSiteList = [].obs;

  Future<void> timesheet() async {
    isTimesheetLoading.value = true;
    selectedDates.value = [DateTime.now()];
    isTimesheetLoading.value = false;
  }

  // Example logic: Return text based on selected date
  String getMessageForDate(DateTime? date) {
    printLog('date $date');
    if (date == null) return '';

    if (DateUtils.isSameDay(date, DateTime.now())) {
      return 'Today';
    } else {
      return Utility().getFullDate(date.toString());
    }
  }

  Future<void> onSiteTimeSheet() async {
    final res = await ApiResponse()
        .getCheckInTimeShift(status: 'on_site', dateTime: selectedDates[0]);
    printLog('res onSite $res');
    onSiteList.value = [];
    onSiteList.addAll(res);
  }

  Future<void> checkInTimeSheet() async {
    final res = await ApiResponse()
        .getCheckInTimeShift(status: 'checked_in', dateTime: selectedDates[0]);
    printLog('res checkedIn $res');
    checkInList.value = [];
    checkInList.addAll(res);
  }

  Future<void> checkOutTimeSheet() async {
    final res = await ApiResponse()
        .getCheckInTimeShift(status: 'checked_out', dateTime: selectedDates[0]);
    printLog('res checkedOut $res');
    checkOutList.value = [];
    checkOutList.addAll(res);
  }

  buildCheckOutWidget(data) {
    return ListTile(
      onTap: () {},
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F9EC),
          shape: BoxShape.circle,
        ),
        child: Align(
          alignment: Alignment.center,
          child: TextWidget(
            text: Utility().getInitials(fullName: data['userName'] ?? ''),
            textColor: const Color(0xFF344054),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      title: TextWidget(
        text: '${data['userName'] ?? ''}',
        textColor: const Color(0xFF313131),
        fontWeight: FontWeight.w500,
      ),
      subtitle: Row(
        children: [
          Flexible(
            child: TextWidget(
              text: Utility().getTime(data['checkInTime'] ?? ''),
              textColor: const Color(0xFF6C6C6C),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFF638C2D),
            ),
          ),
          Flexible(
            child: TextWidget(
              text: Utility().getTime(data['checkOutTime'] ?? ''),
              textColor: const Color(0xFF6C6C6C),
            ),
          ),
        ],
      ),
      trailing: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFDE8E9),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextWidget(
                text: changeText(data['status'] ?? ''),
                textColor: Color(0xFFA81419),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextWidget(
              text: Utility().getTimeInHMS(data['totalSeconds'] ?? 0),
              textColor: Color(0xFF6C6C6C),
            ),
          ],
        ),
      ),
    );
  }

  buildCheckInWidget(data) {
    return ListTile(
      onTap: () {},
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F9EC),
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: TextWidget(
                text: Utility().getInitials(fullName: data['userName'] ?? ''),
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
                    color: Color(0xFF3F591C), shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ),
      title: TextWidget(
        text: '${data['userName'] ?? ''}',
        textColor: const Color(0xFF313131),
        fontWeight: FontWeight.w500,
      ),
      subtitle: Row(
        children: [
          Flexible(
            child: TextWidget(
              text: Utility().getTime(data['checkInTime'] ?? ''),
              textColor: const Color(0xFF6C6C6C),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.access_time,
              color: Color(0xFF638C2D),
            ),
          ),
          Flexible(
            child: TextWidget(
              text: Utility().getTime(data['checkOutTime'] ?? ''),
              textColor: const Color(0xFF6C6C6C),
            ),
          ),
        ],
      ),
      trailing: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFE6F7FD),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextWidget(
                text: changeText(data['status'] ?? ''),
                textColor: Color(0xFF007CAA),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextWidget(
              text: Utility().getTimeInHMS(data['totalSeconds'] ?? 0),
              textColor: Color(0xFF6C6C6C),
            ),
          ],
        ),
      ),
    );
  }

  buildOnSiteWidget(data) {
    return ListTile(
      onTap: () {},
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F9EC),
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: TextWidget(
                text: Utility().getInitials(fullName: data['userName'] ?? ''),
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
                    color: Color(0xFF3F591C), shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ),
      title: TextWidget(
        text: '${data['userName'] ?? ''}',
        textColor: const Color(0xFF313131),
        fontWeight: FontWeight.w500,
      ),
      subtitle: Row(
        children: [
          Flexible(
            child: TextWidget(
              text: Utility().getTime(data['checkInTime'] ?? ''),
              textColor: const Color(0xFF6C6C6C),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.access_time,
              color: Color(0xFF638C2D),
            ),
          ),
          Flexible(
            child: TextWidget(
              text: Utility().getTime(data['checkOutTime'] ?? ''),
              textColor: const Color(0xFF6C6C6C),
            ),
          ),
        ],
      ),
      trailing: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFE6F7FD),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextWidget(
                text: changeText(data['status'] ?? ''),
                textColor: Color(0xFF007CAA),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextWidget(
              text: Utility().getTimeInHMS(data['totalSeconds'] ?? 0),
              textColor: Color(0xFF6C6C6C),
            ),
          ],
        ),
      ),
    );
  }

  String changeText(status) {
    if (status == 'CHECKED_OUT') {
      return 'Check Out';
    } else if (status == 'CHECKED_IN') {
      return 'Check In';
    } else if (status == 'ON_SITE') {
      return 'On Site';
    } else {
      return '-';
    }
  }

  // Traking section
  TimerService timerService = TimerService();
  final isCheckedIn = false.obs;
  final elapsedSeconds = 0.obs;

  late PhotoController photoController;
  final NoteController noteController = NoteController();
  final isTrackingLoading = false.obs;
  final isSiteSelected = false.obs;
  final siteList = [].obs;
  final selectedSite = {}.obs;
  final typeAheadController = TextEditingController();

  final isCheckInLoading = false.obs;
  final isCheckOutLoading = false.obs;
  final isAlreadyCheckIn = false.obs;
  final checkStatus = ''.obs;
  final checkInTime = ''.obs;
  final checkOutTime = ''.obs;
  final trackTotalSeconds = 0.obs;
  final userLatitude = 0.0.obs;
  final userLongitude = 0.0.obs;

  Future<void> tracking() async {
    isTrackingLoading.value = true;
    Get.put(NoteController());
    photoController = Get.put(PhotoController());
    await getSiteList();
    noteController.loadNotes();
    isTrackingLoading.value = false;
  }

  Future<void> getSiteList() async {
    try {
      siteList.value = [];
      final result = await ApiResponse().getSitesList();
      if (result.isNotEmpty) {
        siteList.addAll(result['content']);
        printLog('siteList $siteList');
      }
    } catch (e) {
      printLog('Error while fetching siteList: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSiteSuggestions(String query) async {
    return siteList
        .where((site) {
          final mapSite = site as Map<String, dynamic>;
          final siteName = mapSite['siteName']?.toString().toLowerCase() ?? '';
          return siteName.contains(query.toLowerCase());
        })
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Widget buildTrackingWidget() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isAlreadyCheckIn.value == false ||
                      (isAlreadyCheckIn.value == true &&
                          checkStatus.value == 'CHECKED_OUT')
                  ? isSiteSelected.value == true
                      ? GestureDetector(
                          onTap: () {
                            isSiteSelected.value = false;
                            typeAheadController.clear();
                          },
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            title: TextWidget(
                              text: '${selectedSite['siteName']}',
                              textColor: AppColors.text[900],
                              fontWeight: FontWeight.w500,
                            ),
                            subtitle: TextWidget(
                              text: '${selectedSite['location']}',
                              textColor: AppColors.text,
                              fontSize: 14,
                            ),
                            trailing: Icon(
                              Icons.search,
                              color: AppColors.text,
                            ),
                            shape: Border(
                              bottom: BorderSide(
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                        )
                      : TypeAheadWidget(
                          hintText: 'Select Site',
                          hintColor: AppColors.text[900],
                          fontWeight: FontWeight.w500,
                          controller: typeAheadController,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.gray,
                              width: 1,
                            ),
                          ),
                          itemWidget: (suggestion) {
                            return ListTile(
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.brand[50],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: TextWidget(
                                    text: Utility().getInitials(
                                      fullName: suggestion['siteName'],
                                      showFullInitials: false,
                                    ),
                                    textColor: Color(0xFF344054),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              title: TextWidget(
                                text: '${suggestion['siteName']}',
                                textColor: AppColors.text[900],
                                fontWeight: FontWeight.w500,
                              ),
                              subtitle: TextWidget(
                                text: '${suggestion['location']}',
                                textColor: AppColors.text,
                                fontSize: 14,
                              ),
                            );
                          },
                          onSelected: (value) {
                            typeAheadController.text = value['siteName'] ?? '';
                            selectedSite.value = value;
                            isSiteSelected.value = true;
                          },
                          suggestion: (search) {
                            return getSiteSuggestions(search);
                          },
                        )
                  : Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gray),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.skyblue[700],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  TextWidget(
                                    text: checkInTime.value != ''
                                        ? checkInTime.value
                                        : '-',
                                    textColor: AppColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  SizedBox(height: 4),
                                  TextWidget(
                                    text: 'Check In',
                                    textColor: AppColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: selectedSite['siteName'],
                                      textColor: AppColors.text[900],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(height: 4),
                                    TextWidget(
                                      text: selectedSite['location'],
                                      textColor: AppColors.text[900],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 6, right: 6),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.gray[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextWidget(
                                text: timeInHMS,
                                textColor: AppColors.text[900],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              isSiteSelected.value == true
                  ? Container(
                      margin: EdgeInsets.all(20),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MapWidget(
                        latitude: selectedSite['latitude'],
                        longitude: selectedSite['longitude'],
                      ),
                    )
                  : Container(),
              isSiteSelected.value == true && isCheckedIn.value == true
                  ? NoteWidget(
                      siteId: selectedSite['id'].toString(),
                    )
                  : Container(),
              isSiteSelected.value == true && isCheckedIn.value == true
                  ? PhotoWidget()
                  : Container(),
            ],
          ),
        ),
      ),
    );
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
        isSiteSelected.value == true
            ? checkIn()
            : SnackbarWidget(
                title: 'Site not selected !!!',
                message: 'Please select site before you check in');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSiteSelected.value == true
            ? AppColors.brand[700]
            : AppColors.brand[700]!.withOpacity(0.5),
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
      onPressed: () async {
        await checkOut();
        typeAheadController.text = '';
        selectedSite.value = {};
        isSiteSelected.value = false;
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

  Future<void> checkInRecordUser() async {
    final res = await ApiResponse().getCheckInRecordUser(selectedSite['id']);
    printLog('checkInRecordUser res->$res');
    if (res.isNotEmpty) {
      await photoController.initData(res, selectedSite['id'].toString());
      if (res.containsKey('checkInRecordResponseDTO') &&
          res['checkInRecordResponseDTO'] != null) {
        final record = {}.obs;
        record.addAll(res['checkInRecordResponseDTO']);

        checkInTime.value = Utility().getTime(record['checkInTime']);
        checkOutTime.value = Utility().getTime(record['checkOutTime']);

        trackTotalSeconds.value = record['totalSeconds'];
        elapsedSeconds.value = trackTotalSeconds.value;

        // ✅ Call updateNote only if notes is not empty
        final notes = record['notes'];
        printLog('notes res->$notes');
        if (notes != null && notes.toString().trim().isNotEmpty) {
          noteController.updateNote(selectedSite['id'].toString(), notes);
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
          if (trackTotalSeconds.value != 0) {
            timerService.start(
              initial: trackTotalSeconds.value,
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

    String siteid = selectedSite['id'].toString();
    await noteController.loadNotes();
    int id = int.parse(siteid);
    final note = noteController.getNote(siteid) ?? '';

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

    String siteid = selectedSite['id'].toString();
    await noteController.loadNotes();
    int id = int.parse(siteid);
    final note = noteController.getNote(siteid) ?? '';
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

  @override
  void onInit() {
    refreshTimeTrack();
    selectedDates.listen((_) async {
      if (selectedDates.isNotEmpty && selectedDates[0] != null) {
        await checkOutTimeSheet();
        await checkInTimeSheet();
        await onSiteTimeSheet();
      }
    });
    ever(isSiteSelected, (bool selected) {
      if (selected) {
        checkInRecordUser(); // 👈 Call your function here
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    timerService.dispose();
    super.onClose();
  }
}
