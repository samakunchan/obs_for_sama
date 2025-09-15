import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/index.dart';
import '../features/error/bloc/error_bloc.dart';

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

    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      if (!widget.context.mounted) return;
      if (kDebugMode) {
        print('RÉSULTAT DE LA CONNECTIVITÉ : $result');
      }

      // La logique de connexion au serveur se fait ici et uniquement ici.
      if (result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.ethernet)) {
        if (kDebugMode) {
          print('CONNEXION WI-FI DÉTECTÉE');
        }
        widget.context.read<ErrorBloc>().add(ErrorReseted());
        return;
      } else {
        if (kDebugMode) {
          print('AUCUNE CONNEXION WI-FI');
        }
        widget.context.read<ErrorBloc>().add(ErrorEmitted(message: AppMessagesEnum.wifiError.key));
      }
      return;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription?.cancel();
    if (kDebugMode) {
      print('Je suis lancer dans le dispose');
    }

    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print('Retour de la mise en veille, on vérifie la connectivité.');
      }

      await checkConnectivity();
    }

    if (state == AppLifecycleState.inactive) {
      if (kDebugMode) {
        print('L‘instance est cleared.');
      }
    }

    if (kDebugMode) {
      print('LIFE STATE APP $state');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
