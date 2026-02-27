import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/network_provider.dart';
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

/// Notification state provider
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return NotificationNotifier(prefs);
    });

/// Unread count provider for easy access
final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});

class NotificationNotifier extends StateNotifier<NotificationState> {
  final SharedPreferences _prefs;

  NotificationNotifier(this._prefs) : super(const NotificationState()) {
    _loadNotifications();
  }

  /// Load notifications from SharedPreferences
  void _loadNotifications() {
    try {
      final jsonString = _prefs.getString(_notificationsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final notifications = AppNotification.decodeList(jsonString);
        // Sort by most recent first
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        state = state.copyWith(notifications: notifications);
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }

  /// Save notifications to SharedPreferences
  Future<void> _saveNotifications() async {
    try {
      final jsonString = AppNotification.encodeList(state.notifications);
      await _prefs.setString(_notificationsKey, jsonString);
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  /// Add a new notification
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

    // Keep only the latest notifications
    final trimmed = updatedList.length > _maxNotifications
        ? updatedList.sublist(0, _maxNotifications)
        : updatedList;

    state = state.copyWith(notifications: trimmed);
    await _saveNotifications();
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
    await _saveNotifications();
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final updatedList = state.notifications.map((n) {
      return n.copyWith(isRead: true);
    }).toList();

    state = state.copyWith(notifications: updatedList);
    await _saveNotifications();
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    final updatedList = state.notifications
        .where((n) => n.id != notificationId)
        .toList();

    state = state.copyWith(notifications: updatedList);
    await _saveNotifications();
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    state = state.copyWith(notifications: []);
    await _prefs.remove(_notificationsKey);
  }
}
