import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../dto/login_request_dto.dart';
import '../dto/login_response_dto.dart';
import 'auth_data_source.dart';

/// Remote data source implementation for authentication
/// Uses DioClient for HTTP requests
class AuthRemoteDataSource implements AuthDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<LoginResponseDTO> loginDeliveryAgent(LoginRequestDTO request) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.loginDeliveryAgent,
        data: request.toJson(),
      );

      final data = response.data as Map<String, dynamic>;
      log('Login response in [AUTH_REMOTE_DATA_SOURCE]: ${response.data}');
      // Check if login was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseDTO.fromJson(data['data']);
      }

      // Handle error response
      throw ServerException(
        message: data['data']['message'] as String? ?? 'Login failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      // Handle specific error codes
      if (e.response?.statusCode == 401) {
        final message =
            e.response?.data['data']['message'] as String? ?? 'Invalid credentials';
        throw ServerException(message: message, statusCode: 401);
      }

      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
