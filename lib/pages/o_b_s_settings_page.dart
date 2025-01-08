import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/layout/setting_layout_mobile.dart';
import 'package:obs_for_sama/mvvm/ui_layer/views/o_b_s_layout_settings_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
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
                    return const SettingLayoutDefaultView(
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
