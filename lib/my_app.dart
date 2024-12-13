import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/constantes.dart';
import 'package:obs_for_sama/o_b_s_control_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: const ValueKey<String>('Material GetX'),
      home: const OBSControlPage(
        key: ValueKey<String>('Main page'),
      ),
      theme: kThemeData,
    );
  }
}
