import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';

/// Provider for LocalNotificationService
final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService();
});

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  
  bool _isInitialized = false;
   
  /// GoRouter reference for navigation on notification taps
  GoRouter? _router;
   
  /// Set the router reference for navigation
  void setRouter(GoRouter router) {
    _router = router;
  }

  /// Android notification channel for order updates
  static const AndroidNotificationChannel orderChannel =
      AndroidNotificationChannel(
        'order_updates', // id
        'Order Updates', // name
        description: 'Notifications for order status updates',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

  /// Android notification channel for general notifications
  static const AndroidNotificationChannel generalChannel =
      AndroidNotificationChannel(
        'general', // id
        'General Notifications', // name
        description: 'General app notifications',
        importance: Importance.defaultImportance,
        playSound: true,
      );

  /// Initialize the local notification plugin
  Future<void> initialize({
    void Function(NotificationResponse)? onNotificationTapped,
  }) async {
    if (_isInitialized) return;

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS / macOS initialization settings
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          onNotificationTapped ?? _onNotificationTapped,
    );

    // Create notification channels on Android
    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(orderChannel);
        await androidPlugin.createNotificationChannel(generalChannel);
      }
    }

    _isInitialized = true;
    debugPrint('LocalNotificationService initialized');
  }

  /// Handler for notification taps — navigates to order details or notifications page
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty && _router != null) {
      // payload contains the orderId — navigate to order details
      _router!.push('/order/$payload');
    } else if (_router != null) {
      // No specific order — open notifications page
      _router!.push(AppRoutes.notifications);
    }
  }

  /// Show a notification for order updates
  Future<void> showOrderNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      channelId: orderChannel.id,
      channelName: orderChannel.name,
      channelDescription: orderChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      payload: payload,
    );
  }

  /// Show a general notification
  Future<void> showGeneralNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      channelId: generalChannel.id,
      channelName: generalChannel.name,
      channelDescription: generalChannel.description,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      payload: payload,
    );
  }

  /// Internal method to show a notification
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    String? channelDescription,
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _plugin.show(id, title, body, details, payload: payload);
  }

  /// Cancel a specific notification
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
