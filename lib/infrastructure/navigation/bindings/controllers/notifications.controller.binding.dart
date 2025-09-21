import 'package:get/get.dart';

import '../../../../presentation/notifications/controllers/notifications.controller.dart';

class NotificationsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
    );
  }
}
