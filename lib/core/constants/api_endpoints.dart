/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String auth = '/auth';
  static const String loginDeliveryAgent = '$auth/login-delivery-agent';
  static const String logout = '/auth/logout';
  static const String changePassword = '/auth/change-password';
  static const String profile = '/profile';

  // Delivery Agent
  static const String deliveryAgent = '/delivery-agent';
  static const String dashboard = '$deliveryAgent/dashboard';
  static const String assignedOrders = '$deliveryAgent/orders';
  static const String orderHistory = '$deliveryAgent/orders/history';
  static String deliveryAgentOrderDetails(String id) =>
      '$deliveryAgent/orders/$id';
  static String markOrderPickedUp(String id) =>
      '$deliveryAgent/orders/$id/pickup';
  static String markOrderOutForDelivery(String id) =>
      '$deliveryAgent/orders/$id/out-for-delivery';
  static String completeDelivery(String id) =>
      '$deliveryAgent/orders/$id/complete';

  // Orders (legacy - for other modules)
  static const String orders = '/orders';
  static String orderDetails(String id) => '/orders/$id';
  static String updateOrderStatus(String id) => '/orders/$id/status';
  static String verifyOtp(String id) => '/orders/$id/verify-otp';
  static String resendOtp(String id) => '/orders/$id/resend-otp';

  // Issues
  static const String reportIssue = '/issues';
}
