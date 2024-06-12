import 'dart:async';

import 'package:orbis_test_task/misc/errors.dart';
import 'package:orbis_test_task/misc/result.dart';
import 'package:orbis_test_task/misc/result_stream_transformer.dart';
import 'package:rxdart/rxdart.dart';

extension NullFilters<T extends Object> on Stream<T?> {
  Stream<T?> whereNull() => where((e) => e == null);

  Stream<T> compactWhere(bool Function(T event) test) =>
      transform<T>(StreamTransformer<T?, T>.fromHandlers(
        handleData: (T? event, sink) {
          if (event != null && test(event)) {
            sink.add(event);
          }
        },
      ));

  Future<T> get firstNotNull => whereNotNull().first;
}

extension NotNullMappers<T, R> on Stream<R> {
  Stream<T> compactMap(T? Function(R event) mapper) =>
      transform<T>(StreamTransformer<R, T>.fromHandlers(
        handleData: (R event, sink) {
          final result = mapper(event);
          if (result != null) {
            sink.add(result);
          }
        },
      ));
}

extension StreamTransformers<S> on Stream<S> {
  Stream<T> toLatestFrom<T>(Stream<T> latestFromStream) =>
      withLatestFrom<T, T>(latestFromStream, (S t, T s) => s);
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

extension FilterWith<T> on Stream<T> {
  Stream<T> filterWith(Stream<bool> filterStream) {
    return withLatestFrom(filterStream,
            (T data, bool filter) => _DataWithFilter(data, filter))
        .where((d) => d.filter)
        .map((d) => d.data);
  }
}

class _DataWithFilter<T> {
  final T data;
  final bool filter;

  _DataWithFilter(this.data, this.filter);
}
