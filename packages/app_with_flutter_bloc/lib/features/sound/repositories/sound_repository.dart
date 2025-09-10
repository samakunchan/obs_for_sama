import 'package:flutter/foundation.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:obs_websocket/request.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../server/singleton/o_b_s_singleton.dart';

class SoundRepository {
  static Future<String> detectSoundConfiguration() async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      final RequestResponse? response = await obsWebSocket?.send('GetInputList');
      final List<Map<String, dynamic>> json = (response?.responseData!['inputs'] as List)
          .map((v) => v as Map<String, dynamic>)
          .toList();

      final List<Input> listInputs = json.map(Input.fromJson).toList();
      final String correctSoundName = listInputs
          .where((Input v) => v.inputKind == 'coreaudio_input_capture' || v.inputKind == 'wasapi_input_capture')
          .first
          .inputName;

      return correctSoundName;
    } on Exception {
      throw OBSSoundException('SOUND_DETECTION_ERROR');
    }
  }

  static Future<bool?> getStatusSound({required String inputName}) async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      if (obsWebSocket != null) {
        final Inputs inputs = obsWebSocket.inputs;
        final bool isReallyMuted = await inputs.getMute(inputName);
        return isReallyMuted;
      }
      return false;
    } on Exception {
      throw OBSSoundException('SOUND_STATUS_ERROR');
    }
  }

  static Future<bool> toogleMuteSound({required String? inputName}) async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      if (obsWebSocket != null) {
        final Inputs inputs = obsWebSocket.inputs;
        await inputs.toggleMute(inputName: inputName);
        final bool isReallyMuted = await inputs.getMute(inputName ?? '');
        if (kDebugMode) {
          print('SoundRepository - toogleMuteSound $isReallyMuted');
        }
        return isReallyMuted;
      }
      return false;
    } on Exception {
      throw OBSSoundException('SOUND_TOOGLE_ERROR');
    }
  }
}
