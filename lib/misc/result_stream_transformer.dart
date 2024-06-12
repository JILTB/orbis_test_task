import 'dart:async';

import 'package:orbis_test_task/misc/errors.dart';
import 'package:orbis_test_task/misc/result.dart';

class ResultStreamTransformer<S, T>
    extends StreamTransformerBase<Result<S>, Result<T>> {
  ResultStreamTransformer(this.mapper, {this.errorMapper});

  final FutureOr<T> Function(S) mapper;
  final FutureOr<AppError?> Function(AppError?)? errorMapper;

  @override
  Stream<Result<T>> bind(Stream<Result<S>> stream) {
    return stream.asyncMap((result) async {
      if (result is ResultSuccess<S>) {
        try {
          return Result.success(await mapper(result.data));
        } on ResultError catch (e) {
          return Result<T>.error(e.error);
        }
      } else if (result is ResultError<S>) {
        return Result.error(errorMapper != null
            ? await errorMapper!(result.error)
            : result.error);
      }
      return Result.loading();
    });
  }
}

class WhenSuccess<T> extends StreamTransformerBase<Result<T>, T> {
  @override
  Stream<T> bind(Stream<Result<T>> stream) {
    return stream
        .where((r) => r is ResultSuccess<T>)
        .map((r) => (r as ResultSuccess<T>).data);
  }
}

class WhenError<T> extends StreamTransformerBase<Result<T>, AppError?> {
  @override
  Stream<AppError?> bind(Stream<Result<T>> stream) {
    return stream
        .where((r) => r is ResultError)
        .map((r) => (r as ResultError).error);
  }
}

class IsLoading<T> extends StreamTransformerBase<Result<T>, bool> {
  @override
  Stream<bool> bind(Stream<Result<T>> stream) {
    return stream.map((r) => r is ResultLoading);
  }
}
