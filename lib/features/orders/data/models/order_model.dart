import '../../../../core/enums/enums.dart';

/// Order model for orders feature
class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String areaName;
  final PaymentType paymentType;
  final double amount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.areaName,
    required this.paymentType,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  /// Check if order is COD
  bool get isCod => paymentType == PaymentType.cod;

  /// Check if order is prepaid
  bool get isPrepaid => paymentType == PaymentType.prepaid;

  /// Check if order can be picked up
  bool get canBePickedUp => status == OrderStatus.assigned;

  /// Check if order can start delivery
  bool get canStartDelivery => status == OrderStatus.pickedUp;

  /// Check if order can be completed
  bool get canBeCompleted => status == OrderStatus.outForDelivery;

  /// Check if order is delivered
  bool get isDelivered => status == OrderStatus.delivered;

  /// Get the next action text based on current status
  String get nextActionText {
    switch (status) {
      case OrderStatus.assigned:
        return 'Mark Picked Up';
      case OrderStatus.pickedUp:
        return 'Start Delivery';
      case OrderStatus.outForDelivery:
        return 'Complete Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      areaName: json['areaName'] as String,
      paymentType: PaymentType.fromString(json['paymentType'] as String),
      amount: (json['amount'] as num).toDouble(),
      status: OrderStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'areaName': areaName,
      'paymentType': paymentType.value,
      'amount': amount,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? deliveryAddress,
    String? areaName,
    PaymentType? paymentType,
    double? amount,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      areaName: areaName ?? this.areaName,
      paymentType: paymentType ?? this.paymentType,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
