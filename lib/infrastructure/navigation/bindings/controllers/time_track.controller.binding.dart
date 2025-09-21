import 'package:get/get.dart';

import '../../../../presentation/tabs/timeTrack/controllers/time_track.controller.dart';

class TimeTrackControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeTrackController>(
      () => TimeTrackController(),
    );
  }
}
