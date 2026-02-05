import 'package:dio/dio.dart';

import '../../errors/failures.dart';

/// Interceptor to transform Dio errors into app-specific exceptions
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapDioExceptionToAppException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
        message: _getExceptionMessage(exception),
      ),
    );
  }

  String _getExceptionMessage(Exception exception) {
    if (exception is ServerException) return exception.message;
    if (exception is NetworkException) return exception.message;
    if (exception is AuthException) return exception.message;
    return 'An unexpected error occurred';
  }

  Exception _mapDioExceptionToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timed out. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(err);

      case DioExceptionType.cancel:
        return const ServerException(message: 'Request was cancelled');

      case DioExceptionType.badCertificate:
        return const ServerException(message: 'Invalid SSL certificate');

      case DioExceptionType.unknown:
        return ServerException(
          message: err.message ?? 'An unexpected error occurred',
        );
    }
  }

  Exception _handleBadResponse(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    // Try to extract error message from response
    String message = 'An error occurred';
    if (data is Map<String, dynamic>) {
      message =
          data['message'] as String? ??
          data['error'] as String? ??
          'An error occurred';
    }

    switch (statusCode) {
      case 400:
        return ServerException(message: message, statusCode: 400);
      case 401:
        return AuthException(message: message);
      case 403:
        return const AuthException(message: 'Access denied');
      case 404:
        return ServerException(message: 'Resource not found', statusCode: 404);
      case 422:
        return ServerException(message: message, statusCode: 422);
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
        );
      default:
        return ServerException(message: message, statusCode: statusCode);
    }
  }
}
