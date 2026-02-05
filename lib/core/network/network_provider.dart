import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dio_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'network_info.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart',
  );
});

/// Provider for AuthInterceptor
final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return AuthInterceptor(sharedPreferences: sharedPreferences);
});

/// Provider for LoggingInterceptor
final loggingInterceptorProvider = Provider<LoggingInterceptor>((ref) {
  return LoggingInterceptor();
});

/// Provider for ErrorInterceptor
final errorInterceptorProvider = Provider<ErrorInterceptor>((ref) {
  return ErrorInterceptor();
});

/// Provider for DioClient - main configured Dio instance
final dioClientProvider = Provider<DioClient>((ref) {
  final authInterceptor = ref.watch(authInterceptorProvider);
  final loggingInterceptor = ref.watch(loggingInterceptorProvider);
  final errorInterceptor = ref.watch(errorInterceptorProvider);

  return DioClient(
    authInterceptor: authInterceptor,
    loggingInterceptor: loggingInterceptor,
    errorInterceptor: errorInterceptor,
  );
});

/// Provider for NetworkInfo
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});
