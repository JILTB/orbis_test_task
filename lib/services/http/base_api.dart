import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:orbis_test_task/misc/errors.dart';
import 'package:orbis_test_task/misc/result.dart';
import 'package:orbis_test_task/models/network/requests/base_request_model.dart';

import 'http_client.dart';

class BaseApi {
  BaseApi(this.httpClient);

  final HttpClient httpClient;

  String? get baseUrl => null;

  String? get authToken => null;

  @protected
  Future<Result<T>> makeRequest<T>(BaseRequestModel model,
      {T Function(dynamic)? mapper, Map<String, dynamic>? extra}) async {
    try {
      dynamic json;
      switch (model.type) {
        case MethodType.get:
          json = (await httpClient.get(
            model.path,
            queryParameters: model.queryParameters,
            timeout: model.timeout,
            baseUrl: baseUrl,
            authToken: authToken,
            extra: extra,
          ))
              .data;
          break;
        case MethodType.post:
          json = (await httpClient.post(
            model.path,
            queryParameters: model.queryParameters,
            data: model.body,
            timeout: model.timeout,
            baseUrl: baseUrl,
            authToken: authToken,
          ))
              .data;
          break;
      }
      if (mapper != null) {
        return Result.success(mapper(json));
      } else {
        return Result.success(json);
      }
    } on Exception catch (e) {
      final error = _mapException(e);
      if (kDebugMode) {
        log('Error on ${model.path}: ${error.toString()}');
      }
      return Result.error(error);
    } catch (e) {
      final error = SimpleError('Invalid response: $e');
      if (kDebugMode) {
        log('Error on ${model.path}: ${error.toString()}');
      }
      return Result.error(error);
    }
  }

  AppError _mapException(Exception e) {
    if (e is DioException) {
      if (e.response == null) {
        return const ApiError(
            statusCode: 0, description: 'No internet connection');
      }
      late String description;
      try {
        description = e.response!.data['Message'] as String;
      } catch (_) {
        description = e.response!.data.toString();
      }
      String? reasons;
      try {
        reasons = e.response!.data['ModelState']?['']?[0];
      } catch (_) {}
      return ApiError(
        statusCode: e.response!.statusCode!,
        statusMessage: e.response!.statusMessage,
        description: description,
        reason: reasons,
      );
    }
    return SimpleError(e.toString());
  }
}
