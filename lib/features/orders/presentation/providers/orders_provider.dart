import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/enums.dart';
import '../../data/models/order_model.dart';

/// Orders state for managing orders list
class OrdersState {
  final bool isLoading;
  final List<OrderModel> orders;
  final String? errorMessage;

  const OrdersState({
    this.isLoading = false,
    this.orders = const [],
    this.errorMessage,
  });

  OrdersState copyWith({
    bool? isLoading,
    List<OrderModel>? orders,
    String? errorMessage,
  }) {
    return OrdersState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
    );
  }
}

/// Orders notifier for handling orders logic
class OrdersNotifier extends StateNotifier<OrdersState> {
  OrdersNotifier() : super(const OrdersState());

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data with COD and Online Payment orders
      final orders = [
        OrderModel(
          id: 'ORD001',
          customerId: 'C001',
          customerName: 'Rahul Sharma',
          customerPhone: '9876543210',
          deliveryAddress: '123, Main Street, Sector 5',
          areaName: 'Green Valley',
          paymentType: PaymentType.cod,
          amount: 450,
          status: OrderStatus.assigned,
          createdAt: DateTime.now(),
        ),
        OrderModel(
          id: 'ORD002',
          customerId: 'C002',
          customerName: 'Priya Singh',
          customerPhone: '9876543211',
          deliveryAddress: '456, Park Road, Block A',
          areaName: 'Sunshine Colony',
          paymentType: PaymentType.prepaid,
          amount: 780,
          status: OrderStatus.pickedUp,
          createdAt: DateTime.now(),
        ),
        OrderModel(
          id: 'ORD003',
          customerId: 'C003',
          customerName: 'Amit Kumar',
          customerPhone: '9876543212',
          deliveryAddress: '789, Lake View, Tower 2',
          areaName: 'Blue Hills',
          paymentType: PaymentType.cod,
          amount: 320,
          status: OrderStatus.outForDelivery,
          createdAt: DateTime.now(),
        ),
        OrderModel(
          id: 'ORD004',
          customerId: 'C004',
          customerName: 'Neha Gupta',
          customerPhone: '9876543213',
          deliveryAddress: '234, MG Road, Near Bus Stand',
          areaName: 'Central Market',
          paymentType: PaymentType.prepaid,
          amount: 1250,
          status: OrderStatus.assigned,
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        OrderModel(
          id: 'ORD005',
          customerId: 'C005',
          customerName: 'Vikram Patel',
          customerPhone: '9876543214',
          deliveryAddress: '567, Gandhi Nagar, House 12',
          areaName: 'Old City',
          paymentType: PaymentType.prepaid,
          amount: 890,
          status: OrderStatus.outForDelivery,
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        OrderModel(
          id: 'ORD006',
          customerId: 'C006',
          customerName: 'Sanjay Verma',
          customerPhone: '9876543215',
          deliveryAddress: '890, Nehru Colony, Flat 4B',
          areaName: 'East Zone',
          paymentType: PaymentType.cod,
          amount: 560,
          status: OrderStatus.assigned,
          createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
        OrderModel(
          id: 'ORD007',
          customerId: 'C007',
          customerName: 'Anita Desai',
          customerPhone: '9876543216',
          deliveryAddress: '111, Patel Street, Shop 3',
          areaName: 'Industrial Area',
          paymentType: PaymentType.prepaid,
          amount: 2100,
          status: OrderStatus.pickedUp,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ];

      state = state.copyWith(isLoading: false, orders: orders);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }

  OrderModel? getOrderById(String id) {
    try {
      return state.orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(status: status);
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Orders provider
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((
  ref,
) {
  return OrdersNotifier();
});

/// Single order provider for order details
final orderByIdProvider = Provider.family<OrderModel?, String>((ref, orderId) {
  final ordersState = ref.watch(ordersProvider);
  try {
    return ordersState.orders.firstWhere((order) => order.id == orderId);
  } catch (_) {
    return null;
  }
});
