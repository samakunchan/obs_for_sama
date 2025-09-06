import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/bloc/cache_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/error/bloc/error_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/bloc/server_bloc.dart';

class CacheListener extends StatelessWidget {
  const CacheListener({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CacheBloc, CacheState>(
      listener: (BuildContext context, CacheState state) {
        switch (state) {
          case CacheHasError():
            if (kDebugMode) {
              print('Serveur à une érreur : ${state.message}');
            }
            context.read<ErrorBloc>().add(ErrorEmitted(message: state.message));
          case CacheIsCleared():
            context.read<ServerBloc>().add(ServerConnected());
            context.read<ErrorBloc>().add(const ErrorEmitted(message: ''));
          case CacheIsUpdated():
            if (kDebugMode) {
              print('LE CACHE A ETE MIS A JOUR');
            }
            context.read<ServerBloc>().add(ServerConnected());
            context.read<ErrorBloc>().add(const ErrorEmitted(message: ''));
            Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
