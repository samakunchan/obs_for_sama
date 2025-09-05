import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/features/server/bloc/server_bloc.dart';

class LifeCycleWrapper extends StatefulWidget {
  const LifeCycleWrapper({required this.child, required this.context, super.key});
  final Widget child;
  final BuildContext context;

  @override
  State<LifeCycleWrapper> createState() => _LifeCycleWrapperState();
}

class _LifeCycleWrapperState extends State<LifeCycleWrapper> with WidgetsBindingObserver {
  StreamSubscription<List<ConnectivityResult>>? subscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (!widget.context.mounted) return;
      widget.context.read<ServerBloc>().add(ServerConnected());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print('Retour de la mise en veille');
        widget.context.read<ServerBloc>().add(ServerConnected());
      }
    } else {
      // Logout
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
