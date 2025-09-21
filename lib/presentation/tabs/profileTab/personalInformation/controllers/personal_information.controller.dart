import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../../infrastructure/dal/daos/setStorage/storage.dart';
import '../../../../../infrastructure/dal/services/api/api_response.dart';
import '../../../../../infrastructure/dal/services/api/api_service.dart';

class PersonalInformationController extends GetxController {
  final loading = false.obs;
  final userId = GetStorage().read('userId');
  final userStatus = 'Inactive'.obs;
  final isUserUpdating = false.obs;
  final isEditAllowed = false.obs;
  final role = GetStorage().read('userRole');
  final email = GetStorage().read('userEmail');

  final firstName =
      TextEditingController(text: GetStorage().read('userFirstName'));
  final lastName =
      TextEditingController(text: GetStorage().read('userLastName'));
  final contact = TextEditingController(text: GetStorage().read('userContact'));

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode contactFocusNode = FocusNode();

  toggleEditButton() {
    isEditAllowed.value = !isEditAllowed.value;
    // Always unfocus to prevent auto keyboard pop
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> getUserInfo() async {
    try {
      final response = await ApiResponse().getUserInfoById(userId);
      printLog('userInfo->$response');
      if (response.isNotEmpty) {
        if (response.containsKey('isEnabled') &&
            response['isEnabled'] != null) {
          if (response['isEnabled'] == true) {
            userStatus.value = 'Active';
          } else {
            userStatus.value = 'Inactive';
          }
        }
      }
    } catch (e) {
      printLog('[Error while fetching user info by id]: $e');
    }
  }

  Future<void> initPersonalInfo() async {
    loading.value = true;
    printLog('userId->$userId');
    await getUserInfo();
    printLog('role->$role');
    printLog('userStatus->$userStatus');
    printLog('email->$email');
    printLog('firstName->${firstName.text}');
    printLog('lastName->${lastName.text}');
    printLog('contact->${contact.text}');
    loading.value = false;
  }

  Future<void> userInfoUpdate() async {
    isUserUpdating.value = true;
    printLog(
        'userInfoUpdate firstName->${firstName.text}, lastName->${lastName.text}, contact->${contact.text}');
    try {
      final response = await ApiService().put(
        'users/$userId',
        body: {
          'firstName': firstName.text,
          'lastName': lastName.text,
          'contactNumber': contact.text,
        },
      );

      printLog('userInfoUpdate response->$response');
      if (response['status'] == true) {
        final userInfo = response['data'];
        Storage().setUserInfo(userInfo: userInfo);
      }
      isUserUpdating.value = false;
      isEditAllowed.value = false;
    } catch (e) {
      isUserUpdating.value = false;
      printLog('Error while updating user info: $e');
    }
  }

  @override
  void onInit() {
    initPersonalInfo();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    contactFocusNode.dispose();
    super.onClose();
  }
}
