import 'package:get/get.dart';

import '../../../../presentation/tabs/profileTab/personalInformation/controllers/personal_information.controller.dart';

class PersonalInformationControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalInformationController>(
      () => PersonalInformationController(),
    );
  }
}
