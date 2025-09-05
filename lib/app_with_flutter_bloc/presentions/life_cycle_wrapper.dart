import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/error/bloc/error_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/messages/enums/messages_enum.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/bloc/server_bloc.dart';

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
    // On lance l'écoute de la connectivité dès l'initialisation du widget
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    if (kDebugMode) {
      print('ON ÉCOUTE LES CHANGEMENTS DE CONNECTIVITÉ');
    }
    await subscription?.cancel();

    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (!widget.context.mounted) return;
      if (kDebugMode) {
        print('RÉSULTAT DE LA CONNECTIVITÉ : $result');
      }

      // La logique de connexion au serveur se fait ici et uniquement ici.
      if (result.contains(ConnectivityResult.wifi)) {
        if (kDebugMode) {
          print('CONNEXION WI-FI DÉTECTÉE');
        }
        widget.context.read<ServerBloc>().add(ServerConnected());
        return;
      }

      if (kDebugMode) {
        print('AUCUNE CONNEXION WI-FI');
      }
      widget.context.read<ErrorBloc>().add(ErrorEmitted(message: AppMessagesEnum.wifiError.key));
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
        print('Retour de la mise en veille, on vérifie la connectivité.');
      }
      checkConnectivity();
    } else {
      // Logique pour la déconnexion ou autres états si nécessaire
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
