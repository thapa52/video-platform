import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../domain/core/interfaces/utility.dart';
import '../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import 'controllers/add_schedule_shift.controller.dart';

class AddScheduleShiftScreen extends GetView<AddScheduleShiftController> {
  const AddScheduleShiftScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.text,
            ),
          ),
          toolbarHeight: 100,
          title: TextWidget(
            text: 'Add a Shift',
            textColor: const Color(0xFF182230),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: AppColors.white,
            systemNavigationBarDividerColor: AppColors.white,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Divider(),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ElevatedButton(
            onPressed: () async {
              await controller.onSave();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Obx(
              () => controller.loading.value == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    )
                  : TextWidget(
                      text: 'Save',
                      textColor: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextWidget(
                      text: 'Shift Schedule',
                      textColor: Color(0xFF101828),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextWidget(
                      text: 'Name',
                      textColor: AppColors.text[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  controller.buildUserSearchWidget(),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                    child: TextWidget(
                      text: 'Site Name',
                      textColor: AppColors.text[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  controller.buildSiteSearchWidget(),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                    child: TextWidget(
                      text: 'Date',
                      textColor: AppColors.text[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.showCalendarDialog(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      margin: EdgeInsets.only(bottom: 20, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.gray[400]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => TextWidget(
                              text: controller.selectedDate.value == null
                                  ? 'Select Date'
                                  : Utility().getFullDate(
                                      controller.selectedDate.toString(),
                                      useSlashes: false),
                              textColor: AppColors.text,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.text,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(
                  //         Icons.add,
                  //         color: AppColors.brand[700],
                  //       ),
                  //       SizedBox(width: 10),
                  //       TextWidget(
                  //         text: 'Add a note',
                  //         textColor: AppColors.brand[700],
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(
                  //         Icons.photo,
                  //         color: AppColors.brand[700],
                  //       ),
                  //       SizedBox(width: 10),
                  //       TextWidget(
                  //         text: 'Attach a photo',
                  //         textColor: AppColors.brand[700],
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
