// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryAddressModel _$DeliveryAddressModelFromJson(
  Map<String, dynamic> json,
) => DeliveryAddressModel(
  id: json['id'] as String,
  name: json['fullName'] as String,
  phone: json['phoneNumber'] as String,
  addressLine1: json['address'] as String,
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
  'fullName': instance.name,
  'phoneNumber': instance.phone,
  'address': instance.addressLine1,
  'addressLine2': instance.addressLine2,
  'city': instance.city,
  'state': instance.state,
  'pincode': instance.pincode,
  'landmark': instance.landmark,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
