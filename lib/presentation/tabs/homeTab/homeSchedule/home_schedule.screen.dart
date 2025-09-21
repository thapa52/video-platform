import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../domain/core/interfaces/utility.dart';
import '../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import 'controllers/home_schedule.controller.dart';

class HomeScheduleScreen extends GetView<HomeScheduleController> {
  const HomeScheduleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Obx(
        () => controller.loading.value == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: controller.data.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.data.length,
                        itemBuilder: (context, index) {
                          final dayGroup = controller.data[index];
                          final date =
                              '${Utility().getMonthName(dayGroup['date'])} ${Utility().getDay(dayGroup['date'])} ${Utility().getYear(dayGroup['date'])}';
                          final entries = dayGroup['data'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: date,
                                ),
                                const SizedBox(height: 8),
                                ...entries.map<Widget>((entry) {
                                  final site = entry['site'];
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: ListTile(
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
                                              fullName: site['siteName'],
                                              showFullInitials: false,
                                            ),
                                            textColor: Color(0xFF344054),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      title: TextWidget(
                                        text: '${site['siteName']}',
                                        textColor: AppColors.text[900],
                                        fontWeight: FontWeight.w500,
                                      ),
                                      subtitle: TextWidget(
                                        text: '${site['location']}',
                                        textColor: AppColors.text,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child:
                            TextWidget(text: 'There is not schedule available'),
                      ),
              ),
      ),
    );
  }
}
