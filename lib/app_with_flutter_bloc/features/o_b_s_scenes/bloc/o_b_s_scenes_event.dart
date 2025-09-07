part of 'o_b_s_scenes_bloc.dart';

abstract class OBSScenesEvent extends Equatable {
  const OBSScenesEvent();
}

final class OBSScenesFetched extends OBSScenesEvent {
  @override
  List<Object> get props => [];
}
