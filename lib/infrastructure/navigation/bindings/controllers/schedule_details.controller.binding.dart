import 'package:get/get.dart';

import '../../../../presentation/tabs/scheduleTab/scheduleDetails/controllers/schedule_details.controller.dart';

class ScheduleDetailsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleDetailsController>(
      () => ScheduleDetailsController(),
    );
  }
}
