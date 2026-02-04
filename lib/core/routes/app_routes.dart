import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:delivery_partner_app/features/auth/presentation/pages/login_page.dart';
import 'package:delivery_partner_app/features/auth/presentation/pages/profile_page.dart';
import 'package:delivery_partner_app/features/auth/presentation/pages/change_password_page.dart';
import 'package:delivery_partner_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:delivery_partner_app/features/orders/presentation/pages/assigned_orders_page.dart';
import 'package:delivery_partner_app/features/order_history/presentation/pages/order_history_page.dart';
import 'package:delivery_partner_app/features/orders/presentation/pages/order_details_page.dart';
import 'package:delivery_partner_app/features/orders/presentation/pages/otp_verification_page.dart';
import 'package:delivery_partner_app/features/orders/presentation/pages/cod_confirmation_page.dart';
import 'package:delivery_partner_app/features/orders/presentation/pages/delivery_success_page.dart';
import 'package:delivery_partner_app/features/help/presentation/pages/help_page.dart';

/// Route paths
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String assignedOrders = '/assigned-orders';
  static const String orderHistory = '/order-history';
  static const String orderDetails = '/order/:orderId';
  static const String otpVerification = '/order/:orderId/otp';
  static const String codConfirmation = '/order/:orderId/cod';
  static const String deliverySuccess = '/order/:orderId/success';
  static const String profile = '/profile';
  static const String changePassword = '/profile/change-password';
  static const String help = '/help';
}

/// GoRouter configuration
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  debugLogDiagnostics: true,
  routes: [
    // Login
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
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
            return OtpVerificationPage(orderId: orderId);
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
