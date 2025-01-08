import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/layout/o_b_s_layout_mobile.dart';
import 'package:obs_for_sama/mvvm/ui_layer/views/o_b_s_layout_default_view.dart';

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
            return OrientationBuilder(
              key: const ValueKey<String>('Orientation Default'),
              builder: (BuildContext context, Orientation orientation) {
                switch (orientation) {
                  case Orientation.portrait:
                  case Orientation.landscape:
                    return const OBSLayoutDefaultView(
                      key: ValueKey<String>('Page Default View'),
                    );
                }
              },
            );
          }
        },
      ),
    );
  }
}
