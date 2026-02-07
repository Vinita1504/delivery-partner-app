import 'package:json_annotation/json_annotation.dart';

import '../../../../core/enums/enums.dart';
import 'delivery_address_model.dart';
import 'delivery_slot_model.dart';
import 'order_item_model.dart';
import 'order_status_history_model.dart';

part 'order_model.g.dart';

/// Order model matching API response
@JsonSerializable()
class OrderModel {
  final String id;
  final String orderNumber;
  final String orderStatus;
  final String paymentStatus;
  @JsonKey(defaultValue: 'cod')
  final String paymentMode;
  final double totalAmount;
  final String? customerName;
  final DateTime createdAt;
  final DateTime? assignedAt;
  final DateTime? pickedUpAt;
  final DateTime? outForDeliveryAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DeliveryAddressModel? deliveryAddress;
  final DeliverySlotModel? deliverySlot;
  @JsonKey(defaultValue: [])
  final List<OrderItemModel> orderItems;
  @JsonKey(defaultValue: [])
  final List<OrderStatusHistoryModel> statusHistory;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMode,
    required this.totalAmount,
    this.customerName,
    required this.createdAt,
    this.assignedAt,
    this.pickedUpAt,
    this.outForDeliveryAt,
    this.deliveredAt,
    this.cancelledAt,
    this.cancellationReason,
    this.deliveryAddress,
    this.deliverySlot,
    this.orderItems = const [],
    this.statusHistory = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  /// Get parsed order status enum
  OrderStatus get status => OrderStatus.fromString(orderStatus);

  /// Get parsed payment status enum
  PaymentStatus get paymentStatusEnum =>
      PaymentStatus.fromString(paymentStatus);

  /// Get parsed payment method enum
  PaymentMethod get paymentMethodEnum => PaymentMethod.fromString(paymentMode);

  /// Check if order is COD
  bool get isCod => paymentMethodEnum.isCod;

  /// Check if order is prepaid
  bool get isPrepaid => paymentMethodEnum.isPrepaid;

  /// Check if order can be picked up
  bool get canBePickedUp => status.canPickUp;

  /// Check if order can start delivery
  bool get canStartDelivery => status.canStartDelivery;

  /// Check if order can be completed
  bool get canBeCompleted => status.canComplete;

  /// Check if order is delivered
  bool get isDelivered => status == OrderStatus.delivered;

  /// Check if order is in terminal state
  bool get isTerminal => status.isTerminal;

  /// Check if OTP is required for delivery completion
  bool get requiresOtp => isPrepaid && status == OrderStatus.outForDelivery;

  /// Check if cash collection is required
  bool get requiresCashCollection =>
      isCod && paymentStatusEnum == PaymentStatus.pending;

  /// Get the next action text based on current status
  String get nextActionText {
    switch (status) {
      case OrderStatus.assigned:
        return 'Mark Picked Up';
      case OrderStatus.pickedUp:
        return 'Start Delivery';
      case OrderStatus.outForDelivery:
        return isCod ? 'Collect & Complete' : 'Verify OTP & Complete';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
      default:
        return 'Pending';
    }
  }

  /// Get display name for customer
  String get customerDisplayName =>
      customerName ?? deliveryAddress?.name ?? 'Customer';

  /// Get display phone
  String get customerPhone => deliveryAddress?.phone ?? '';

  /// Get formatted total amount
  String get formattedAmount => '₹${totalAmount.toStringAsFixed(2)}';

  /// Get total items count
  int get totalItemsCount =>
      orderItems.fold(0, (sum, item) => sum + item.quantity);

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? orderStatus,
    String? paymentStatus,
    String? paymentMode,
    double? totalAmount,
    String? customerName,
    DateTime? createdAt,
    DateTime? assignedAt,
    DateTime? pickedUpAt,
    DateTime? outForDeliveryAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    DeliveryAddressModel? deliveryAddress,
    DeliverySlotModel? deliverySlot,
    List<OrderItemModel>? orderItems,
    List<OrderStatusHistoryModel>? statusHistory,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMode: paymentMode ?? this.paymentMode,
      totalAmount: totalAmount ?? this.totalAmount,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      assignedAt: assignedAt ?? this.assignedAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      outForDeliveryAt: outForDeliveryAt ?? this.outForDeliveryAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliverySlot: deliverySlot ?? this.deliverySlot,
      orderItems: orderItems ?? this.orderItems,
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }
}
