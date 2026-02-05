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

/// Asset paths
class AssetPaths {
  AssetPaths._();

  static const String imagesPath = 'assets/images';
  static const String logo = '$imagesPath/logo.png';
  static const String deliverySuccess = '$imagesPath/delivery_success.png';
}
