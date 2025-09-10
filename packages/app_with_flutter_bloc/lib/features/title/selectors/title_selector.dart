import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/index.dart';
import '../bloc/title_bloc.dart';

class TitleSelector extends StatelessWidget {
  const TitleSelector({required this.value, super.key});
  final Widget Function(String) value;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TitleBloc, TitleState, String>(
      selector: _whenTitleHasConfigurationActive,
      builder: (_, String scenes) => value(scenes),
    );
  }

  static String _whenTitleHasConfigurationActive(TitleState state) {
    switch (state) {
      case TitleWithValue():
        return state.title;
      default:
        return AppText.scenes.label;
    }
  }
}
