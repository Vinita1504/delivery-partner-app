import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/network_provider.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/models/dashboard_stats_model.dart';

/// Dashboard state for managing dashboard statistics
class DashboardState {
  final DashboardStatsModel? stats;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;

  const DashboardState({
    this.stats,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  /// Check if data is loaded
  bool get hasData => stats != null;

  /// Check if there's an error
  bool get hasError => error != null;

  /// Get stats or empty default
  DashboardStatsModel get displayStats => stats ?? DashboardStatsModel.empty;

  DashboardState copyWith({
    DashboardStatsModel? stats,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
  }) {
    return DashboardState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Dashboard notifier for handling dashboard logic with API integration
class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardRemoteDataSource _dataSource;

  DashboardNotifier({required DashboardRemoteDataSource dataSource})
    : _dataSource = dataSource,
      super(const DashboardState());

  /// Fetch dashboard statistics
  Future<void> fetchStats() async {
    if (state.isLoading) return;

    debugPrint('📊 [DashboardNotifier] Fetching dashboard stats...');
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final stats = await _dataSource.getDashboardStats();
      state = state.copyWith(stats: stats, isLoading: false);
      debugPrint('✅ [DashboardNotifier] Stats fetched successfully');
    } catch (e) {
      debugPrint('❌ [DashboardNotifier] Error fetching stats: $e');
      state = state.copyWith(isLoading: false, error: _getErrorMessage(e));
    }
  }

  /// Refresh dashboard statistics
  Future<void> refresh() async {
    debugPrint('🔄 [DashboardNotifier] Refreshing dashboard stats...');
    state = state.copyWith(isRefreshing: true);

    try {
      final stats = await _dataSource.getDashboardStats();
      state = state.copyWith(
        stats: stats,
        isRefreshing: false,
        clearError: true,
      );
      debugPrint('✅ [DashboardNotifier] Stats refreshed successfully');
    } catch (e) {
      debugPrint('❌ [DashboardNotifier] Error refreshing stats: $e');
      state = state.copyWith(isRefreshing: false, error: _getErrorMessage(e));
    }
  }

  /// Clear error
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

/// Provider for DashboardRemoteDataSource
final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((
  ref,
) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardRemoteDataSourceImpl(dioClient: dioClient);
});

/// Dashboard provider with API integration
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      final dataSource = ref.watch(dashboardRemoteDataSourceProvider);
      return DashboardNotifier(dataSource: dataSource);
    });
