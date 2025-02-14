// import 'dart:async';

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:obs_for_sama/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // For more long splash screen.
  // final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Timer(const Duration(seconds: 5), FlutterNativeSplash.remove);
  runApp(const MyApp());

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;
      const Size minSize = Size(800, 600);
      const Size launcherSize = Size(1200, 800);

      win
        ..minSize = minSize
        ..size = launcherSize
        ..alignment = Alignment.center
        ..title = 'OBS Manager - v0.12.0'
        ..show();
    });
  }
}
