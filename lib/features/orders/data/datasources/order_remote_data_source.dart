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

  /// Mark order as out for delivery
  Future<void> markOrderOutForDelivery(String orderId);

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
      final ordersResponse = OrdersResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      debugPrint(
        '✅ [OrderDS] Fetched ${ordersResponse.data.orders.length} orders '
        '(page ${ordersResponse.data.pagination.page}/${ordersResponse.data.pagination.totalPages})',
      );
      return ordersResponse;
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
      final order = OrderModel.fromJson(response.data as Map<String, dynamic>);
      debugPrint('✅ [OrderDS] Fetched order: ${order.orderNumber}');
      return order;
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
  Future<void> markOrderOutForDelivery(String orderId) async {
    debugPrint(
      '🚚 [OrderDS] Marking order as out for delivery - orderId: $orderId',
    );
    try {
      await _dioClient.post(ApiEndpoints.markOrderOutForDelivery(orderId));
      debugPrint('✅ [OrderDS] Order marked as out for delivery');
    } catch (e) {
      debugPrint('❌ [OrderDS] Error marking order as out for delivery: $e');
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
      final ordersResponse = OrdersResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      debugPrint(
        '✅ [OrderDS] Fetched ${ordersResponse.data.orders.length} history orders',
      );
      return ordersResponse;
    } catch (e) {
      debugPrint('❌ [OrderDS] Error fetching order history: $e');
      rethrow;
    }
  }
}
