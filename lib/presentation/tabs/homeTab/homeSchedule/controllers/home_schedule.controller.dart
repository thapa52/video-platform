import 'package:get/get.dart';

import '../../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../../infrastructure/dal/services/api/api_response.dart';

class HomeScheduleController extends GetxController {
  final loading = false.obs;
  final data = [].obs;

  Future<void> initHomeSchedule() async {
    loading.value = true;
    await shiftMine();
    loading.value = false;
  }

  Future<void> shiftMine() async {
    final res = await ApiResponse().getShiftMine();
    printLog('res mine $res');
    if (res.isNotEmpty) {
      data.value = [];
      data.addAll(res);
    }
  }

  @override
  void onInit() {
    initHomeSchedule();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
