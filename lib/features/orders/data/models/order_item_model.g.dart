// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String?,
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unit: json['unit'] as String?,
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      productImage: json['productImage'] as String?,
      specialRequirements: json['specialRequirements'] as String?,
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
      'productImage': instance.productImage,
      'specialRequirements': instance.specialRequirements,
    };
