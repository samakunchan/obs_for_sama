import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/obs/server_controller.dart';

class LifeCycleController extends FullLifeCycleController with FullLifeCycleMixin {
  final ServerController controller = Get.find();

  @override
  void onDetached() {
    controller.logoutToOBS();
  }

  @override
  void onHidden() {
    controller.logoutToOBS();
  }

  @override
  void onInactive() {
    controller.logoutToOBS();
  }

  @override
  void onPaused() {
    controller.logoutToOBS();
  }

  @override
  void onResumed() {
    controller.connectToOBS();
  }
}
