import '../dto/login_request_dto.dart';
import '../dto/login_response_dto.dart';

/// Abstract data source for authentication operations
/// Follows Interface Segregation Principle (ISP)
abstract class AuthDataSource {
  /// Login delivery agent with email and password
  /// Returns [LoginResponseDTO] on success
  /// Throws [ServerException] on API errors
  Future<LoginResponseDTO> loginDeliveryAgent(LoginRequestDTO request);

  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> updateDeviceToken(String token);

  Future<void> forgotPasswordSendOtp(String phone);
  Future<void> forgotPasswordVerifyOtp(String phone, String otpCode);
  Future<void> forgotPasswordReset(
    String phone,
    String otpCode,
    String newPassword,
  );
}
