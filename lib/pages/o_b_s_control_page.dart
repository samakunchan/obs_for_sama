import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/layout/o_b_s_layout_default.dart';
import 'package:obs_for_sama/layout/o_b_s_layout_mobile.dart';
import 'package:obs_for_sama/presention_with_bloc/index.dart';
import 'package:obs_for_sama/presention_with_bloc/life_cycle_wrapper.dart';

class OBSControlPage extends StatelessWidget {
  const OBSControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LifeCycleWrapper(
      context: context,
      child: Scaffold(
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
                      return const OBSLayoutMobileBloc();
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
                          return Placeholder();
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
    );
  }
}
