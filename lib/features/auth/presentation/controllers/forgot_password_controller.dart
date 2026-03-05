import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';

class ForgotPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ForgotPasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isSuccess,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordController({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ForgotPasswordState());

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _authRepository.forgotPasswordSendOtp(phone);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _authRepository.forgotPasswordVerifyOtp(phone, otp);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }

  Future<bool> resetPassword(
    String phone,
    String otp,
    String newPassword,
  ) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _authRepository.forgotPasswordReset(
      phone,
      otp,
      newPassword,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final forgotPasswordControllerProvider =
    StateNotifierProvider.autoDispose<
      ForgotPasswordController,
      ForgotPasswordState
    >((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      return ForgotPasswordController(authRepository: authRepository);
    });
