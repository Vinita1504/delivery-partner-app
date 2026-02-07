// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String,
  orderNumber: json['orderNumber'] as String,
  orderStatus: json['orderStatus'] as String,
  paymentStatus: json['paymentStatus'] as String,
  paymentMode: json['paymentMode'] as String? ?? 'cod',
  totalAmount: (json['totalAmount'] as num).toDouble(),
  customerName: json['customerName'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  assignedAt: json['assignedAt'] == null
      ? null
      : DateTime.parse(json['assignedAt'] as String),
  pickedUpAt: json['pickedUpAt'] == null
      ? null
      : DateTime.parse(json['pickedUpAt'] as String),
  outForDeliveryAt: json['outForDeliveryAt'] == null
      ? null
      : DateTime.parse(json['outForDeliveryAt'] as String),
  deliveredAt: json['deliveredAt'] == null
      ? null
      : DateTime.parse(json['deliveredAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  cancellationReason: json['cancellationReason'] as String?,
  deliveryAddress: json['deliveryAddress'] == null
      ? null
      : DeliveryAddressModel.fromJson(
          json['deliveryAddress'] as Map<String, dynamic>,
        ),
  deliverySlot: json['deliverySlot'] == null
      ? null
      : DeliverySlotModel.fromJson(
          json['deliverySlot'] as Map<String, dynamic>,
        ),
  orderItems:
      (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  statusHistory:
      (json['statusHistory'] as List<dynamic>?)
          ?.map(
            (e) => OrderStatusHistoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'orderStatus': instance.orderStatus,
      'paymentStatus': instance.paymentStatus,
      'paymentMode': instance.paymentMode,
      'totalAmount': instance.totalAmount,
      'customerName': instance.customerName,
      'createdAt': instance.createdAt.toIso8601String(),
      'assignedAt': instance.assignedAt?.toIso8601String(),
      'pickedUpAt': instance.pickedUpAt?.toIso8601String(),
      'outForDeliveryAt': instance.outForDeliveryAt?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'cancellationReason': instance.cancellationReason,
      'deliveryAddress': instance.deliveryAddress,
      'deliverySlot': instance.deliverySlot,
      'orderItems': instance.orderItems,
      'statusHistory': instance.statusHistory,
    };
