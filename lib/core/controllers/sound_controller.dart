import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_websocket/request.dart';

/// # [SoundController]
/// Controller to manage the sound from OBS.
/// ## Main goal
/// - Get the status of the sound of mic.
/// - Turn on/off the sound of mic.
class SoundController extends GetxController {
  final RxBool isSoundMuted = false.obs;
  bool isMuted({required bool isMuted}) => isSoundMuted.value = isMuted;

  Future<void> getStatusSound() async {
    final controller = Get.put(ServerController());
    const String inputName = 'Mic/Aux';
    final Inputs? inputs = controller.obsWebSocket?.inputs;
    final bool? isReallyMuted = await inputs?.getMute(inputName);
    isMuted(isMuted: isReallyMuted ?? false);
  }

  Future<void> toogleMuteSound() async {
    final controller = Get.put(ServerController());
    const String inputName = 'Mic/Aux';
    final Inputs? inputs = controller.obsWebSocket?.inputs;
    await inputs?.toggleMute(inputName);
    final bool? isReallyMuted = await inputs?.getMute(inputName);
    isMuted(isMuted: isReallyMuted ?? false);
  }
}
