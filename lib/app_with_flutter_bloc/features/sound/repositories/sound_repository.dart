import 'package:flutter/foundation.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:obs_websocket/request.dart';

class SoundRepository {
  static Future<String> detectSoundConfiguration({required ObsWebSocket obsWebSocket}) async {
    final RequestResponse? res = await obsWebSocket.send('GetInputList');
    final List<Map<String, dynamic>> json = (res?.responseData!['inputs'] as List)
        .map((v) => v as Map<String, dynamic>)
        .toList();

    final List<Input> listInputs = json.map(Input.fromJson).toList();
    final String correctSoundName = listInputs
        .where((Input v) => v.inputKind == 'coreaudio_input_capture' || v.inputKind == 'wasapi_input_capture')
        .first
        .inputName;

    return correctSoundName;
  }

  static Future<bool?> getStatusSound({required String? inputName, required ObsWebSocket obsWebSocket}) async {
    final Inputs? inputs = obsWebSocket.inputs;
    final bool? isReallyMuted = await inputs?.getMute(inputName ?? '');
    return isReallyMuted;
  }

  static Future<bool> toogleMuteSound({required String? inputName, required ObsWebSocket obsWebSocket}) async {
    final Inputs? inputs = obsWebSocket.inputs;
    await inputs?.toggleMute(inputName: inputName);
    final bool? isReallyMuted = await inputs?.getMute(inputName ?? '');
    if (kDebugMode) {
      print('SoundRepository - toogleMuteSound $isReallyMuted');
    }
    return isReallyMuted ?? false;
  }
}
