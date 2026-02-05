import '../dto/login_request_dto.dart';
import '../dto/login_response_dto.dart';

/// Abstract data source for authentication operations
/// Follows Interface Segregation Principle (ISP)
abstract class AuthDataSource {
  /// Login delivery agent with email and password
  /// Returns [LoginResponseDTO] on success
  /// Throws [ServerException] on API errors
  Future<LoginResponseDTO> loginDeliveryAgent(LoginRequestDTO request);
}
