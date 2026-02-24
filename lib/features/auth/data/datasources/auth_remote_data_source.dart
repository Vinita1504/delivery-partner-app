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
            e.response?.data['data']['message'] as String? ??
            'Invalid credentials';
        throw ServerException(message: message, statusCode: 401);
      }

      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> forgotPasswordSendOtp(String phone) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.forgotPasswordSendOtp,
        data: {'phone': phone},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to send OTP',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message'] ??
            e.message ??
            'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> forgotPasswordVerifyOtp(String phone, String otpCode) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.forgotPasswordVerifyOtp,
        data: {'phone': phone, 'otp': otpCode},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to verify OTP',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message'] ??
            e.message ??
            'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> forgotPasswordReset(
    String phone,
    String otpCode,
    String newPassword,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.forgotPasswordReset,
        data: {'phone': phone, 'otp': otpCode, 'newPassword': newPassword},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to reset password',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message'] ??
            e.message ??
            'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.changePassword,
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to change password',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message'] ??
            e.message ??
            'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> updateDeviceToken(String token) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoints.updateDeviceToken,
        data: {'deviceToken': token},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to update device token',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message'] ??
            e.message ??
            'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
