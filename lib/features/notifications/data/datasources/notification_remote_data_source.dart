import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../models/app_notification.dart';

class NotificationRemoteDataSource {
  final DioClient _dioClient;

  NotificationRemoteDataSource({required DioClient dioClient}) : _dioClient = dioClient;

  Future<List<AppNotification>> fetchNotifications({int page = 1, int limit = 20}) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.notifications,
        queryParameters: {'page': page, 'limit': limit},
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data']['notifications'] as List;
        return data.map((json) {
          final jsonObj = json as Map<String, dynamic>;
          final notifData = jsonObj['data'] is Map ? (jsonObj['data'] as Map<String, dynamic>) : <String, dynamic>{};
          
          NotificationType type = NotificationType.general;
          if (notifData['type'] == 'order_assigned' || jsonObj['type'] == 'DELIVERY_ASSIGNMENT') {
            type = NotificationType.orderAssigned;
          }
          
          return AppNotification(
            id: jsonObj['id'] ?? '',
            title: jsonObj['title'] ?? '',
            body: jsonObj['message'] ?? '',
            type: type,
            orderId: notifData['orderId'],
            orderNumber: notifData['orderNumber'],
            createdAt: jsonObj['createdAt'] != null ? DateTime.parse(jsonObj['createdAt']) : DateTime.now(),
            isRead: jsonObj['isRead'] ?? false,
          );
        }).toList();
      }
      throw ServerException(message: 'Failed to fetch notifications');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final response = await _dioClient.patch(ApiEndpoints.markNotificationRead(id));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to mark notification as read');
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _dioClient.patch(ApiEndpoints.markAllNotificationsRead);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to mark all as read');
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
