import 'package:flutter/material.dart';
import 'package:obs_for_sama/pages/o_b_s_control_page.dart';
import 'package:obs_for_sama/pages/o_b_s_settings_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final List<String> parametrizedName = settings.name?.split('?') ?? <String>[];
    final String name = (parametrizedName.isNotEmpty) ? parametrizedName[0] : (settings.name ?? '');

    switch (name) {
      case 'home':
        return PageRouteBuilder<OBSControlPage>(
          settings: settings,
          pageBuilder: (_, __, ___) => const OBSControlPage(
            key: ValueKey<String>('Main page'),
          ),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        );
      case 'settings':
        return PageRouteBuilder<OBSSettingsPage>(
          settings: settings,
          pageBuilder: (_, __, ___) => const OBSSettingsPage(
            key: ValueKey<String>('Settings page'),
          ),
          transitionsBuilder: (_, a, __, c) {
            const begin = Offset(0, 1);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = a.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: c,
            );
          },
        );
      default:
        return PageRouteBuilder<OBSSettingsPage>(
          settings: settings,
          pageBuilder: (_, __, ___) => const Scaffold(
            body: Center(
              child: Text('Page Not Found'),
            ),
          ),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        );
    }
  }
}
