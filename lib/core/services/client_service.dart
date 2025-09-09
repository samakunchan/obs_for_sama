import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:obs_for_sama/app_with_get_x/core/core_theme_index.dart';
import 'package:obs_for_sama/core/exceptions/exceptions.dart';
import 'package:obs_for_sama/core/failures/failures.dart';

class ClientService {
  static Future<Either<Failure, T>> baseRequest<T>({
    required Future<T> Function() getConcrete,
  }) async {
    try {
      final T remote = await getConcrete();

      return Right(remote);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on OBSServerException catch (e) {
      if (e.message.contains('Connection refused')) {
        return Left(SocketFailure(AppMessagesEnum.connectionRefused.key));
      }
      return Left(OBSServerFailure(e.message));
    } on OBSSoundException catch (e) {
      return Left(OBSSoundFailure(e.message));
    } on OBSScenesException catch (e) {
      return Left(OBSScenesFailure(e.message));
    } on OBSSourcesException catch (e) {
      return Left(OBSSourcesFailure(e.message));
    } on SocketException catch (e) {
      return Left(SocketFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeOutFailure(e.message ?? ''));
    } on OBSException catch (e) {
      return Left(OBSFailure(e.message));
    } on Exception catch (e) {
      return Left(OBSFailure(e.toString()));
    }
  }
}
