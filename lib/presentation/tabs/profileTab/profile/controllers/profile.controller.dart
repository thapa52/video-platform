import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../domain/core/interfaces/utility.dart';
import '../../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../../infrastructure/dal/daos/widgets/text_widget.dart';

class ProfileController extends GetxController {
  final loading = false.obs;
  final userRole = ''.obs;

  confirmLogout() async {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          height: 240,
          child: Stack(
            children: [
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFF9F9FB),
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFF6F7F9),
                          width: 1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFF3F4F6),
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFF0F1F4),
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F9EC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE3F1D1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.logout,
                                          color: Color(0xFF638C2D),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextWidget(
                          text: 'Log Out',
                          textColor: Color(0xFF101828),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextWidget(
                          text: 'Are you sure you want to logout?',
                          textColor: Color(0xFF475467),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: Color(0xFFD0D5DD),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: TextWidget(
                                  text: 'Cancel',
                                  textColor: Color(0xFF344054),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Utility().logOut();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF638C2D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: TextWidget(
                                  text: 'Logout',
                                  textColor: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> refreshProfile() async {
    print("Refreshing profile ...");
    userRole.value = GetStorage().read('userRole').toString().toLowerCase();
    printLog('userRole $userRole');
  }

  @override
  void onInit() {
    refreshProfile();
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
