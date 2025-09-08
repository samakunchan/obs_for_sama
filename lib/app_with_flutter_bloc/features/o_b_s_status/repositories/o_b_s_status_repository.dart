import 'package:obs_for_sama/app_with_flutter_bloc/features/server/singleton/o_b_s_singleton.dart';
import 'package:obs_for_sama/core/exceptions/exceptions.dart';
import 'package:obs_for_sama/core/utils/enums.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
