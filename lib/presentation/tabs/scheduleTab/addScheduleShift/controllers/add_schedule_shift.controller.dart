import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/core/interfaces/utility.dart';
import '../../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../../infrastructure/dal/daos/widgets/snackbar_widget.dart';
import '../../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../../infrastructure/dal/daos/widgets/type_ahead_widget.dart';
import '../../../../../infrastructure/dal/services/api/api_response.dart';
import '../../../../../infrastructure/dal/services/api/api_service.dart';
import '../../../../../infrastructure/theme/app_colors.dart';

class AddScheduleShiftController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final resetUserField = false.obs;
  final resetSiteField = false.obs;

  final loading = false.obs;
  final userList = [].obs;
  final siteList = [].obs;
  final userId = 0.obs;
  final siteId = 0.obs;
  final userController = TextEditingController();
  final siteController = TextEditingController();
  final selectedDate = (null as DateTime?).obs;

  Future<void> initAddShift() async {
    getUserList();
    getSiteList();
  }

  Future<void> getUserList() async {
    try {
      userList.value = [];
      final result = await ApiResponse().getUserList();
      if (result.isNotEmpty) {
        userList.addAll(result['content']);
        printLog('userList $userList');
      }
    } catch (e) {
      printLog('Error while fetching user list: $e');
    }
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
      printLog('Error while fetching site list: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserSuggestions(String query) async {
    return userList
        .where((user) {
          final mapUser = user as Map<String, dynamic>;
          final firstName =
              mapUser['firstName']?.toString().toLowerCase() ?? '';
          final lastName = mapUser['lastName']?.toString().toLowerCase() ?? '';
          final queryLower = query.toLowerCase();
          return firstName.contains(queryLower) ||
              lastName.contains(queryLower);
        })
        .cast<Map<String, dynamic>>()
        .toList();
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

  Widget buildUserSearchWidget() {
    return Obx(
      () {
        if (resetUserField.value) {
          // 🔥 When resetUserField is true, return an empty Container
          return Container();
        }
        return FormField<String>(
          validator: (value) {
            if (userController.text.trim().isEmpty) {
              return 'Please select a member';
            }
            return null;
          },
          builder: (field) => Column(
            children: [
              TypeAheadWidget(
                hintText: 'Enter member name',
                fontWeight: FontWeight.w500,
                controller: userController,
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
                            firstName: suggestion['firstName'],
                            lastName: suggestion['lastName'],
                            showFullInitials: true,
                          ),
                          textColor: Color(0xFF344054),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    title: TextWidget(
                      text:
                          '${suggestion['firstName']} ${suggestion['lastName']}',
                      textColor: AppColors.text[900],
                      fontWeight: FontWeight.w500,
                    ),
                    subtitle: TextWidget(
                      text: '${suggestion['role']}',
                      textColor: AppColors.text,
                      fontSize: 14,
                    ),
                  );
                },
                onSelected: (value) {
                  userController.text =
                      '${value['firstName'] ?? ''} ${value['lastName'] ?? ''}';
                  userId.value = value['userId'] ?? '';
                  printLog(
                      'userController: ${userController.text}, userId: ${userId.value}');
                },
                suggestion: (search) {
                  return getUserSuggestions(search);
                },
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    field.errorText ?? '',
                    style: TextStyle(color: AppColors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSiteSearchWidget() {
    return Obx(
      () {
        if (resetSiteField.value) {
          return Container();
        }
        return FormField<String>(
          validator: (value) {
            if (siteController.text.trim().isEmpty) {
              return 'Please select a site';
            }
            return null;
          },
          builder: (field) => Column(
            children: [
              TypeAheadWidget(
                hintText: 'Enter Site Name',
                fontWeight: FontWeight.w500,
                controller: siteController,
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
                  siteController.text = value['siteName'] ?? '';
                  siteId.value = value['id'] ?? '';
                  printLog(
                      'siteController: ${siteController.text}, siteId: ${siteId.value}');
                },
                suggestion: (search) {
                  return getSiteSuggestions(search);
                },
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    field.errorText ?? '',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void setDate(DateTime? date) {
    selectedDate.value = date;
    printLog('selectedDate: $selectedDate');
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  void showCalendarDialog(BuildContext context) async {
    final List<DateTime?>? pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        firstDate: DateTime.now(),
      ),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      value: selectedDate.value != null ? [selectedDate.value] : [],
    );

    if (pickedDates != null && pickedDates.isNotEmpty) {
      setDate(pickedDates.first);
    }
  }

  Future<void> onSave() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (selectedDate.value == null) {
      SnackbarWidget(message: 'Please select a date');
      return;
    }

    loading.value = true;
    String date = Utility().getFullDate(
      selectedDate.toString(),
      useSlashes: false,
    );
    int siteid = int.parse(siteId.toString());
    int userid = int.parse(userId.toString());

    final data = {
      "date": date,
      "siteId": siteid,
      "userId": userid,
      "note": "",
    };
    printLog('data $data');

    try {
      final result = await ApiService().post('shift', body: data);
      print('result $result');
      if (result['status'] == true) {
        resetUserField.value = true;
        resetSiteField.value = true;

        await Future.delayed(Duration(milliseconds: 100)); // Wait briefly
        resetUserField.value = false;
        resetSiteField.value = false;

        userController.text = '';
        siteController.text = '';
        selectedDate.value = null;
        SnackbarWidget(message: '${result['message']}');
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      printLog('Error while adding shift: $e');
    }
    FocusScope.of(Get.context!).unfocus();
  }

  Future<void> refreshSchedule() async {
    await Utility().reloadSchedule();
  }

  @override
  void onInit() {
    initAddShift();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    await refreshSchedule();
    super.onClose();
  }
}
