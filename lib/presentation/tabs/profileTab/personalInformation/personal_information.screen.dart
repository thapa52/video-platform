import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import 'controllers/personal_information.controller.dart';

class PersonalInformationScreen extends GetView<PersonalInformationController> {
  const PersonalInformationScreen({super.key});
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
            text: 'Personal Information',
            textColor: Color(0xFF182230),
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
        body: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextWidget(
                    text: 'Role & Status',
                    textColor: AppColors.text[700],
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextWidget(
                    text: 'Role',
                    textColor: AppColors.text[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.gray[400],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.gray[400]!,
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                      color: AppColors.text,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15),
                      hintText: '${controller.role.toString().capitalize}',
                      hintStyle: TextStyle(
                        color: AppColors.text,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextWidget(
                    text: 'Status',
                    textColor: AppColors.text[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.gray[400],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.gray[400]!,
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                        color: AppColors.text,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 15),
                        hintText: controller.userStatus.value,
                        hintStyle: TextStyle(
                          color: AppColors.text,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Personal Information',
                        textColor: AppColors.text[700],
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      IconButton(
                        onPressed: () {
                          controller.toggleEditButton();
                        },
                        icon: Obx(
                          () => Icon(
                            controller.isEditAllowed.value == true
                                ? Icons.close_rounded
                                : Icons.edit_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextWidget(
                    text: 'Email',
                    textColor: AppColors.text[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.gray[400],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.gray[400]!,
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                      color: AppColors.text,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15),
                      hintText: '${controller.email}',
                      hintStyle: TextStyle(
                        color: AppColors.text,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextWidget(
                    text: 'First Name',
                    textColor: AppColors.text[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: controller.isEditAllowed.value == true
                          ? AppColors.gray[50]
                          : AppColors.gray[400],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.gray[400]!,
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      focusNode: controller.firstNameFocusNode,
                      readOnly: !controller.isEditAllowed.value,
                      keyboardType: TextInputType.name,
                      controller: controller.firstName,
                      onChanged: (value) => controller.firstName.value,
                      style: TextStyle(
                        color: AppColors.text,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextWidget(
                    text: 'LastName',
                    textColor: AppColors.text[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: controller.isEditAllowed.value == true
                          ? AppColors.gray[50]
                          : AppColors.gray[400],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.gray[400]!,
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      focusNode: controller.lastNameFocusNode,
                      readOnly: !controller.isEditAllowed.value,
                      keyboardType: TextInputType.name,
                      controller: controller.lastName,
                      onChanged: (value) => controller.lastName.value,
                      style: TextStyle(
                        color: AppColors.text,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextWidget(
                    text: 'Contact',
                    textColor: AppColors.text[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: controller.isEditAllowed.value == true
                          ? AppColors.gray[50]
                          : AppColors.gray[400],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.gray[400]!,
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      focusNode: controller.contactFocusNode,
                      readOnly: !controller.isEditAllowed.value,
                      keyboardType: TextInputType.number,
                      controller: controller.contact,
                      onChanged: (value) => controller.contact.value,
                      style: TextStyle(
                        color: AppColors.text,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.isEditAllowed.value == true
                      ? ElevatedButton(
                          onPressed: () {
                            controller.userInfoUpdate();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brand[700],
                            minimumSize: Size.fromHeight(50),
                          ),
                          child: controller.isUserUpdating.value == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : TextWidget(
                                  text: 'Save',
                                  textColor: AppColors.white,
                                ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
