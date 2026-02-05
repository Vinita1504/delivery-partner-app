import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/network_provider.dart';
import '../../data/datasources/auth_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

// ==================== Data Layer Providers ====================

/// Provider for AuthDataSource
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDataSource(dioClient: dioClient);
});

/// Provider for AuthRepository implementation
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  final authDataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(
    sharedPreferences: sharedPreferences,
    authDataSource: authDataSource,
  );
});

// ==================== Domain Layer Providers (Use Cases) ====================

/// Provider for LoginUseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Provider for LogoutUseCase
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

/// Provider for GetCurrentUserUseCase
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

// ==================== Utility Providers ====================

/// Provider for checking if user is logged in
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.isLoggedIn();
});

/// Provider for getting the stored auth token
final authTokenProvider = FutureProvider<String?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getToken();
});
