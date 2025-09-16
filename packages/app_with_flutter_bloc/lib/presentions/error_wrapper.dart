import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/index.dart';
import '../features/error/bloc/error_bloc.dart';
import 'widgets/go_to_setting_page_button.dart';

class ErrorWrapper extends StatelessWidget {
  const ErrorWrapper({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ErrorBloc, ErrorState>(
      builder: (_, ErrorState state) {
        if (state is ErrorMessageDisplayed) {
          String errorMessage = '';
          if (kDebugMode) {
            print('MESSAGE ${state.errorInstance}');
          }
          if (state.errorInstance is SocketFailure ||
              state.errorInstance is OBSServerFailure ||
              state.errorInstance is CacheFailure) {
            if (state.errorInstance.message.contains(AppMessagesEnum.wifiError.key)) {
              errorMessage = state.errorInstance.message;
            }
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'OBS \nDisconnected...',
                      style: kheadlineLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: kbodyLarge.copyWith(color: kTextShadow),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 30),
                  child: GoToSettingPageButton(),
                ),
              ],
            );
          }
        }
        if (kDebugMode) {
          print('NO ERROR MESSAGE $state');
        }

        return child;
      },
    );
  }
}
