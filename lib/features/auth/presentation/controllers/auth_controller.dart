import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../providers/auth_providers.dart';
import 'auth_state.dart';

/// Auth Controller using Riverpod StateNotifier
/// Separates business logic from UI
class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthController({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(const AuthState());

  /// Check if user is already logged in on app start
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, isAuthenticated: false),
      (agent) => state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        agent: agent,
      ),
    );
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    log('[AUTH_CONTROLLER] Starting login...');
    state = state.copyWith(isLoading: true, clearError: true);
    log('[AUTH_CONTROLLER] State set to loading, calling use case...');

    final result = await _loginUseCase(email, password);
    log('[AUTH_CONTROLLER] Got result from use case');

    return result.fold(
      (failure) {
        log('[AUTH_CONTROLLER] Login FAILED: ${failure.message}');
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (agent) {
        log('[AUTH_CONTROLLER] Login SUCCESS: ${agent.name}');
        log('[AUTH_CONTROLLER] Setting authenticated state...');
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          agent: agent,
        );
        log('[AUTH_CONTROLLER] State updated, returning true');
        return true;
      },
    );
  }

  /// Logout the user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final result = await _logoutUseCase();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (_) => state = const AuthState(),
    );
  }

  /// Clear any error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Auth controller provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final loginUseCase = ref.watch(loginUseCaseProvider);
    final logoutUseCase = ref.watch(logoutUseCaseProvider);
    final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);

    return AuthController(
      loginUseCase: loginUseCase,
      logoutUseCase: logoutUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
    );
  },
);
