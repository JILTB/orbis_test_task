import 'package:dio/dio.dart';

enum MethodType {
  get,
  post,
}

abstract class BaseRequestModel {
  MethodType get type;

  String get path;

  int get timeout => 20000;

  Map<String, dynamic>? get queryParameters => null;

  dynamic get body => null;

  String? get filePath => null;

  ProgressCallback? get onReceiveProgress => null;

  ProgressCallback? get onSendProgress => null;

  CancelToken? get cancelToken => null;
}
