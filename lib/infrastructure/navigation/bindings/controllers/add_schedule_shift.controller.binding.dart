import 'package:get/get.dart';

import '../../../../presentation/tabs/scheduleTab/addScheduleShift/controllers/add_schedule_shift.controller.dart';

class AddScheduleShiftControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddScheduleShiftController>(
      () => AddScheduleShiftController(),
    );
  }
}
