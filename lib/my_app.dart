import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/server_binding.dart';
import 'package:obs_for_sama/core/themes/theme_data.dart';
import 'package:obs_for_sama/pages/o_b_s_control_page.dart';
import 'package:obs_for_sama/pages/o_b_s_settings_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: const ValueKey<String>('Material GetX'),
      theme: kThemeData,
      initialRoute: '/home',
      locale: const Locale('en', 'US'),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
      getPages: [
        GetPage(
          name: '/home',
          page: () => const OBSControlPage(
            key: ValueKey<String>('Main page'),
          ),
          binding: ServerBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/settings',
          page: () => const SettingsPage(
            key: ValueKey<String>('Settings page'),
          ),
          binding: ServerBinding(),
        ), // here!
      ],
    );
  }
}
