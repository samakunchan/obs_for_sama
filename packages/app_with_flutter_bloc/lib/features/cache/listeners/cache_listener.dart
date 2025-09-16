import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../error/bloc/error_bloc.dart';
import '../../server/bloc/server_bloc.dart';
import '../bloc/cache_bloc.dart';

class CacheListener extends StatelessWidget {
  const CacheListener({required this.child, this.contextPage, super.key});
  final Widget child;
  final BuildContext? contextPage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CacheBloc, CacheState>(
      listener: (BuildContext context, CacheState state) {
        switch (state) {
          case CacheHasError():
            if (kDebugMode) {
              print('Serveur à une érreur : ${state.errorInstance}');
            }
            context.read<ErrorBloc>().add(ErrorEmitted(errorInstance: state.errorInstance));
          case CacheIsCleared():
            context.read<ServerBloc>().add(ServerConnected());
            context.read<ErrorBloc>().add(ErrorReseted());
          case CacheIsUpdated():
            if (kDebugMode) {
              print('LE CACHE A ETE MIS A JOUR');
            }
            context.read<ServerBloc>().add(ServerConnected());
            context.read<ErrorBloc>().add(ErrorReseted());
            if (contextPage != null) {
              Navigator.of(contextPage!).popAndPushNamed('/');
            }
        }
      },
      child: child,
    );
  }
}
