part of 'cache_bloc.dart';

abstract class CacheState extends Equatable {
  const CacheState();
}

final class CacheInitial extends CacheState {
  @override
  List<Object> get props => [];
}

final class CacheIsLoading extends CacheState {
  @override
  List<Object> get props => [];
}

final class CacheHasError extends CacheState {
  const CacheHasError({required this.message});
  final String message;

  @override
  String toString() {
    return 'CacheHasError - $message';
  }

  @override
  List<Object> get props => [message];
}

final class CacheFoundDatas extends CacheState {
  const CacheFoundDatas({required this.obsModel});
  final OBSModel obsModel;
  @override
  List<Object> get props => [obsModel];
}

final class CacheIsCleared extends CacheState {
  @override
  List<Object> get props => [];
}

final class CacheIsUpdated extends CacheState {
  @override
  List<Object> get props => [];
}
