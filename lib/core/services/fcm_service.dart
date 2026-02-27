import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/notifications/data/models/app_notification.dart';
import '../../features/notifications/presentation/providers/notification_provider.dart';
import 'local_notification_service.dart';

/// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

/// Provider for FcmService
final fcmServiceProvider = Provider<FcmService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final localNotificationService = ref.watch(localNotificationServiceProvider);
  final notificationNotifier = ref.watch(notificationProvider.notifier);
  return FcmService(
    authRepository,
    localNotificationService,
    notificationNotifier,
  );
});

class FcmService {
  final AuthRepository _authRepository;
  final LocalNotificationService _localNotificationService;
  final NotificationNotifier _notificationNotifier;
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  FcmService(
    this._authRepository,
    this._localNotificationService,
    this._notificationNotifier,
  );

  Future<void> initialize() async {
    try {
      // Request permissions
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('User granted permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Setup message handlers
        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );

        // Handle foreground messages — show local notification & save to history
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Got a message whilst in the foreground!');
          debugPrint('Message data: ${message.data}');

          if (message.notification != null) {
            debugPrint(
              'Message also contained a notification: ${message.notification}',
            );
            // Show local notification
            _showLocalNotification(message);
            // Save to notification history
            _saveToHistory(message);
          }
        });

        // Handle notification taps when app is in background (not terminated)
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          debugPrint(
            'Notification opened app from background: ${message.data}',
          );
          _saveToHistory(message);
        });

        // Check if app was opened from terminated state via notification
        final initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          debugPrint(
            'App opened from terminated state via notification: ${initialMessage.data}',
          );
          _saveToHistory(initialMessage);
        }

        // Setup token refresh listener
        _messaging.onTokenRefresh.listen((newToken) {
          debugPrint('FCM Token Refreshed: $newToken');
          _syncTokenWithBackend(newToken);
        });

        // Get initial token
        final token = await _messaging.getToken();
        if (token != null) {
          debugPrint('FCM Token: $token');
          await _syncTokenWithBackend(token);
        }
      }
    } catch (e) {
      debugPrint('Error initializing FCM: $e');
    }
  }

  /// Show a local notification when a foreground FCM message is received
  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final title = notification.title ?? 'New Notification';
    final body = notification.body ?? '';
    final type = message.data['type'] ?? 'general';
    final orderId = message.data['orderId'];

    if (type == 'order_assigned' ||
        type == 'order_pickup' ||
        type == 'order_update') {
      _localNotificationService.showOrderNotification(
        title: title,
        body: body,
        payload: orderId ?? '',
      );
    } else {
      _localNotificationService.showGeneralNotification(
        title: title,
        body: body,
        payload: orderId ?? '',
      );
    }
  }

  /// Save notification to in-app history
  void _saveToHistory(RemoteMessage message) {
    final notification = message.notification;
    final title =
        notification?.title ?? message.data['title'] ?? 'Notification';
    final body = notification?.body ?? message.data['body'] ?? '';
    final typeStr = message.data['type'] ?? 'general';
    final orderId = message.data['orderId'] as String?;
    final orderNumber = message.data['orderNumber'] as String?;

    NotificationType type;
    switch (typeStr) {
      case 'order_assigned':
        type = NotificationType.orderAssigned;
        break;
      case 'order_pickup':
        type = NotificationType.orderPickup;
        break;
      case 'order_delivered':
        type = NotificationType.orderDelivered;
        break;
      case 'order_cancelled':
        type = NotificationType.orderCancelled;
        break;
      default:
        type = NotificationType.general;
    }

    _notificationNotifier.addNotification(
      title: title,
      body: body,
      type: type,
      orderId: orderId,
      orderNumber: orderNumber,
    );
  }

  Future<void> _syncTokenWithBackend(String token) async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        await _authRepository.updateDeviceToken(token);
        debugPrint('Successfully synced FCM token with backend');
      }
    } catch (e) {
      debugPrint('Error syncing FCM token with backend: $e');
    }
  }

  Future<void> syncToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _syncTokenWithBackend(token);
      }
    } catch (e) {
      debugPrint('Error manually syncing token: $e');
    }
  }
}
