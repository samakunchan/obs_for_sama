import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/obs/server_controller.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:obs_websocket/request.dart';

/// # [SoundController]
/// Controller to manage the sound from OBS.
/// ## Main goal
/// - Get the status of the sound of mic.
/// - Turn on/off the sound of mic.
class SoundController extends GetxController {
  final RxBool isSoundMuted = false.obs;
  final RxString inputName = 'My microphone'.obs;
  bool isMuted({required bool isMuted}) => isSoundMuted.value = isMuted;
  String setInputName({required String name}) => inputName.value = name;

  Future<void> detectSoundConfiguration() async {
    final ServerController controller = Get.find();
    final RequestResponse? res = await controller.obsWebSocket?.send('GetInputList');
    final List<Map<String, dynamic>> json = (res?.responseData!['inputs'] as List).map((v) => v as Map<String, dynamic>).toList();

    final List<Input> listInputs = json.map(Input.fromJson).toList();
    final String correctSoundName =
        listInputs.where((Input v) => v.inputKind == 'coreaudio_input_capture' || v.inputKind == 'wasapi_input_capture').first.inputName;

    setInputName(name: correctSoundName);
  }

  Future<void> getStatusSound() async {
    final ServerController controller = Get.find();
    final Inputs? inputs = controller.obsWebSocket?.inputs;
    final bool? isReallyMuted = await inputs?.getMute(inputName.value);
    isMuted(isMuted: isReallyMuted ?? false);
  }

  Future<void> toogleMuteSound() async {
    final ServerController controller = Get.find();
    final Inputs? inputs = controller.obsWebSocket?.inputs;
    await inputs?.toggleMute(inputName.value);
    final bool? isReallyMuted = await inputs?.getMute(inputName.value);
    isMuted(isMuted: isReallyMuted ?? false);
  }
}
