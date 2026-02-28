import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/order_model.dart';
import '../models/orders_response_model.dart';

/// Remote data source for order-related API calls
abstract class OrderRemoteDataSource {
  /// Get all assigned orders with pagination
  Future<OrdersResponseModel> getAssignedOrders({int page = 1, int limit = 20});

  /// Get order details by ID
  Future<OrderModel> getOrderDetails(String orderId);

  /// Mark order as picked up
  Future<void> markOrderPickedUp(String orderId);

  /// Mark return as picked up
  Future<void> markReturnPickedUp(String orderId);

  /// Mark order as returned
  Future<void> markAsReturned(String orderId);

  /// Mark order as out for delivery
  /// Returns: {success, message, requiresOtp, otpSent, devOtp}
  Future<Map<String, dynamic>> markOrderOutForDelivery(String orderId);

  /// Send OTP to customer (manual resend)
  /// Returns: {success, message, expiresIn, devOtp}
  Future<Map<String, dynamic>> sendOtp(String orderId);

  /// Verify OTP for delivery
  /// Returns: {success, message}
  Future<Map<String, dynamic>> verifyOtp(String orderId, String otp);

  /// Complete delivery (with optional OTP for prepaid orders)
  Future<Map<String, dynamic>> completeDelivery(String orderId, {String? otp});

  /// Get order history with filter and pagination
  Future<OrdersResponseModel> getOrderHistory({
    String filter = 'all',
    int page = 1,
    int limit = 20,
  });
}

/// Implementation of OrderRemoteDataSource
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final DioClient _dioClient;

  OrderRemoteDataSourceImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<OrdersResponseModel> getAssignedOrders({
    int page = 1,
    int limit = 20,
  }) async {
    debugPrint(
      '📦 [OrderDS] Fetching assigned orders - page: $page, limit: $limit',
    );
    try {
      final response = await _dioClient.get(
        ApiEndpoints.assignedOrders,
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.statusCode == 200) {
        // Parse the inner 'data' object directly as OrdersDataModel
        final ordersData = OrdersDataModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
        // Construct OrdersResponseModel with success=true
        final ordersResponse = OrdersResponseModel(
          success: true,
          data: ordersData,
        );
        log("assigned orders: ${ordersData.orders.length}");
        debugPrint(
          '✅ [OrderDS] Fetched ${ordersData.orders.length} orders '
          '(page ${ordersData.pagination.page}/${ordersData.pagination.totalPages})',
        );
        return ordersResponse;
      } else {
        throw Exception('Failed to fetch assigned orders');
      }
    } catch (e) {
      debugPrint('❌ [OrderDS] Error fetching assigned orders: $e');
      rethrow;
    }
  }

  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    debugPrint('📦 [OrderDS] Fetching order details - orderId: $orderId');
    try {
      final response = await _dioClient.get(
        ApiEndpoints.deliveryAgentOrderDetails(orderId),
      );
      if (response.statusCode == 200) {
        // Parse the inner 'data' object
        final order = OrderModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
        debugPrint('✅ [OrderDS] Fetched order: ${order.orderNumber}');
        return order;
      } else {
        throw Exception('Failed to fetch order details');
      }
    } catch (e) {
      debugPrint('❌ [OrderDS] Error fetching order details: $e');
      rethrow;
    }
  }

  @override
  Future<void> markOrderPickedUp(String orderId) async {
    debugPrint('🚚 [OrderDS] Marking order as picked up - orderId: $orderId');
    try {
      await _dioClient.post(ApiEndpoints.markOrderPickedUp(orderId));
      debugPrint('✅ [OrderDS] Order marked as picked up');
    } catch (e) {
      debugPrint('❌ [OrderDS] Error marking order as picked up: $e');
      rethrow;
    }
  }

  @override
  Future<void> markReturnPickedUp(String orderId) async {
    debugPrint('🚚 [OrderDS] Marking return as picked up - orderId: $orderId');
    try {
      await _dioClient.post(ApiEndpoints.markOrderReturnPickedUp(orderId));
      debugPrint('✅ [OrderDS] Return marked as picked up');
    } catch (e) {
      debugPrint('❌ [OrderDS] Error marking return as picked up: $e');
      rethrow;
    }
  }

  @override
  Future<void> markAsReturned(String orderId) async {
    debugPrint('🚚 [OrderDS] Marking order as returned - orderId: $orderId');
    try {
      await _dioClient.post(ApiEndpoints.markOrderReturned(orderId));
      debugPrint('✅ [OrderDS] Order marked as returned');
    } catch (e) {
      debugPrint('❌ [OrderDS] Error marking order as returned: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> markOrderOutForDelivery(String orderId) async {
    debugPrint(
      '🚚 [OrderDS] Marking order as out for delivery - orderId: $orderId',
    );
    try {
      final response = await _dioClient.post(
        ApiEndpoints.markOrderOutForDelivery(orderId),
      );
      final data = response.data as Map<String, dynamic>? ?? {};
      debugPrint(
        '✅ [OrderDS] Order marked as out for delivery. '
        'requiresOtp: ${data['requiresOtp']}, otpSent: ${data['otpSent']}',
      );
      return data;
    } catch (e) {
      debugPrint('❌ [OrderDS] Error marking order as out for delivery: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> sendOtp(String orderId) async {
    debugPrint('📤 [OrderDS] Sending OTP for order: $orderId');
    try {
      final response = await _dioClient.post(ApiEndpoints.sendOtp(orderId));
      final data = response.data as Map<String, dynamic>? ?? {};
      debugPrint('✅ [OrderDS] OTP sent. expiresIn: ${data['expiresIn']}');
      return data;
    } catch (e) {
      debugPrint('❌ [OrderDS] Error sending OTP: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String orderId, String otp) async {
    debugPrint('🔐 [OrderDS] Verifying OTP for order: $orderId');
    try {
      final response = await _dioClient.post(
        ApiEndpoints.verifyOtpDelivery(orderId),
        data: {'otp': otp},
      );
      final data = response.data as Map<String, dynamic>? ?? {};
      debugPrint('✅ [OrderDS] OTP verification result: ${data['success']}');
      return data;
    } catch (e) {
      debugPrint('❌ [OrderDS] Error verifying OTP: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> completeDelivery(
    String orderId, {
    String? otp,
  }) async {
    debugPrint('🎯 [OrderDS] Completing delivery - orderId: $orderId');
    try {
      final response = await _dioClient.post(
        ApiEndpoints.completeDelivery(orderId),
        data: otp != null ? {'otp': otp} : null,
      );
      debugPrint('✅ [OrderDS] Delivery completed');
      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      debugPrint('❌ [OrderDS] Error completing delivery: $e');
      rethrow;
    }
  }

  @override
  Future<OrdersResponseModel> getOrderHistory({
    String filter = 'all',
    int page = 1,
    int limit = 20,
  }) async {
    debugPrint(
      '📜 [OrderDS] Fetching order history - filter: $filter, page: $page',
    );
    try {
      final response = await _dioClient.get(
        ApiEndpoints.orderHistory,
        queryParameters: {'filter': filter, 'page': page, 'limit': limit},
      );
      if (response.statusCode == 200) {
        // Parse the inner 'data' object directly as OrdersDataModel
        final ordersData = OrdersDataModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
        // Construct OrdersResponseModel with success=true
        final ordersResponse = OrdersResponseModel(
          success: true,
          data: ordersData,
        );
        debugPrint(
          '✅ [OrderDS] Fetched ${ordersData.orders.length} history orders',
        );
        return ordersResponse;
      } else {
        throw Exception('Failed to fetch order history');
      }
    } catch (e) {
      debugPrint('❌ [OrderDS] Error fetching order history: $e');
      rethrow;
    }
  }
}
