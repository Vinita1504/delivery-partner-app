import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interceptor to add authentication token to requests
class AuthInterceptor extends Interceptor {
  final SharedPreferences _sharedPreferences;
  
  /// Key used to store the auth token in SharedPreferences
  static const String tokenKey = 'auth_token';

  AuthInterceptor({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _sharedPreferences.getString(tokenKey);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - could trigger logout or token refresh here
    if (err.response?.statusCode == 401) {
      // Token expired or invalid
      // You could emit an event or call a callback to handle logout
      // For now, we just pass the error along
    }

    handler.next(err);
  }
}
