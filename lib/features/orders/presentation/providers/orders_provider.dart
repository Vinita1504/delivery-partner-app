import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/network_provider.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/services/local_notification_service.dart';
import '../../../notifications/data/models/app_notification.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../data/datasources/order_remote_data_source.dart';
import '../../data/models/order_model.dart';

/// Orders state for managing orders list with pagination
class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? error;
  final bool hasReachedEnd;
  final int currentPage;
  final int totalPages;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.error,
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  /// Check if list is empty and not loading
  bool get isEmpty => orders.isEmpty && !isLoading;

  /// Check if there's an error
  bool get hasError => error != null;

  /// Check if more pages can be loaded
  bool get canLoadMore => !hasReachedEnd && !isLoadingMore && !isLoading;

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
    bool? hasReachedEnd,
    int? currentPage,
    int? totalPages,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

/// Orders notifier for handling orders logic with API integration
class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrderRemoteDataSource _dataSource;
  final NotificationNotifier? _notificationNotifier;
  final LocalNotificationService? _localNotificationService;
  static const int _pageSize = 20;

  OrdersNotifier({
    required OrderRemoteDataSource dataSource,
    NotificationNotifier? notificationNotifier,
    LocalNotificationService? localNotificationService,
  }) : _dataSource = dataSource,
       _notificationNotifier = notificationNotifier,
       _localNotificationService = localNotificationService,
       super(const OrdersState());

  /// Initial fetch of orders
  Future<void> fetchOrders() async {
    if (state.isLoading) return;

    debugPrint('📦 [OrdersNotifier] Fetching orders...');
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      currentPage: 1,
      hasReachedEnd: false,
    );

    try {
      final response = await _dataSource.getAssignedOrders(
        page: 1,
        limit: _pageSize,
      );

      final newOrders = response.data.orders;
      final previousOrderIds = state.orders.map((o) => o.id).toSet();

      state = state.copyWith(
        orders: newOrders,
        isLoading: false,
        currentPage: response.data.pagination.page,
        totalPages: response.data.pagination.totalPages,
        hasReachedEnd: !response.data.pagination.hasMorePages,
      );

      // Detect newly assigned orders and create notifications
      _notifyNewOrders(newOrders, previousOrderIds);

      debugPrint('✅ [OrdersNotifier] Fetched ${newOrders.length} orders');
    } catch (e) {
      debugPrint('❌ [OrdersNotifier] Error fetching orders: $e');
      state = state.copyWith(isLoading: false, error: _getErrorMessage(e));
    }
  }

  /// Load next page for infinite scroll
  Future<void> loadMore() async {
    if (!state.canLoadMore) {
      debugPrint(
        '⚠️ [OrdersNotifier] Cannot load more - already loading or reached end',
      );
      return;
    }

    final nextPage = state.currentPage + 1;
    debugPrint('📦 [OrdersNotifier] Loading more orders - page $nextPage');
    state = state.copyWith(isLoadingMore: true);

    try {
      final response = await _dataSource.getAssignedOrders(
        page: nextPage,
        limit: _pageSize,
      );

      state = state.copyWith(
        orders: [...state.orders, ...response.data.orders],
        isLoadingMore: false,
        currentPage: response.data.pagination.page,
        totalPages: response.data.pagination.totalPages,
        hasReachedEnd: !response.data.pagination.hasMorePages,
      );
      debugPrint(
        '✅ [OrdersNotifier] Loaded ${response.data.orders.length} more orders',
      );
    } catch (e) {
      debugPrint('❌ [OrdersNotifier] Error loading more: $e');
      state = state.copyWith(isLoadingMore: false, error: _getErrorMessage(e));
    }
  }

  /// Pull-to-refresh
  Future<void> refresh() async {
    debugPrint('🔄 [OrdersNotifier] Refreshing orders...');
    state = state.copyWith(isRefreshing: true);

    try {
      final response = await _dataSource.getAssignedOrders(
        page: 1,
        limit: _pageSize,
      );

      final newOrders = response.data.orders;
      final previousOrderIds = state.orders.map((o) => o.id).toSet();

      state = state.copyWith(
        orders: newOrders,
        isRefreshing: false,
        currentPage: 1,
        totalPages: response.data.pagination.totalPages,
        hasReachedEnd: !response.data.pagination.hasMorePages,
        clearError: true,
      );

      // Detect newly assigned orders and create notifications
      _notifyNewOrders(newOrders, previousOrderIds);

      debugPrint('✅ [OrdersNotifier] Refresh complete');
    } catch (e) {
      debugPrint('❌ [OrdersNotifier] Error refreshing: $e');
      state = state.copyWith(isRefreshing: false, error: _getErrorMessage(e));
    }
  }

  /// Get order by ID
  OrderModel? getOrderById(String id) {
    try {
      return state.orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Update order status optimistically
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    debugPrint(
      '🔄 [OrdersNotifier] Updating order $orderId to ${newStatus.displayName}',
    );

    // Store previous state for rollback
    final previousOrders = state.orders;

    // Optimistic update
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(orderStatus: newStatus.value);
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);

    try {
      switch (newStatus) {
        case OrderStatus.pickedUp:
          await _dataSource.markOrderPickedUp(orderId);
          break;
        case OrderStatus.outForDelivery:
          await _dataSource.markOrderOutForDelivery(orderId);
          break;
        case OrderStatus.delivered:
          await _dataSource.completeDelivery(orderId);
          break;
        default:
          break;
      }
      debugPrint('✅ [OrdersNotifier] Order status updated successfully');
      return true;
    } catch (e) {
      debugPrint('❌ [OrdersNotifier] Error updating status, rolling back: $e');
      // Rollback on failure
      state = state.copyWith(
        orders: previousOrders,
        error: _getErrorMessage(e),
      );
      return false;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Detect new orders and send notifications
  void _notifyNewOrders(
    List<OrderModel> newOrders,
    Set<String> previousOrderIds,
  ) {
    if (previousOrderIds.isEmpty) return; // Skip first fetch

    for (final order in newOrders) {
      if (!previousOrderIds.contains(order.id) &&
          order.status == OrderStatus.assigned) {
        debugPrint('🔔 New order detected: ${order.orderNumber}');

        // Save to notification history
        _notificationNotifier?.addNotification(
          title: 'New Order Assigned',
          body:
              'Order #${order.orderNumber} - ${order.customerDisplayName} (${order.formattedFinalAmount})',
          type: NotificationType.orderAssigned,
          orderId: order.id,
          orderNumber: order.orderNumber,
        );

        // Show local notification banner
        _localNotificationService?.showOrderNotification(
          title: 'New Order Assigned 🚀',
          body:
              'Order #${order.orderNumber} - ${order.customerDisplayName} (${order.formattedFinalAmount})',
          payload: order.id,
        );
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection')) {
      return 'No internet connection. Please check your network.';
    }
    if (error.toString().contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}

/// Provider for OrderRemoteDataSource
final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return OrderRemoteDataSourceImpl(dioClient: dioClient);
});

/// Orders provider with API integration
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((
  ref,
) {
  final dataSource = ref.watch(orderRemoteDataSourceProvider);
  final notificationNotifier = ref.watch(notificationProvider.notifier);
  final localNotificationService = ref.watch(localNotificationServiceProvider);
  return OrdersNotifier(
    dataSource: dataSource,
    notificationNotifier: notificationNotifier,
    localNotificationService: localNotificationService,
  );
});

/// Single order provider for order details
final orderByIdProvider = Provider.family<OrderModel?, String>((ref, orderId) {
  final ordersState = ref.watch(ordersProvider);
  try {
    return ordersState.orders.firstWhere((order) => order.id == orderId);
  } catch (_) {
    return null;
  }
});
