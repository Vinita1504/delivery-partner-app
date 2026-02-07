// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryAddressModel _$DeliveryAddressModelFromJson(
  Map<String, dynamic> json,
) => DeliveryAddressModel(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  addressLine1: json['addressLine1'] as String,
  addressLine2: json['addressLine2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String,
  pincode: json['pincode'] as String,
  landmark: json['landmark'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DeliveryAddressModelToJson(
  DeliveryAddressModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'addressLine1': instance.addressLine1,
  'addressLine2': instance.addressLine2,
  'city': instance.city,
  'state': instance.state,
  'pincode': instance.pincode,
  'landmark': instance.landmark,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
