import 'package:get/get.dart';

import '../../../../presentation/tabs/homeTab/homeSchedule/controllers/home_schedule.controller.dart';

class HomeScheduleControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeScheduleController>(
      () => HomeScheduleController(),
    );
  }
}
