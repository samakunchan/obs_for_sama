import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/index.dart';
import '../../features/cache/bloc/cache_bloc.dart';
import '../../features/cache/dto/cache_d_t_o.dart';
import '../../features/cache/listeners/cache_listener.dart';

class FormQRCode extends StatefulWidget {
  const FormQRCode({super.key});

  @override
  State<FormQRCode> createState() => _FormQRCodeState();
}

class _FormQRCodeState extends State<FormQRCode> with WidgetsBindingObserver {
  final MobileScannerController mobileScannerController = MobileScannerController(
    autoStart: false,
  );
  bool isLookingForQRCode = true;
  bool isCorrectQRCode = true;
  bool isAutoConnectToOBS = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(mobileScannerController.start());
      }
    });
  }

  @override
  void dispose() {
    mobileScannerController.dispose();
    unawaited(mobileScannerController.stop());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CacheListener(
      contextPage: context,
      child: RSIOutlinedBody(
        edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
        color: !isCorrectQRCode ? Colors.red : kButtonColor,
        child: isLookingForQRCode
            ? Stack(
                children: [
                  /// QR CODE SCANNER
                  if (!Platform.isWindows)
                    Center(
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        child: MobileScanner(
                          controller: mobileScannerController,
                          onDetect: _handleBarcode,
                        ),
                      ),
                    ),
                  if (Platform.isWindows)
                    Center(
                      child: Text(
                        'QR code is unsupported version for windows desktop.',
                        style: ktitle2,
                      ),
                    ),

                  /// ERROR MESSAGE
                  if (!isCorrectQRCode)
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
                  Text('Got it', style: ktitle1),
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: isAutoConnectToOBS
                        ? Column(
                            children: [
                              const CircularProgressIndicator(color: kTextColorWhite),
                              Text('Connecting to OBS...', style: ktitle2),
                            ],
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
      ),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      final String result = barcodes.barcodes.firstOrNull!.displayValue!;
      if (result.contains('obsws')) {
        final RegExp regExpIp = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
        final RegExp regExpPort = RegExp(r':(\d+)');
        final RegExp regExpPW = RegExp(r'/([^/]+)$');

        final String ip = regExpIp.stringMatch(result) ?? '';
        final String port = regExpPort.firstMatch(result)?.group(1) ?? '';
        final String token = regExpPW.firstMatch(result)?.group(1) ?? '';
        final CacheDTO cacheDTO = CacheDTO(
          localIp: ip,
          localPassword: token,
          localPort: port,
        );
        if (kDebugMode) {
          print('A RECU BarcodeCapture');
        }
        context.read<CacheBloc>().add(CacheWritten(cacheDTO: cacheDTO));
      } else {
        ///
      }
    }
  }
}
