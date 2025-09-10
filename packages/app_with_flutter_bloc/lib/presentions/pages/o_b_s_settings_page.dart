import 'package:flutter/material.dart';

import '../../core/index.dart';
import '../layouts/setting_layout_default.dart';
import '../layouts/setting_layout_mobile.dart';

class OBSSettingsPage extends StatefulWidget {
  const OBSSettingsPage({super.key});

  @override
  State<OBSSettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<OBSSettingsPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppText.mainSettingsTitle.label)),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            return OrientationBuilder(
              key: const ValueKey<String>('Orientation For Mobile'),
              builder: (BuildContext context, Orientation orientation) {
                switch (orientation) {
                  case Orientation.portrait:
                  case Orientation.landscape:
                    return const SettingLayoutMobile(
                      key: ValueKey('Page Settings mobile View'),
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
                    return const SettingLayoutDefault(
                      key: ValueKey('Page Settings default View'),
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
