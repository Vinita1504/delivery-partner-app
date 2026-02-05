import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/delivery_agent_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';
import '../dto/login_request_dto.dart';
import '../models/delivery_agent_model.dart';

/// Implementation of AuthRepository
/// Implements domain repository interface (Dependency Inversion Principle)
class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences _sharedPreferences;
  final AuthDataSource _authDataSource;

  /// Keys for SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _agentKey = 'agent_data';

  AuthRepositoryImpl({
    required SharedPreferences sharedPreferences,
    required AuthDataSource authDataSource,
  }) : _sharedPreferences = sharedPreferences,
       _authDataSource = authDataSource;

  @override
  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _sharedPreferences.remove(_tokenKey);
    await _sharedPreferences.remove(_refreshTokenKey);
    await _sharedPreferences.remove(_agentKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = _sharedPreferences.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _sharedPreferences.setString(_refreshTokenKey, refreshToken);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return _sharedPreferences.getString(_refreshTokenKey);
  }

  /// Save delivery agent data to local storage
  Future<void> _saveAgent(DeliveryAgentModel agent) async {
    final agentJson = jsonEncode(agent.toJson());
    await _sharedPreferences.setString(_agentKey, agentJson);
  }

  /// Get cached delivery agent data
  DeliveryAgentModel? _getCachedAgentModel() {
    final agentJson = _sharedPreferences.getString(_agentKey);
    if (agentJson == null) return null;

    try {
      final Map<String, dynamic> json = jsonDecode(agentJson);
      return DeliveryAgentModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, DeliveryAgentEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final request = LoginRequestDTO(email: email, password: password);
      final response = await _authDataSource.loginDeliveryAgent(request);

      // Save token and agent data
      await saveToken(response.token);
      await _saveAgent(response.agent);

      return Right(response.agent.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await clearToken();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeliveryAgentEntity>> getCurrentUser() async {
    final cachedAgent = _getCachedAgentModel();
    if (cachedAgent != null) {
      return Right(cachedAgent.toEntity());
    }
    return const Left(CacheFailure(message: 'No cached user data found'));
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    // TODO: Implement when API is available
    return const Left(
      ServerFailure(message: 'Change password API not implemented'),
    );
  }
}
