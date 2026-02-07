import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/network/network_provider.dart';
import '../../../orders/data/datasources/order_remote_data_source.dart';
import '../../../orders/data/models/order_model.dart';

/// Order history state with filter and pagination
class OrderHistoryState {
  final List<OrderModel> orders;
  final OrderHistoryFilter currentFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? error;
  final bool hasReachedEnd;
  final int currentPage;
  final int totalPages;

  const OrderHistoryState({
    this.orders = const [],
    this.currentFilter = OrderHistoryFilter.all,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.error,
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  bool get isEmpty => orders.isEmpty && !isLoading;
  bool get hasError => error != null;
  bool get canLoadMore => !hasReachedEnd && !isLoadingMore && !isLoading;

  OrderHistoryState copyWith({
    List<OrderModel>? orders,
    OrderHistoryFilter? currentFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
    bool? hasReachedEnd,
    int? currentPage,
    int? totalPages,
  }) {
    return OrderHistoryState(
      orders: orders ?? this.orders,
      currentFilter: currentFilter ?? this.currentFilter,
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

/// Order history notifier with filter and pagination support
class OrderHistoryNotifier extends StateNotifier<OrderHistoryState> {
  final OrderRemoteDataSource _dataSource;
  static const int _pageSize = 20;

  OrderHistoryNotifier({required OrderRemoteDataSource dataSource})
    : _dataSource = dataSource,
      super(const OrderHistoryState());

  /// Fetch order history with current filter
  Future<void> fetchHistory({OrderHistoryFilter? filter}) async {
    if (state.isLoading) return;

    final newFilter = filter ?? state.currentFilter;
    debugPrint(
      '📜 [OrderHistoryNotifier] Fetching history - filter: ${newFilter.value}',
    );

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      currentFilter: newFilter,
      currentPage: 1,
      hasReachedEnd: false,
    );

    try {
      final response = await _dataSource.getOrderHistory(
        filter: newFilter.value,
        page: 1,
        limit: _pageSize,
      );

      state = state.copyWith(
        orders: response.data.orders,
        isLoading: false,
        currentPage: response.data.pagination.page,
        totalPages: response.data.pagination.totalPages,
        hasReachedEnd: !response.data.pagination.hasMorePages,
      );
      debugPrint(
        '✅ [OrderHistoryNotifier] Fetched ${response.data.orders.length} orders',
      );
    } catch (e) {
      debugPrint('❌ [OrderHistoryNotifier] Error: $e');
      state = state.copyWith(isLoading: false, error: _getErrorMessage(e));
    }
  }

  /// Load next page for infinite scroll
  Future<void> loadMore() async {
    if (!state.canLoadMore) return;

    final nextPage = state.currentPage + 1;
    debugPrint('📜 [OrderHistoryNotifier] Loading more - page $nextPage');
    state = state.copyWith(isLoadingMore: true);

    try {
      final response = await _dataSource.getOrderHistory(
        filter: state.currentFilter.value,
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
        '✅ [OrderHistoryNotifier] Loaded ${response.data.orders.length} more',
      );
    } catch (e) {
      debugPrint('❌ [OrderHistoryNotifier] Error loading more: $e');
      state = state.copyWith(isLoadingMore: false, error: _getErrorMessage(e));
    }
  }

  /// Change filter and refresh
  Future<void> changeFilter(OrderHistoryFilter filter) async {
    if (filter == state.currentFilter && state.orders.isNotEmpty) return;
    await fetchHistory(filter: filter);
  }

  /// Pull-to-refresh
  Future<void> refresh() async {
    debugPrint('🔄 [OrderHistoryNotifier] Refreshing...');
    state = state.copyWith(isRefreshing: true);

    try {
      final response = await _dataSource.getOrderHistory(
        filter: state.currentFilter.value,
        page: 1,
        limit: _pageSize,
      );

      state = state.copyWith(
        orders: response.data.orders,
        isRefreshing: false,
        currentPage: 1,
        totalPages: response.data.pagination.totalPages,
        hasReachedEnd: !response.data.pagination.hasMorePages,
        clearError: true,
      );
      debugPrint('✅ [OrderHistoryNotifier] Refresh complete');
    } catch (e) {
      debugPrint('❌ [OrderHistoryNotifier] Error refreshing: $e');
      state = state.copyWith(isRefreshing: false, error: _getErrorMessage(e));
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
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

/// Order history provider with API integration
final orderHistoryProvider =
    StateNotifierProvider<OrderHistoryNotifier, OrderHistoryState>((ref) {
      final dataSource = ref.watch(orderRemoteDataSourceProvider);
      return OrderHistoryNotifier(dataSource: dataSource);
    });

/// Provider for OrderRemoteDataSource (import from orders_provider)
final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return OrderRemoteDataSourceImpl(dioClient: dioClient);
});
