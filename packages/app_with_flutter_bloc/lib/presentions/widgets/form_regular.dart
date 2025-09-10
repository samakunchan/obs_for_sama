import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/index.dart';
import '../../features/cache/bloc/cache_bloc.dart';
import '../../features/cache/dto/cache_d_t_o.dart';
import '../../features/cache/listeners/cache_listener.dart';
import '../../features/cache/models/o_b_s_model.dart';
import '../../features/cache/repositories/cache_repository.dart';

class FormRegular extends StatefulWidget {
  const FormRegular({super.key});

  @override
  State<FormRegular> createState() => _FormRegularState();
}

class _FormRegularState extends State<FormRegular> {
  bool isSubmitting = false;
  final GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerIp = TextEditingController();
  final TextEditingController textEditingControllerPort = TextEditingController();
  final TextEditingController textEditingControllerPassword = TextEditingController();

  @override
  void initState() {
    getDatasFromCache();
    super.initState();
  }

  Future<void> getDatasFromCache() async {
    final OBSModel obsModel = await CacheRepository.instance.obsModel;
    textEditingControllerIp.text = obsModel.localIp ?? '';
    textEditingControllerPort.text = obsModel.localPort ?? '';
    textEditingControllerPassword.text = obsModel.localPassword ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return CacheListener(
      contextPage: context,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: RSIOutlinedBody(
          edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// FORM
              Form(
                key: settingsFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// IP TEXTFIELD
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextFormField(
                          cursorColor: kTextColorWhite,
                          obscureText: !Platform.isWindows,
                          controller: textEditingControllerIp,
                          decoration: InputDecoration(
                            labelText: SettingsEnum.ip.label,
                            prefixIcon: const Icon(Icons.leak_add),
                          ),
                          validator: (String? value) {
                            if (!value.isValidIP) {
                              return 'Please add obs websocket I.P.';
                            }
                            return null;
                          },
                        ),
                      ),

                      /// PORT TEXTFIELD
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextFormField(
                          cursorColor: kTextColorWhite,
                          obscureText: !Platform.isWindows,
                          controller: textEditingControllerPort,
                          decoration: InputDecoration(
                            labelText: SettingsEnum.port.label,
                            prefixIcon: const Icon(Icons.developer_board),
                          ),
                          validator: (String? value) {
                            if (!value.isValidPort) {
                              return 'Please add obs websocket port.';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),

                      /// PASSWORD TEXTFIELD
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextFormField(
                          cursorColor: kTextColorWhite,
                          obscureText: !Platform.isWindows,
                          controller: textEditingControllerPassword,
                          decoration: InputDecoration(
                            labelText: SettingsEnum.password.label,
                            prefixIcon: const Icon(Icons.key),
                          ),
                          validator: (String? value) {
                            if (!value.isValidPassword) {
                              return 'Please add obs websocket password.';
                            }
                            return null;
                          },
                        ),
                      ),

                      /// ACTIONS BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextButton(
                              onPressed: clearTextFields,
                              child: FaIcon(
                                FontAwesomeIcons.eraser,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: isSubmitting
                                ? CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary)
                                : TextButton(
                                    onPressed: () {
                                      if (settingsFormKey.currentState!.validate()) {
                                        setState(() {
                                          isSubmitting = true;
                                        });
                                        final CacheDTO cacheDTO = CacheDTO(
                                          localIp: textEditingControllerIp.text,
                                          localPassword: textEditingControllerPassword.text,
                                          localPort: textEditingControllerPort.text,
                                        );
                                        context.read<CacheBloc>().add(CacheWritten(cacheDTO: cacheDTO));
                                      }
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.floppyDisk,
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// CACHE CLEAR
              Padding(
                padding: const EdgeInsets.all(16),
                child: RSIButtonOutlined(
                  onTap: clearTextFields,
                  edgeClipper: const RSIEdgeClipper(
                    edgeRightTop: true,
                    edgeLeftBottom: true,
                  ),
                  color: kBodyTextColor,
                  child: Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FontAwesomeIcons.trash, size: 20, color: kBodyTextColor),
                      Text('CLEAR_CACHE', style: ktitle2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> clearTextFields() async {
    textEditingControllerPassword.clear();
    textEditingControllerIp.clear();
    textEditingControllerPort.clear();
    context.read<CacheBloc>().add(CacheCleared());
  }
}
