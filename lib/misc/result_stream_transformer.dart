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
