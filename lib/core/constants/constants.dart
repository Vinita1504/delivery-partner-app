/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Delivery Partner';
  static const String appVersion = '1.0.0';
  static const String baseUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int otpLength = 4;
  static const Duration otpResendCooldown = Duration(seconds: 60);
}

/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String changePassword = '/auth/change-password';
  static const String profile = '/profile';

  // Orders
  static const String orders = '/orders';
  static String orderDetails(String id) => '/orders/$id';
  static String updateOrderStatus(String id) => '/orders/$id/status';
  static String verifyOtp(String id) => '/orders/$id/verify-otp';
  static String resendOtp(String id) => '/orders/$id/resend-otp';

  // Issues
  static const String reportIssue = '/issues';
}

/// Asset paths
class AssetPaths {
  AssetPaths._();

  static const String imagesPath = 'assets/images';
  static const String logo = '$imagesPath/logo.png';
  static const String deliverySuccess = '$imagesPath/delivery_success.png';
}
