import '../../../../core/enums/enums.dart';
import '../models/order_model.dart';

/// Order repository interface
abstract class OrderRepository {
  Future<List<OrderModel>> getAssignedOrders();
  Future<OrderModel> getOrderById(String orderId);
  Future<OrderModel> updateOrderStatus(String orderId, OrderStatus status);
  Future<bool> verifyOtp(String orderId, String otp);
  Future<bool> resendOtp(String orderId);
  Future<OrderModel> confirmCodCollection(String orderId);
}
