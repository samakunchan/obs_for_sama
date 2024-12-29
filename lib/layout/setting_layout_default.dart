import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/widgets/form_q_r_code.dart';
import 'package:obs_for_sama/widgets/form_regular.dart';
import 'package:obs_for_sama/widgets/r_s_i_button.dart';

class SettingLayoutDefault extends StatefulWidget {
  const SettingLayoutDefault({super.key});

  @override
  State<SettingLayoutDefault> createState() => _SettingLayoutDefaultState();
}

class _SettingLayoutDefaultState extends State<SettingLayoutDefault> with TickerProviderStateMixin {
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
              FormRegular(
                key: ValueKey<String>('FORM BODY'),
              ),
              FormQRCode(
                key: ValueKey<String>('QRCODE BODY'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
