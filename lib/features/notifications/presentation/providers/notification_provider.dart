import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/network_provider.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/models/app_notification.dart';

/// Key for persisting notifications in SharedPreferences
const _notificationsKey = 'app_notifications';
const _maxNotifications = 50;

/// State for notifications
class NotificationState {
  final List<AppNotification> notifications;
  final bool isLoading;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
  });

  NotificationState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Get unread notification count
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  /// Check if there are any unread notifications
  bool get hasUnread => unreadCount > 0;
}

/// Remote Data Source Provider
final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return NotificationRemoteDataSource(dioClient: dioClient);
});

/// Notification state provider
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      final remoteSource = ref.watch(notificationRemoteDataSourceProvider);
      return NotificationNotifier(prefs, remoteSource);
    });

/// Unread count provider for easy access
final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});

class NotificationNotifier extends StateNotifier<NotificationState> {
  final SharedPreferences _prefs;
  final NotificationRemoteDataSource _remoteSource;

  NotificationNotifier(this._prefs, this._remoteSource) : super(const NotificationState()) {
    _loadNotificationsLocally();
    fetchRemoteNotifications();
  }

  /// Load notifications from SharedPreferences synchronously as fallback
  void _loadNotificationsLocally() {
    try {
      final jsonString = _prefs.getString(_notificationsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final notifications = AppNotification.decodeList(jsonString);
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = state.copyWith(notifications: notifications);
      }
    } catch (e) {
      debugPrint('Error loading local notifications: $e');
    }
  }

  /// Fetch notifications from backend API
  Future<void> fetchRemoteNotifications({bool showLoader = false}) async {
    if (showLoader) {
      state = state.copyWith(isLoading: true);
    }
    
    try {
      final remoteNotifications = await _remoteSource.fetchNotifications(page: 1, limit: _maxNotifications);
      state = state.copyWith(notifications: remoteNotifications, isLoading: false);
      await _saveNotificationsLocally();
    } catch (e) {
      debugPrint('Error fetching remote notifications: $e');
      if (showLoader) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  /// Save notifications to SharedPreferences
  Future<void> _saveNotificationsLocally() async {
    try {
      final jsonString = AppNotification.encodeList(state.notifications);
      await _prefs.setString(_notificationsKey, jsonString);
    } catch (e) {
      debugPrint('Error saving local notifications: $e');
    }
  }

  /// Add a new notification locally (e.g. fired directly from FCM when app is foregrounded)
  Future<void> addNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? orderId,
    String? orderNumber,
  }) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      orderId: orderId,
      orderNumber: orderNumber,
      createdAt: DateTime.now(),
    );

    final updatedList = [notification, ...state.notifications];

    final trimmed = updatedList.length > _maxNotifications
        ? updatedList.sublist(0, _maxNotifications)
        : updatedList;

    state = state.copyWith(notifications: trimmed);
    await _saveNotificationsLocally();
    // After modifying locally, refresh remote asynchronously so unread badges sync
    fetchRemoteNotifications();
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    final updatedList = state.notifications.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    state = state.copyWith(notifications: updatedList);
    await _saveNotificationsLocally();
    
    try {
      await _remoteSource.markAsRead(notificationId);
    } catch (e) {
      debugPrint('Error remotely marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final updatedList = state.notifications.map((n) {
      return n.copyWith(isRead: true);
    }).toList();

    state = state.copyWith(notifications: updatedList);
    await _saveNotificationsLocally();
    
    try {
      await _remoteSource.markAllAsRead();
    } catch (e) {
      debugPrint('Error remotely marking all notifications as read: $e');
    }
  }

  /// Delete a notification locally
  Future<void> deleteNotification(String notificationId) async {
    final updatedList = state.notifications
        .where((n) => n.id != notificationId)
        .toList();

    state = state.copyWith(notifications: updatedList);
    await _saveNotificationsLocally();
  }

  /// Clear all notifications locally
  Future<void> clearAll() async {
    state = state.copyWith(notifications: []);
    await _prefs.remove(_notificationsKey);
  }
}
