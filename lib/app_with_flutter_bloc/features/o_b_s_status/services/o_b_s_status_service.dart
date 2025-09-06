import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/messages/enums/messages_enum.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_status/exceptions/o_b_s_status_exception.dart';

class OBSStatusService {
  static Future<Either<String, T>> baseRequest<T>({
    required Future<T> Function() getConcrete,
  }) async {
    try {
      final T remote = await getConcrete();

      return Right(remote);
    } on OBSStatusStartException catch (e) {
      return Left(e.message);
    } on OBSStatusStopException catch (e) {
      return Left(e.message);
    } on SocketException catch (_) {
      return Left(AppMessagesEnum.serverError.key);
    } on TimeoutException catch (_) {
      return Left(AppMessagesEnum.timeOutError.key);
    } on Exception catch (e) {
      return Left('${AppMessagesEnum.unknownError.key}\n$e');
    }
  }
}
