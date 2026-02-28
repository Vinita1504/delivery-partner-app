/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String auth = '/auth';
  static const String loginDeliveryAgent = '$auth/login-delivery-agent';
  static const String logout = '/auth/logout';
  static const String changePassword = '/delivery-agent/change-password';
  static const String forgotPasswordSendOtp =
      '/auth/delivery-agent/forgot-password/send-otp';
  static const String forgotPasswordVerifyOtp =
      '/auth/delivery-agent/forgot-password/verify-otp';
  static const String forgotPasswordReset =
      '/auth/delivery-agent/forgot-password/reset';
  static const String profile = '/profile';
  static const String updateDeviceToken = '/delivery-agent/device-token';

  // Delivery Agent
  static const String deliveryAgent = '/delivery-agent';
  static const String dashboard = '$deliveryAgent/dashboard';
  static const String assignedOrders = '$deliveryAgent/orders';
  static const String orderHistory = '$deliveryAgent/orders/history';
  static String deliveryAgentOrderDetails(String id) =>
      '$deliveryAgent/orders/$id';
  static String markOrderPickedUp(String id) =>
      '$deliveryAgent/orders/$id/pickup';
  static String markOrderReturnPickedUp(String id) =>
      '$deliveryAgent/orders/$id/return-pickup';
  static String markOrderOutForDelivery(String id) =>
      '$deliveryAgent/orders/$id/out-for-delivery';
  static String sendOtp(String id) => '$deliveryAgent/orders/$id/send-otp';
  static String verifyOtpDelivery(String id) =>
      '$deliveryAgent/orders/$id/verify-otp';
  static String completeDelivery(String id) =>
      '$deliveryAgent/orders/$id/complete';
  static String markOrderReturned(String id) =>
      '$deliveryAgent/orders/$id/returned';

  // Issues
  static const String reportIssue = '/issues';
}
