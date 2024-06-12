import 'dart:async';

import 'package:orbis_test_task/misc/errors.dart';

abstract class Result<T> {
  factory Result.success(T data) {
    return ResultSuccess._(data);
  }

  factory Result.loading() {
    return ResultLoading._();
  }

  factory Result.error(AppError? error) {
    return ResultError._(error);
  }

  bool get isLoading;
  bool get isSuccess;
  bool get isFail;
  T? get data;
}

class ResultLoading<T> implements Result<T> {
  ResultLoading._();

  @override
  bool get isLoading => true;

  @override
  bool get isSuccess => false;

  @override
  bool get isFail => false;

  @override
  T? get data => null;
}

class ResultSuccess<T> implements Result<T> {
  ResultSuccess._(this.data);

  @override
  final T data;

  @override
  bool get isLoading => false;

  @override
  bool get isSuccess => true;

  @override
  bool get isFail => false;
}

class ResultError<T> implements Result<T> {
  ResultError._(this.error);

  final AppError? error;

  @override
  bool get isLoading => false;

  @override
  bool get isSuccess => false;

  @override
  bool get isFail => true;

  @override
  T? get data => null;
}

extension ResultMappers<S> on Future<Result<S>> {
  Future<Result<R>> mapResult<R>(FutureOr Function(S data) mapper) =>
      then((result) async {
        if (result.isLoading) {
          return Result<R>.loading();
        }
        if (result.isSuccess) {
          try {
            return Result<R>.success(
                await mapper((result as ResultSuccess<S>).data));
          } catch (e) {
            if (e is ResultError) {
              return Result<R>.error(e.error);
            }
            return Result<R>.error(SimpleError(e.toString()));
          }
        }
        return Result<R>.error((result as ResultError).error);
      });
}
