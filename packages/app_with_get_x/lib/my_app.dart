import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../core/server_binding.dart';
import '../core/themes/theme_data.dart';
import '../pages/o_b_s_control_page.dart';
import '../pages/o_b_s_settings_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, _, _) => GetMaterialApp(
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
            page: () => const OBSSettingsPage(
              key: ValueKey<String>('Settings page'),
            ),
            binding: ServerBinding(),
          ), // here!
        ],
      ),
    );
  }
}
