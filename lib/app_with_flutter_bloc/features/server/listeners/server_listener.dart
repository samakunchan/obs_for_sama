import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/error/bloc/error_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/bloc/server_bloc.dart';

class ServerListener extends StatelessWidget {
  const ServerListener({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerBloc, ServerState>(
      listener: (BuildContext context, ServerState state) {
        print(state);
        switch (state) {
          case ServerHasError():
            if (kDebugMode) {
              print('Serveur à une érreur : ${state.message}');
            }
            context.read<ErrorBloc>().add(ErrorEmitted(message: state.message));
        }
      },
      child: child,
    );
  }
}
