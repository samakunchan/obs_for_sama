import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache_d_t_o.freezed.dart';
part 'cache_d_t_o.g.dart';

@freezed
@JsonSerializable()
class CacheDTO with _$CacheDTO {
  const CacheDTO({
    this.localIp,
    this.localPort,
    this.localPassword,
  });
  factory CacheDTO.fromJson(Map<String, Object?> json) => _$CacheDTOFromJson(json);

  @override
  final String? localIp;
  @override
  final String? localPort;
  @override
  final String? localPassword;

  Map<String, Object?> toJson() => _$CacheDTOToJson(this);
}
