import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../infrastructure/theme/app_colors.dart';
import 'controllers/time_track.controller.dart';

class TimeTrackScreen extends GetView<TimeTrackController> {
  const TimeTrackScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          TabController tabController = DefaultTabController.of(context);

          tabController.addListener(() {
            controller.selectedTabIndex.value = tabController.index;
          });

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              toolbarHeight: 100,
              title: TextWidget(
                text: 'Time Track',
                textColor: const Color(0xFF182230),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.white,
                systemNavigationBarDividerColor: Colors.white,
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
                        color: Colors.white, // Background color of tab
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: const Color(0xFFECECEC), // Active tab color
                          borderRadius:
                              BorderRadius.circular(25), // Rounded active tab
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        textScaler: TextScaler.linear(1.0),
                        overlayColor: WidgetStateProperty.all(Colors.white),
                        tabs: [
                          Tab(
                            child: TextWidget(
                              text: 'Tracking',
                              fontWeight: FontWeight.w600,
                              textColor: Color(0xFF3E3E3E),
                            ),
                          ),
                          Tab(
                            child: TextWidget(
                              text: 'Timesheet',
                              fontWeight: FontWeight.w600,
                              textColor: Color(0xFF3E3E3E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Obx(
              () {
                return controller.selectedTabIndex.value == 0
                    ? BottomAppBar(
                        height: 60,
                        elevation: 0,
                        color: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: controller.buildCheckButton(),
                      )
                    : SizedBox.shrink();
              },
            ),
            body: TabBarView(
              children: [
                controller.buildTrackingWidget(),
                Obx(
                  () => controller.isTimesheetLoading.value == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CalendarDatePicker2(
                                  config: CalendarDatePicker2Config(
                                    calendarType:
                                        CalendarDatePicker2Type.single,
                                    lastDate: DateTime.now(),
                                  ),
                                  value: controller.selectedDates,
                                  onValueChanged: (value) {
                                    controller.selectedDates.value = value;
                                  },
                                ),
                                if (controller.selectedDates.isNotEmpty &&
                                    controller.selectedDates[0] != null)
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 20, left: 20, right: 20),
                                    child: TextWidget(
                                      text: controller.getMessageForDate(
                                          controller.selectedDates[0]),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                if (controller.selectedDates.isNotEmpty &&
                                    controller.selectedDates[0] != null &&
                                    controller.checkOutList.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.checkOutList.length,
                                    itemBuilder: (context, index) {
                                      var checkOut =
                                          controller.checkOutList[index];
                                      return controller
                                          .buildCheckOutWidget(checkOut);
                                    },
                                  ),
                                if (controller.selectedDates.isNotEmpty &&
                                    controller.selectedDates[0] != null &&
                                    controller.onSiteList.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.onSiteList.length,
                                    itemBuilder: (context, index) {
                                      var onSite = controller.onSiteList[index];
                                      return controller
                                          .buildOnSiteWidget(onSite);
                                    },
                                  ),
                                if (controller.selectedDates.isNotEmpty &&
                                    controller.selectedDates[0] != null &&
                                    controller.checkInList.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.checkInList.length,
                                    itemBuilder: (context, index) {
                                      var checkIn =
                                          controller.checkInList[index];
                                      return controller
                                          .buildCheckInWidget(checkIn);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
