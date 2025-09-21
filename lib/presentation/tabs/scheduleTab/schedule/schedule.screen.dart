import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import 'controllers/schedule.controller.dart';

class ScheduleScreen extends GetView<ScheduleController> {
  const ScheduleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isEmployee = controller.userRole.value == 'employee';
        return isEmployee
            ? Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColors.white,
                  centerTitle: true,
                  elevation: 0,
                  toolbarHeight: 100,
                  title: TextWidget(
                    text: 'Schedule',
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
                body: controller.loading.value == true
                    ? Center(child: CircularProgressIndicator())
                    : controller.buildMineScheduleWidget(),
              )
            : DefaultTabController(
                length: 2,
                child: Builder(
                  builder: (context) {
                    TabController tabController =
                        DefaultTabController.of(context);

                    tabController.addListener(() {
                      controller.selectedTabIndex.value = tabController.index;
                    });
                    return Scaffold(
                      backgroundColor: AppColors.white,
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: AppColors.white,
                        centerTitle: true,
                        elevation: 0,
                        toolbarHeight: 100,
                        title: TextWidget(
                          text: 'Schedule',
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .white, // Background color of tab
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TabBar(
                                  indicator: BoxDecoration(
                                    color: AppColors.gray, // Active tab color
                                    borderRadius: BorderRadius.circular(
                                        25), // Rounded active tab
                                  ),
                                  labelColor: AppColors.text,
                                  unselectedLabelColor: AppColors.text,
                                  textScaler: TextScaler.linear(1.0),
                                  overlayColor:
                                      WidgetStateProperty.all(AppColors.white),
                                  tabs: [
                                    Tab(
                                      child: TextWidget(
                                        text: 'Mine',
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.text[800],
                                      ),
                                    ),
                                    Tab(
                                      child: TextWidget(
                                        text: 'Team',
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
                      floatingActionButton: Obx(
                        () {
                          return controller.selectedTabIndex.value == 1
                              ? controller.teamShift.isNotEmpty
                                  ? FloatingActionButton(
                                      onPressed: () {
                                        Get.toNamed('add-schedule-shift');
                                      },
                                      backgroundColor: AppColors.brand[700],
                                      child: Icon(Icons.add),
                                    )
                                  : SizedBox.shrink()
                              : SizedBox.shrink();
                        },
                      ),
                      body: Obx(
                        () => controller.loading.value == true
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : TabBarView(
                                children: [
                                  controller.buildMineScheduleWidget(),
                                  controller.buildTeamScheduleWidget(),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
