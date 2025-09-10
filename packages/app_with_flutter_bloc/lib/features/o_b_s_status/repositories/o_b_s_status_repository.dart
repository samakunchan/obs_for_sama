import 'package:obs_websocket/obs_websocket.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/index.dart';
import '../../server/singleton/o_b_s_singleton.dart';

class OBSStatusRepository {
  static Future<StatusStream> showStreamStatus() async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      final StreamStatusResponse? response = await obsWebSocket?.stream.status;
      if (response == null) return StatusStream.stopped;
      return response.outputActive ? StatusStream.started : StatusStream.stopped;
    } on Exception {
      throw OBSStatusException('STATUS_SHOW_STREAM_ERROR');
    }
  }

  static Future<bool> startStreaming() async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      await obsWebSocket?.stream.start();
      await WakelockPlus.enable();
      return true;
    } on Exception catch (_) {
      throw OBSStatusException('STATUS_START_STREAM_ERROR');
    }
  }

  static Future<bool> stopStreaming() async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      await obsWebSocket?.stream.stop();
      await WakelockPlus.disable();
      return true;
    } on Exception catch (_) {
      throw OBSStatusException('STATUS_STOP_STREAM_ERROR');
    }
  }
}
