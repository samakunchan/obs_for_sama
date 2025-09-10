import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../../core/index.dart';
import '../layouts/o_b_s_layout_default.dart';
import '../layouts/o_b_s_layout_mobile.dart';
import '../life_cycle_wrapper.dart';
import '../widgets/o_b_s_drawer.dart';

class OBSControlPage extends StatelessWidget {
  const OBSControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LifeCycleWrapper(
      context: context,
      child: Material(
        child: Scaffold(
          appBar: AppBar(centerTitle: true, title: Text(AppText.mainTitle.label)),
          drawer: const OBSDrawer(),
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
