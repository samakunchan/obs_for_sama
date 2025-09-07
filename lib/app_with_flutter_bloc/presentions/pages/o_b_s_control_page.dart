import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/presentions/layouts/o_b_s_layout_mobile.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/presentions/life_cycle_wrapper.dart';
import 'package:obs_for_sama/app_with_get_x/layout/o_b_s_layout_default.dart';
import 'package:obs_for_sama/core/index.dart';

class OBSControlPage extends StatelessWidget {
  const OBSControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LifeCycleWrapper(
      context: context,
      child: Material(
        child: Scaffold(
          appBar: AppBar(centerTitle: true, title: Text(AppText.mainTitle.label)),
          drawer: Drawer(
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset('assets/icon-ios-obs-manager-x1.png'),
                  ),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('MENU_WORK_FLOW', style: ktitle2),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('MENU_SETTINGS', style: ktitle2),
                        onTap: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: Text('MENU_TWITCH', style: ktitle2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return OrientationBuilder(
                  key: const ValueKey<String>('Orientation For Mobile'),
                  builder: (BuildContext context, Orientation orientation) {
                    switch (orientation) {
                      case Orientation.portrait:
                      case Orientation.landscape:
                        return const OBSLayoutMobile();
                    }
                  },
                );
              } else {
                if (Platform.isWindows) {
                  return WindowBorder(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                    child: OrientationBuilder(
                      key: const ValueKey<String>('Orientation Default'),
                      builder: (BuildContext context, Orientation orientation) {
                        switch (orientation) {
                          case Orientation.portrait:
                          case Orientation.landscape:
                            return const OBSLayoutDefault(
                              key: ValueKey<String>('Page Default View'),
                            );
                        }
                      },
                    ),
                  );
                } else {
                  return OrientationBuilder(
                    key: const ValueKey<String>('Orientation Default'),
                    builder: (BuildContext context, Orientation orientation) {
                      switch (orientation) {
                        case Orientation.portrait:
                        case Orientation.landscape:
                          return const OBSLayoutDefault(
                            key: ValueKey<String>('Page Default View'),
                          );
                      }
                    },
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
