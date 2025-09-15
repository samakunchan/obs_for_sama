import 'dart:io';
import 'dart:ui';

import 'package:app_with_flutter_bloc/app_with_flutter_bloc.dart';
import 'package:app_with_get_x/app_with_get_x.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obs_for_sama/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // For more long splash screen.
  // final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Timer(const Duration(seconds: 5), FlutterNativeSplash.remove);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const fatalError = true;
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };
  if (appFlavor == 'getx') {
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
          ..title = 'OBS Manager - v0.19.0'
          ..show();
      });
    }
    return;
  } else if (appFlavor == 'bloc') {
    runApp(const ProjectApp());
    if (Platform.isWindows) {
      doWhenWindowReady(() {
        final win = appWindow;
        const Size minSize = Size(800, 600);
        const Size launcherSize = Size(1200, 800);

        win
          ..minSize = minSize
          ..size = launcherSize
          ..alignment = Alignment.center
          ..title = 'OBS Manager - v0.19.0'
          ..show();
      });
    }
    return;
  } else {
    runApp(const ProjectApp());
    if (Platform.isWindows) {
      doWhenWindowReady(() {
        final win = appWindow;
        const Size minSize = Size(800, 600);
        const Size launcherSize = Size(1200, 800);

        win
          ..minSize = minSize
          ..size = launcherSize
          ..alignment = Alignment.center
          ..title = 'OBS Manager - v0.19.0'
          ..show();
      });
    }
    return;
  }
}
