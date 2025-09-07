import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/title/bloc/title_bloc.dart';
import 'package:obs_for_sama/app_with_get_x/core/core_theme_index.dart';

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
