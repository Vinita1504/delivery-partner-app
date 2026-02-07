import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/network/network_provider.dart';
import '../../data/datasources/order_remote_data_source.dart';
import '../../data/models/order_model.dart';

/// Order detail state for managing single order details
class OrderDetailState {
  final OrderModel? order;
  final bool isLoading;
  final bool isUpdating;
  final String? error;
  final String? updateError;

  const OrderDetailState({
    this.order,
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
    this.updateError,
  });

  /// Check if data is loaded
  bool get hasData => order != null;

  /// Check if there's an error
  bool get hasError => error != null;

  /// Check if there's an update error
  bool get hasUpdateError => updateError != null;

  OrderDetailState copyWith({
    OrderModel? order,
    bool? isLoading,
    bool? isUpdating,
    String? error,
    String? updateError,
    bool clearError = false,
    bool clearUpdateError = false,
  }) {
    return OrderDetailState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: clearError ? null : (error ?? this.error),
      updateError: clearUpdateError ? null : (updateError ?? this.updateError),
    );
  }
}

/// Order detail notifier for handling single order logic
class OrderDetailNotifier extends StateNotifier<OrderDetailState> {
  final OrderRemoteDataSource _dataSource;

  OrderDetailNotifier({required OrderRemoteDataSource dataSource})
    : _dataSource = dataSource,
      super(const OrderDetailState());

  /// Fetch order details by ID
  Future<void> fetchOrderDetails(String orderId) async {
    if (state.isLoading) return;

    debugPrint('📦 [OrderDetailNotifier] Fetching order details: $orderId');
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final order = await _dataSource.getOrderDetails(orderId);
      state = state.copyWith(order: order, isLoading: false);
      debugPrint('✅ [OrderDetailNotifier] Order fetched: ${order.orderNumber}');
    } catch (e) {
      debugPrint('❌ [OrderDetailNotifier] Error fetching order: $e');
      state = state.copyWith(isLoading: false, error: _getErrorMessage(e));
    }
  }

  /// Mark order as picked up
  Future<bool> markAsPickedUp() async {
    if (state.order == null || state.isUpdating) return false;

    debugPrint('🚚 [OrderDetailNotifier] Marking order as picked up');
    state = state.copyWith(isUpdating: true, clearUpdateError: true);

    // Optimistic update
    final previousOrder = state.order!;
    state = state.copyWith(
      order: previousOrder.copyWith(orderStatus: OrderStatus.pickedUp.value),
    );

    try {
      await _dataSource.markOrderPickedUp(previousOrder.id);
      state = state.copyWith(isUpdating: false);
      debugPrint('✅ [OrderDetailNotifier] Order marked as picked up');
      return true;
    } catch (e) {
      debugPrint('❌ [OrderDetailNotifier] Error: $e');
      // Rollback
      state = state.copyWith(
        order: previousOrder,
        isUpdating: false,
        updateError: _getErrorMessage(e),
      );
      return false;
    }
  }

  /// Mark order as out for delivery
  Future<bool> markAsOutForDelivery() async {
    if (state.order == null || state.isUpdating) return false;

    debugPrint('🚚 [OrderDetailNotifier] Marking order as out for delivery');
    state = state.copyWith(isUpdating: true, clearUpdateError: true);

    final previousOrder = state.order!;
    state = state.copyWith(
      order: previousOrder.copyWith(
        orderStatus: OrderStatus.outForDelivery.value,
      ),
    );

    try {
      await _dataSource.markOrderOutForDelivery(previousOrder.id);
      state = state.copyWith(isUpdating: false);
      debugPrint('✅ [OrderDetailNotifier] Order marked as out for delivery');
      return true;
    } catch (e) {
      debugPrint('❌ [OrderDetailNotifier] Error: $e');
      state = state.copyWith(
        order: previousOrder,
        isUpdating: false,
        updateError: _getErrorMessage(e),
      );
      return false;
    }
  }

  /// Complete delivery with optional OTP
  Future<bool> completeDelivery({String? otp}) async {
    if (state.order == null || state.isUpdating) return false;

    debugPrint('🎯 [OrderDetailNotifier] Completing delivery');
    state = state.copyWith(isUpdating: true, clearUpdateError: true);

    final previousOrder = state.order!;
    state = state.copyWith(
      order: previousOrder.copyWith(orderStatus: OrderStatus.delivered.value),
    );

    try {
      await _dataSource.completeDelivery(previousOrder.id, otp: otp);
      state = state.copyWith(isUpdating: false);
      debugPrint('✅ [OrderDetailNotifier] Delivery completed');
      return true;
    } catch (e) {
      debugPrint('❌ [OrderDetailNotifier] Error: $e');
      state = state.copyWith(
        order: previousOrder,
        isUpdating: false,
        updateError: _getErrorMessage(e),
      );
      return false;
    }
  }

  /// Clear errors
  void clearError() {
    state = state.copyWith(clearError: true, clearUpdateError: true);
  }

  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('socket') || errorStr.contains('connection')) {
      return 'No internet connection. Please check your network.';
    }
    if (errorStr.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (errorStr.contains('404') || errorStr.contains('not found')) {
      return 'Order not found or not assigned to you.';
    }
    if (errorStr.contains('otp') || errorStr.contains('invalid')) {
      return 'Invalid OTP. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}

/// Provider for OrderDetailNotifier - family provider for different order IDs
final orderDetailProvider =
    StateNotifierProvider.family<OrderDetailNotifier, OrderDetailState, String>(
      (ref, orderId) {
        final dataSource = ref.watch(orderRemoteDataSourceProvider);
        final notifier = OrderDetailNotifier(dataSource: dataSource);
        // Auto-fetch on creation
        notifier.fetchOrderDetails(orderId);
        return notifier;
      },
    );

/// Provider for OrderRemoteDataSource (shared with orders_provider.dart)
final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return OrderRemoteDataSourceImpl(dioClient: dioClient);
});
