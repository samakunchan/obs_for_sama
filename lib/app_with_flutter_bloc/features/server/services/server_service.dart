import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/messages/enums/messages_enum.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/exceptions/server_exception.dart';

class ServerService {
  static Future<Either<String, T>> baseRequest<T>({
    required Future<T> Function() getConcrete,
  }) async {
    try {
      final T remote = await getConcrete();

      return Right(remote);
    } on ServerException catch (e) {
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
