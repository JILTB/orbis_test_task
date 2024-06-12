import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpClient {
  HttpClient({
    required String baseUrl,
  }) : _dio = Dio(BaseOptions(
            baseUrl: baseUrl,
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20),
            contentType: Headers.jsonContentType,
            headers: {
              HttpHeaders.acceptHeader: 'application/json',
            })) {
    _addInterceptorsToDio(_dio);
  }

  final Dio _dio;
  final _dios = <String, Dio>{};

  void _addInterceptorsToDio(Dio dio) => dio.interceptors
    ..add(InterceptorsWrapper(onRequest: (options, handler) {
      if (kDebugMode) {
        log('HttpClient->requestUrl: ${options.uri}');
      }
      handler.next(options);
    }));

  Dio _getDioForBaseUrl(String? baseUrl) {
    if (baseUrl == null) {
      return _dio;
    }
    Dio? dio = _dios[baseUrl];
    if (dio == null) {
      dio = Dio(_dio.options.copyWith(baseUrl: baseUrl));
      _addInterceptorsToDio(dio);
      _dios[baseUrl] = dio;
    }
    return dio;
  }

  Future<Options> _createRequestOptions({
    int? timeout,
    String? authToken,
    Map<String, dynamic>? extra,
  }) async {
    if (timeout == null && authToken == null) {
      return Options();
    }
    return Options(
      sendTimeout: timeout?.toMillisecondsDuration(),
      receiveTimeout: timeout?.toMillisecondsDuration(),
      headers: {
        if (authToken != null) HttpHeaders.authorizationHeader: authToken,
      },
      extra: extra,
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    String? baseUrl,
    String? authToken,
    Map<String, dynamic>? queryParameters,
    int? timeout,
    Map<String, dynamic>? extra,
  }) async {
    final options = await _createRequestOptions(
        timeout: timeout, authToken: authToken, extra: extra);
    return _getDioForBaseUrl(baseUrl).get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    String? baseUrl,
    String? authToken,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    int? timeout,
  }) async {
    final options =
        await _createRequestOptions(timeout: timeout, authToken: authToken);
    return _getDioForBaseUrl(baseUrl).post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

extension DurationMappers on int {
  Duration toMillisecondsDuration() => Duration(milliseconds: this);
}
