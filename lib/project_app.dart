import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/core/routes.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/bloc/cache_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/error/bloc/error_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_scenes/bloc/current_scene_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_scenes/bloc/o_b_s_scenes_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_sources/bloc/current_source_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_sources/bloc/o_b_s_sources_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_status/bloc/o_b_s_status_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/bloc/server_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/sound/bloc/sound_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/title/bloc/title_bloc.dart';
import 'package:obs_for_sama/core/index.dart';
import 'package:sizer/sizer.dart';

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CacheBloc>(create: (_) => CacheBloc()),
        BlocProvider<ErrorBloc>(create: (_) => ErrorBloc()),
        BlocProvider<ServerBloc>(create: (_) => ServerBloc()..add(ServerConnected())),
        BlocProvider<SoundBloc>(create: (_) => SoundBloc()..add(SoundConfigured())),
        BlocProvider<OBSStatusBloc>(create: (_) => OBSStatusBloc()),
        BlocProvider<OBSScenesBloc>(create: (_) => OBSScenesBloc()),
        BlocProvider<CurrentSceneBloc>(create: (_) => CurrentSceneBloc()),
        BlocProvider<CurrentSourceBloc>(create: (_) => CurrentSourceBloc()),
        BlocProvider<OBSSourcesBloc>(create: (_) => OBSSourcesBloc()),
        BlocProvider<TitleBloc>(create: (_) => TitleBloc()),
      ],
      child: Sizer(
        builder: (_, _, _) {
          return MaterialApp(
            key: const ValueKey<String>('Material Flutter Bloc'),
            theme: kThemeData,
            locale: const Locale('en', 'US'),
            initialRoute: '/',
            onGenerateRoute: Routes.generateRoute,
          );
        },
      ),
    );
  }
}
