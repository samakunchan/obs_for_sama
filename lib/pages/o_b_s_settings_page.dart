import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/constantes.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/core/failures/failures.dart';
import 'package:obs_for_sama/widgets/r_s_i_body.dart';
import 'package:obs_for_sama/widgets/r_s_i_button.dart';

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
  @override
  void initState() {
    controller = Get.put(ServerController());
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // controller.dispose();
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
                              child: Text('FORM'),
                            ),
                            Tab(
                              child: Text('QRCODE'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              RSIOutlinedBody(
                                edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      /// FORM
                                      Form(
                                        key: controller.settingsFormKey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: TextFormField(
                                                  cursorColor: kTextColorWhite,
                                                  // obscureText: true,
                                                  controller: controller.textEditingControllerIp,
                                                  // placeholder: '192.XXX.XXX.XXX',
                                                  decoration: InputDecoration(
                                                    labelText: SettingsEnum.ip.label,
                                                    prefixIcon: const Icon(Icons.leak_add),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: TextFormField(
                                                  cursorColor: kTextColorWhite,
                                                  // obscureText: true,
                                                  controller: controller.textEditingControllerPort,
                                                  // placeholder: '1234',
                                                  decoration: InputDecoration(
                                                    labelText: SettingsEnum.port.label,
                                                    prefixIcon: const Icon(Icons.developer_board),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: TextFormField(
                                                  cursorColor: kTextColorWhite,
                                                  // obscureText: true,
                                                  controller: controller.textEditingControllerPassword,
                                                  // placeholder: 'OBS Websocket Password',
                                                  decoration: InputDecoration(
                                                    labelText: SettingsEnum.password.label,
                                                    prefixIcon: const Icon(Icons.key),
                                                  ),
                                                ),
                                              ),

                                              /// ACTIONS BUTTONS
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: TextButton(
                                                      onPressed: () => Navigator.of(context).pop(),
                                                      child: const Icon(Icons.cancel, color: Colors.white),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: isSubmitting
                                                        ? CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary)
                                                        : TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                isSubmitting = true;
                                                              });
                                                              controller.submit(
                                                                onSuccess: (bool value) {
                                                                  Get.back<void>();
                                                                  setState(() {
                                                                    isSubmitting = false;
                                                                  });
                                                                },
                                                                onFailure: (Failure failure) {
                                                                  controller.showErrorSnackBar(failureInfo: failure);
                                                                  setState(() {
                                                                    isSubmitting = false;
                                                                  });
                                                                },
                                                              );
                                                            },
                                                            child: Icon(Icons.check, color: Theme.of(context).colorScheme.tertiary),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              RSIOutlinedBody(
                                edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
                                color: isCorrectQRCode != null && isCorrectQRCode == false ? Colors.red : kButtonColor,
                                child: isLookingForQRCode
                                    ? Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          MobileScanner(
                                            onDetect: (BarcodeCapture barcodes) => _handleBarcode(barcodes, controller),
                                          ),
                                          if (isCorrectQRCode != null && isCorrectQRCode == false)
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Align(
                                                widthFactor: 300,
                                                alignment: Alignment.topRight,
                                                child: Chip(
                                                  side: const BorderSide(color: Colors.red),
                                                  color: WidgetStateProperty.resolveWith<Color?>(
                                                    (Set<WidgetState> states) {
                                                      if (states.contains(WidgetState.hovered) ||
                                                          states.contains(WidgetState.pressed) ||
                                                          states.contains(WidgetState.focused)) {
                                                        return kButtonColor;
                                                      }
                                                      return Colors.red;
                                                    },
                                                  ),
                                                  label: const Text('Wrong format QR Code'),
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Got it',
                                            style: ktitle1,
                                          ),
                                          AnimatedSwitcher(
                                            duration: const Duration(seconds: 1),
                                            child: isAutoConnectToOBS != null
                                                ? Column(
                                                    children: [
                                                      const CircularProgressIndicator(
                                                        color: kTextColorWhite,
                                                      ),
                                                      Text(
                                                        'Connectting to OBS...',
                                                        style: ktitle2,
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                    return SafeArea(
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Get.back<void>();
                          },
                          child: const Text('Retour'),
                        ),
                      ),
                    );
                }
              },
            );
          }
        },
      ),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes, ServerController controller) {
    if (mounted) {
      // print('CODE BARRE : ${barcodes.barcodes.firstOrNull!.displayValue}');
      final String result = barcodes.barcodes.firstOrNull!.displayValue!;
      if (result.contains('obsws')) {
        final RegExp regExpIp = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
        final RegExp regExpPort = RegExp(r':(\d+)');
        final RegExp regExpPW = RegExp(r'/([^/]+)$');

        final String ip = regExpIp.stringMatch(result) ?? '';
        final String port = regExpPort.firstMatch(result)?.group(1) ?? '';
        final String token = regExpPW.firstMatch(result)?.group(1) ?? '';

        setState(() {
          isLookingForQRCode = false;
          isCorrectQRCode = true;
          isAutoConnectToOBS = true;
        });
        controller.textEditingControllerIp.value = TextEditingValue(text: ip);
        controller.textEditingControllerPort.value = TextEditingValue(text: port);
        controller.textEditingControllerPassword.value = TextEditingValue(text: token);
        controller.submitQrCode(
          onSuccess: (_) {
            Get.back<void>();
            setState(() {
              isAutoConnectToOBS = false;
            });
          },
          onFailure: (Failure failure) {
            controller.showErrorSnackBar(failureInfo: failure);
            setState(() {
              isAutoConnectToOBS = false;
            });
          },
        );
      } else {
        setState(() {
          isLookingForQRCode = true;
          isCorrectQRCode = false;
        });
      }
    }
  }
}
