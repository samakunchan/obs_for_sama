import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:obs_for_sama/app_with_get_x/layout/o_b_s_layout_default.dart';
import 'package:obs_for_sama/app_with_get_x/layout/o_b_s_layout_mobile.dart';
import 'package:obs_for_sama/core/index.dart';

class OBSControlPage extends StatelessWidget {
  const OBSControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(AppText.mainTitle.label))),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            return OrientationBuilder(
              key: const ValueKey<String>('Orientation For Mobile'),
              builder: (BuildContext context, Orientation orientation) {
                switch (orientation) {
                  case Orientation.portrait:
                  case Orientation.landscape:
                    return const OBSLayoutMobile(
                      key: ValueKey<String>('Page Mobile View'),
                    );
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
    );
  }
}
