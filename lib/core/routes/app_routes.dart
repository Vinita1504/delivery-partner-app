import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/verify_otp_forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/help/presentation/pages/help_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/order_history/presentation/pages/order_history_page.dart';
import '../../features/orders/presentation/pages/assigned_orders_page.dart';
import '../../features/orders/presentation/pages/cod_confirmation_page.dart';
import '../../features/orders/presentation/pages/delivery_success_page.dart';
import '../../features/orders/presentation/pages/order_details_page.dart';
import '../../features/orders/presentation/pages/otp_verification_page.dart';

/// Route paths
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtpForgotPassword = '/forgot-password/verify';
  static const String resetPassword = '/forgot-password/reset';
  static const String dashboard = '/dashboard';
  static const String assignedOrders = '/assigned-orders';
  static const String orderHistory = '/order-history';
  static const String orderDetails = '/order/:orderId';
  static const String otpVerification = '/order/:orderId/otp';
  static const String codConfirmation = '/order/:orderId/cod';
  static const String deliverySuccess = '/order/:orderId/success';
  static const String profile = '/profile';
  static const String changePassword = '/profile/change-password';
  static const String notifications = '/notifications';
  static const String help = '/help';
}

/// Provider for the GoRouter configuration
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final currentPath = state.uri.toString();
      final isLoggingIn = currentPath == AppRoutes.login;
      final isAuthFlow =
          isLoggingIn || currentPath.startsWith('/forgot-password');

      // If user is not logged in and not on an auth flow page, redirect to login
      if (!isLoggedIn && !isAuthFlow) {
        return AppRoutes.login;
      }

      // If user is logged in and on login page, redirect to dashboardwh
      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.dashboard;
      }

      // No redirect required
      return null;
    },
    routes: [
      // Login
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Forgot Password Flow
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.verifyOtpForgotPassword,
        name: 'verifyOtpForgotPassword',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final phone = extra?['phone'] as String? ?? '';
          return VerifyOtpForgotPasswordPage(phone: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final phone = extra?['phone'] as String? ?? '';
          final otp = extra?['otp'] as String? ?? '';
          return ResetPasswordPage(phone: phone, otp: otp);
        },
      ),

      // Dashboard (Home)
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),

      // Assigned Orders
      GoRoute(
        path: AppRoutes.assignedOrders,
        name: 'assignedOrders',
        builder: (context, state) => const AssignedOrdersPage(),
      ),

      // Order History
      GoRoute(
        path: AppRoutes.orderHistory,
        name: 'orderHistory',
        builder: (context, state) => const OrderHistoryPage(),
      ),

      // Notifications
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),

      // Order Details
      GoRoute(
        path: '/order/:orderId',
        name: 'orderDetails',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return OrderDetailsPage(orderId: orderId);
        },
        routes: [
          // OTP Verification (nested under order)
          GoRoute(
            path: 'otp',
            name: 'otpVerification',
            builder: (context, state) {
              final orderId = state.pathParameters['orderId']!;
              final extra = state.extra as Map<String, dynamic>?;
              final devOtp = extra?['devOtp'] as String?;
              return OtpVerificationPage(orderId: orderId, devOtp: devOtp);
            },
          ),
          // COD Confirmation (nested under order)
          GoRoute(
            path: 'cod',
            name: 'codConfirmation',
            builder: (context, state) {
              final orderId = state.pathParameters['orderId']!;
              final extra = state.extra as Map<String, dynamic>?;
              final amount = extra?['amount'] as double? ?? 0.0;
              return CodConfirmationPage(orderId: orderId, amount: amount);
            },
          ),
          // Delivery Success (nested under order)
          GoRoute(
            path: 'success',
            name: 'deliverySuccess',
            builder: (context, state) {
              final orderId = state.pathParameters['orderId']!;
              return DeliverySuccessPage(orderId: orderId);
            },
          ),
        ],
      ),

      // Profile
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
        routes: [
          GoRoute(
            path: 'change-password',
            name: 'changePassword',
            builder: (context, state) => const ChangePasswordPage(),
          ),
        ],
      ),

      // Help
      GoRoute(
        path: AppRoutes.help,
        name: 'help',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final orderId = extra?['orderId'] as String?;
          return HelpPage(orderId: orderId);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
});
