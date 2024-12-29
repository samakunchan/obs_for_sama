import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/auth_obs_form_controller.dart';
import 'package:obs_for_sama/core/controllers/error_controller.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/layout/setting_layout_default.dart';
import 'package:obs_for_sama/layout/setting_layout_mobile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late bool isSubmitting = false;
  late bool isLookingForQRCode = true;
  bool? isCorrectQRCode;
  bool? isAutoConnectToOBS;
  late ServerController controller;
  late ErrorController errorController;
  late AuthObsFormController formController;

  @override
  void initState() {
    controller = Get.find();
    errorController = Get.find();
    formController = Get.find();
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
