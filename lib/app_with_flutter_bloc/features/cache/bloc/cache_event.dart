part of 'cache_bloc.dart';

sealed class CacheEvent extends Equatable {
  const CacheEvent();
}

class CacheInspectionCredentials extends CacheEvent {
  const CacheInspectionCredentials();

  @override
  List<Object?> get props => [];
}

class CacheWritten extends CacheEvent {
  const CacheWritten({required this.cacheDTO});
  final CacheDTO cacheDTO;

  @override
  List<Object?> get props => [cacheDTO];
}

class CacheCleared extends CacheEvent {
  @override
  List<Object?> get props => [];
}
