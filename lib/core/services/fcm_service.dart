import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

/// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized
  await Firebase.initializeApp();
  debugPrint("Handling a background message: \${message.messageId}");
}

/// Provider for FcmService
final fcmServiceProvider = Provider<FcmService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return FcmService(authRepository);
});

class FcmService {
  final AuthRepository _authRepository;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FcmService(this._authRepository);

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

      debugPrint('User granted permission: \${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Setup message handlers
        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Got a message whilst in the foreground!');
          debugPrint('Message data: \${message.data}');

          if (message.notification != null) {
            debugPrint(
              'Message also contained a notification: \${message.notification}',
            );
            // TODO: show local notification if required
          }
        });

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
