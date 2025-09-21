import 'package:get/get.dart';

import '../../../../presentation/tabs/my_list/controllers/my_list.controller.dart';

class MyListControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyListController>(
      () => MyListController(),
    );
  }
}
