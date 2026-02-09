import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/dashboard_stats_model.dart';

/// Remote data source for dashboard-related API calls
abstract class DashboardRemoteDataSource {
  /// Get dashboard statistics
  Future<DashboardStatsModel> getDashboardStats();
}

/// Implementation of DashboardRemoteDataSource
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient _dioClient;

  DashboardRemoteDataSourceImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    debugPrint('📊 [DashboardDS] Fetching dashboard stats');
    try {
      final response = await _dioClient.get(ApiEndpoints.dashboard);
      if (response.statusCode == 200) {
        // Parse the inner 'data' object from API response
        final stats = DashboardStatsModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
        debugPrint(
          '✅ [DashboardDS] Stats - Assigned: ${stats.assignedCount}, '
          'Today: ${stats.deliveredToday}, Total: ${stats.totalDelivered}',
        );
        return stats;
      } else {
        throw Exception('Failed to fetch dashboard stats');
      }
    } catch (e) {
      debugPrint('❌ [DashboardDS] Error fetching dashboard stats: $e');
      rethrow;
    }
  }
}
