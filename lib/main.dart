import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_provider.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/services/fcm_service.dart';
import 'core/services/local_notification_service.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (graceful — app works even without google-services.json)
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp();
    firebaseInitialized = true;
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('App will continue without Firebase services.');
  }

  // Enable Google Fonts runtime fetching to download fonts at runtime
  GoogleFonts.config.allowRuntimeFetching = true;

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Create a specific container to initialize providers before running the app
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(sharedPreferences)],
  );

  // Initialize local notifications (works without Firebase)
  await container.read(localNotificationServiceProvider).initialize();

  // Initialize auth status check
  // We don't await this so the UI shows up immediately (loading state handles this)
  container.read(authControllerProvider.notifier).checkAuthStatus();

  // Initialize FCM service only if Firebase is available
  if (firebaseInitialized) {
    container.read(fcmServiceProvider).initialize();
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DeliveryPartnerApp(),
    ),
  );
}

/// Global key for ScaffoldMessenger to persist snackbars across navigation
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Main application widget
class DeliveryPartnerApp extends ConsumerWidget {
  const DeliveryPartnerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    // Pass the router to LocalNotificationService for tap navigation
    ref.read(localNotificationServiceProvider).setRouter(router);

    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 14 dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        title: 'Delivery Partner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: router,
        scaffoldMessengerKey: scaffoldMessengerKey,
      ),
    );
  }
}
