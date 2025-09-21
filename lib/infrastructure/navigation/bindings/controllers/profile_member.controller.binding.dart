import 'package:get/get.dart';

import '../../../../presentation/tabs/profileTab/profileMember/controllers/profile_member.controller.dart';

class ProfileMemberControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileMemberController>(
      () => ProfileMemberController(),
    );
  }
}
