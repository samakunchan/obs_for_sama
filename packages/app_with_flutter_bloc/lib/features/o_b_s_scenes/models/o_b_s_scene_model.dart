import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obs_websocket/obs_websocket.dart';

part 'o_b_s_scene_model.freezed.dart';
part 'o_b_s_scene_model.g.dart';

@freezed
@JsonSerializable()
class OBSSceneModel with _$OBSSceneModel {
  const OBSSceneModel({
    required this.scenes,
    required this.currentScene,
  });
  factory OBSSceneModel.fromJson(Map<String, Object?> json) => _$OBSSceneModelFromJson(json);

  @override
  final List<Scene> scenes;
  @override
  final String currentScene;

  Map<String, Object?> toJson() => _$OBSSceneModelToJson(this);
}
