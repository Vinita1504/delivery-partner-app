import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging HTTP requests and responses in debug mode
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '┌─────────────────────────────────────────────────────────',
        name: 'HTTP',
      );
      developer.log(
        '│ 🚀 REQUEST: ${options.method} ${options.uri}',
        name: 'HTTP',
      );
      if (options.headers.isNotEmpty) {
        developer.log('│ Headers: ${options.headers}', name: 'HTTP');
      }
      if (options.data != null) {
        developer.log('│ Body: ${options.data}', name: 'HTTP');
      }
      if (options.queryParameters.isNotEmpty) {
        developer.log('│ Query: ${options.queryParameters}', name: 'HTTP');
      }
      developer.log(
        '└─────────────────────────────────────────────────────────',
        name: 'HTTP',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '┌─────────────────────────────────────────────────────────',
        name: 'HTTP',
      );
      developer.log(
        '│ ✅ RESPONSE [${response.statusCode}]: ${response.requestOptions.uri}',
        name: 'HTTP',
      );
      developer.log('│ Data: ${response.data}', name: 'HTTP');
      developer.log(
        '└─────────────────────────────────────────────────────────',
        name: 'HTTP',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '┌─────────────────────────────────────────────────────────',
        name: 'HTTP',
      );
      developer.log(
        '│ ❌ ERROR [${err.response?.statusCode}]: ${err.requestOptions.uri}',
        name: 'HTTP',
      );
      developer.log('│ Message: ${err.message}', name: 'HTTP');
      if (err.response?.data != null) {
        developer.log('│ Response: ${err.response?.data}', name: 'HTTP');
      }
      developer.log(
        '└─────────────────────────────────────────────────────────',
        name: 'HTTP',
      );
    }
    handler.next(err);
  }
}
