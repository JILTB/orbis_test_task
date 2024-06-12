import 'dart:async';

import 'package:orbis_test_task/misc/errors.dart';
import 'package:orbis_test_task/misc/result.dart';
import 'package:orbis_test_task/misc/result_stream_transformer.dart';

extension NullFilters<T extends Object> on Stream<T?> {
  Stream<T?> whereNull() => where((e) => e == null);
}

extension ResultStreamFilters<T> on Stream<Result<T>> {
  Stream<T> whereSuccess() =>
      transform<T>(StreamTransformer<Result<T>, T>.fromHandlers(
        handleData: (Result<T> event, sink) {
          if (event is ResultSuccess<T>) {
            sink.add(event.data);
          }
        },
      ));

  Stream<AppError> whereError() =>
      transform<AppError>(StreamTransformer<Result<T>, AppError>.fromHandlers(
        handleData: (Result<T> event, sink) {
          if (event is ResultError<T>) {
            sink.add(event.error!);
          }
        },
      ));

  Stream<bool> isLoading() => map((event) => event is ResultLoading);

  Stream<bool> isSuccessful() =>
      transform<bool>(StreamTransformer<Result<T>, bool>.fromHandlers(
        handleData: (Result<T> event, sink) {
          if (event is! ResultLoading) {
            sink.add(event.isSuccess);
          }
        },
      ));

  Stream<Result<R>> mapResult<R>(FutureOr<R> Function(T) mapper) =>
      transform<Result<R>>(ResultStreamTransformer(mapper));
}

extension BoolFilters on Stream<bool> {
  Stream<bool> whereTrue() => where((event) => event);

  Stream<bool> whereFalse() => where((event) => !event);
}
