import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/mvvm/ui_layer/views/forms/form_q_r_code_view.dart';
import 'package:obs_for_sama/mvvm/ui_layer/views/forms/form_regular_view.dart';
import 'package:obs_for_sama/widgets/r_s_i_button.dart';

class SettingLayoutDefaultView extends StatefulWidget {
  const SettingLayoutDefaultView({super.key});

  @override
  State<SettingLayoutDefaultView> createState() => _SettingLayoutDefaultState();
}

class _SettingLayoutDefaultState extends State<SettingLayoutDefaultView> with TickerProviderStateMixin {
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
    return Column(
      children: [
        Row(
          children: [
            RSIButton(
              key: const ValueKey<String>('Back button'),
              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
              width: 80,
              onTap: () {
                Get.back<void>();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ],
        ),
        TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(
              key: ValueKey<String>('FORM TAB BUTTON'),
              child: Text('FORM'),
            ),
            Tab(
              key: ValueKey<String>('QRCODE TAB BUTTON'),
              child: Text('QRCODE'),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              FormRegularView(
                key: ValueKey<String>('FORM BODY'),
              ),
              FormQRCodeView(
                key: ValueKey<String>('QRCODE BODY'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
