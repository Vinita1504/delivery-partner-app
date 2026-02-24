import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/delivery_agent_entity.dart';

/// Abstract repository interface in the domain layer
/// Data layer will implement this interface (Dependency Inversion Principle)
abstract class AuthRepository {
  /// Login with email and password
  /// Returns Either Failure or DeliveryAgentEntity
  Future<Either<Failure, DeliveryAgentEntity>> login(
    String email,
    String password,
  );

  /// Logout the current user
  Future<Either<Failure, void>> logout();

  /// Get current logged in user
  Future<Either<Failure, DeliveryAgentEntity>> getCurrentUser();

  /// Change password
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  );

  /// Update FCM device token
  Future<Either<Failure, void>> updateDeviceToken(String token);

  /// Forgot password - Send OTP
  Future<Either<Failure, void>> forgotPasswordSendOtp(String phone);

  /// Forgot password - Verify OTP
  Future<Either<Failure, void>> forgotPasswordVerifyOtp(
    String phone,
    String otpCode,
  );

  /// Forgot password - Reset
  Future<Either<Failure, void>> forgotPasswordReset(
    String phone,
    String otpCode,
    String newPassword,
  );

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get stored token
  Future<String?> getToken();

  /// Save token
  Future<void> saveToken(String token);

  /// Clear token
  Future<void> clearToken();
}
