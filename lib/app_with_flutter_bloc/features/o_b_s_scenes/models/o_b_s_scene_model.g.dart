// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_b_s_scene_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OBSSceneModel _$OBSSceneModelFromJson(Map<String, dynamic> json) =>
    OBSSceneModel(
      scenes:
          (json['scenes'] as List<dynamic>)
              .map((e) => Scene.fromJson(e as Map<String, dynamic>))
              .toList(),
      currentScene: json['currentScene'] as String,
    );

Map<String, dynamic> _$OBSSceneModelToJson(OBSSceneModel instance) =>
    <String, dynamic>{
      'scenes': instance.scenes,
      'currentScene': instance.currentScene,
    };
