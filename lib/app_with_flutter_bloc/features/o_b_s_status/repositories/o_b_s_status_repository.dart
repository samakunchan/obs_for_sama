import 'package:obs_for_sama/app_with_flutter_bloc/features/messages/enums/messages_enum.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_status/exceptions/o_b_s_status_exception.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/singleton/o_b_s_singleton.dart';
import 'package:obs_for_sama/core/utils/enums.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class OBSStatusRepository {
  Future<StatusStream> showStreamStatus() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    final StreamStatusResponse? response = await obsWebSocket?.stream.status;
    if (response == null) return StatusStream.stopped;
    return response.outputActive ? StatusStream.started : StatusStream.stopped;
  }

  static Future<bool> startStreaming() async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      await obsWebSocket?.stream.start();
      await WakelockPlus.enable();
      return true;
    } on Exception catch (_) {
      throw OBSStatusStartException(AppMessagesEnum.startError.key);
    }
  }

  static Future<bool> stopStreaming() async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      await obsWebSocket?.stream.stop();
      await WakelockPlus.disable();
      return true;
    } on Exception catch (_) {
      throw OBSStatusStartException(AppMessagesEnum.stopError.key);
    }
  }
}
