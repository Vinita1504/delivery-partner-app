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
      weight: json['weight'] as String?,
      unit: json['unit'] as String?,
      price: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      productImage: json['productImage'] as String?,
      specialRequirements: json['specialRequirements'] as String?,
      bucketId: json['bucketId'] as String?,
      bucketItems: json['bucketItems'] as List<dynamic>?,
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'weight': instance.weight,
      'unit': instance.unit,
      'unitPrice': instance.price,
      'totalPrice': instance.totalPrice,
      'productImage': instance.productImage,
      'specialRequirements': instance.specialRequirements,
      'bucketId': instance.bucketId,
      'bucketItems': instance.bucketItems,
    };
