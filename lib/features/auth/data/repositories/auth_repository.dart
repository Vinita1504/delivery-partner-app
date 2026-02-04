import '../models/user_model.dart';

/// Auth repository interface
abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<bool> isLoggedIn();
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}
