import '../../dal/daos/printlog.dart';
import 'package:get/get.dart';

class ControllerHandler<T> {
  final T Function() creator;
  final void Function(T controller)? onFound;

  ControllerHandler({
    required this.creator,
    this.onFound,
  });

  void handle() {
    if (Get.isRegistered<T>()) {
      final controller = Get.find<T>();
      printLog('${T.toString()} is found');
      onFound?.call(controller);
    } else {
      final controller = creator();
      Get.put<T>(controller);
      printLog('${T.toString()} is initialized');
    }
  }
}
