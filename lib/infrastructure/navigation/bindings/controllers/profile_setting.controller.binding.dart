import 'package:get/get.dart';

import '../../../../presentation/tabs/profileTab/profileSetting/controllers/profile_setting.controller.dart';

class ProfileSettingControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSettingController>(
      () => ProfileSettingController(),
    );
  }
}
