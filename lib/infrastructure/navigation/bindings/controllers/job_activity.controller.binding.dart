import 'package:get/get.dart';

import '../../../../presentation/tabs/jobActivity/controllers/job_activity.controller.dart';

class JobActivityControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobActivityController>(
      () => JobActivityController(),
    );
  }
}
