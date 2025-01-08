import 'dart:convert';

import 'package:obs_for_sama/mvvm/data_layer/models/auth_form_model.dart';
import 'package:obs_websocket/obs_websocket.dart';

class OBSService {
  const OBSService();

  Future<ObsWebSocket> connect({required AuthFormModel form}) async {
    return ObsWebSocket.connect(
      'ws://${form.ip}:${form.port}',
      password: form.password,
    );
  }

  Future<void> listen({required AuthFormModel form}) async {
    final ObsWebSocket obsWebSocket = await connect(form: form);
    obsWebSocket.broadcastStream.listen((message) {
      final opcode = Opcode.fromJson(json.decode(message.toString()) as Map<String, dynamic>);

      if (opcode.op == WebSocketOpCode.event.code) {
        final event = Event.fromJson(opcode.d);
        print(event.toJson());

        // _handleEvent(event);
      }
    });
  }

  Future<ProfileListResponse?> getProfile({required AuthFormModel form}) async {
    final ObsWebSocket obsWebSocket = await connect(form: form);
    final ProfileListResponse defaultProfile = await obsWebSocket.config.getProfileList();

    return defaultProfile;
  }
}
