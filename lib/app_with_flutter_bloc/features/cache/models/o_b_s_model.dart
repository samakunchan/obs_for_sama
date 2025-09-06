import 'package:freezed_annotation/freezed_annotation.dart';

part 'o_b_s_model.freezed.dart';
part 'o_b_s_model.g.dart';

@freezed
@JsonSerializable()
class OBSModel with _$OBSModel {
  const OBSModel({
    this.localIp,
    this.localPort,
    this.localPassword,
  });
  factory OBSModel.fromJson(Map<String, Object?> json) => _$OBSModelFromJson(json);

  @override
  final String? localIp;
  @override
  final String? localPort;
  @override
  final String? localPassword;

  Map<String, Object?> toJson() => _$OBSModelToJson(this);
}
