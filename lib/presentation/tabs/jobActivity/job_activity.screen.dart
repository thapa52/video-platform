import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../domain/core/interfaces/utility.dart';
import '../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../infrastructure/theme/app_colors.dart';
import 'controllers/job_activity.controller.dart';

class JobActivityScreen extends GetView<JobActivityController> {
  const JobActivityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.white,
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 100,
          title: TextWidget(
            text: 'Job Activities',
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
            preferredSize: Size.fromHeight(50),
            child: Column(
              children: [
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white, // Background color of tab
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: AppColors.gray, // Active tab color
                      borderRadius:
                          BorderRadius.circular(25), // Rounded active tab
                    ),
                    labelColor: AppColors.black,
                    unselectedLabelColor: AppColors.black,
                    textScaler: TextScaler.linear(1.0),
                    overlayColor: WidgetStateProperty.all(AppColors.white),
                    tabs: [
                      Tab(
                        child: TextWidget(
                          text: 'Clocked In',
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.text[800],
                        ),
                      ),
                      Tab(
                        child: TextWidget(
                          text: 'Clocked Out',
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.text[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Obx(
          () => controller.loading.value == true
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: controller.checkedInList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.checkedInList.length,
                              itemBuilder: (context, index) {
                                var clockedIn = controller.checkedInList[index];
                                return ListTile(
                                  onTap: () {},
                                  leading: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: AppColors.brand[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: TextWidget(
                                            text: Utility().getInitials(
                                                fullName:
                                                    clockedIn['userName']),
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
                                                color: AppColors.brand[900],
                                                shape: BoxShape.circle),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  title: TextWidget(
                                    text: '${clockedIn['userName']}',
                                    textColor: AppColors.text[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  subtitle: TextWidget(
                                    text: '${clockedIn['siteName']}',
                                    textColor: AppColors.text,
                                  ),
                                  trailing: SizedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextWidget(
                                          text: Utility().getTime(
                                              clockedIn['checkInTime']),
                                          textColor: AppColors.text[900],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        TextWidget(
                                          text: 'Today',
                                          textColor: AppColors.text,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Center(
                                child: TextWidget(
                                  text:
                                      'There are no clocked in users available.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: controller.checkedOutList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.checkedOutList.length,
                              itemBuilder: (context, index) {
                                var clockedOut =
                                    controller.checkedOutList[index];
                                return ListTile(
                                  onTap: () {},
                                  leading: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: AppColors.brand[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: TextWidget(
                                        text: Utility().getInitials(
                                            fullName: clockedOut['userName']),
                                        textColor: const Color(0xFF344054),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  title: TextWidget(
                                    text: '${clockedOut['userName']}',
                                    textColor: AppColors.text[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  trailing: TextWidget(
                                    text: Utility()
                                        .getTime(clockedOut['checkOutTime']),
                                    textColor: AppColors.text[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Center(
                                child: TextWidget(
                                  text:
                                      'There are no clocked out users available.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
