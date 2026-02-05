// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_agent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryAgentModel _$DeliveryAgentModelFromJson(Map<String, dynamic> json) =>
    DeliveryAgentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      vehicleNo: json['vehicleNo'] as String,
      vehicleType: json['vehicleType'] as String,
      vehicleName: json['vehicleName'] as String,
      license: json['license'] as String,
      aadhaar: json['aadhaar'] as String,
      pan: json['pan'] as String,
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DeliveryAgentModelToJson(DeliveryAgentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'vehicleNo': instance.vehicleNo,
      'vehicleType': instance.vehicleType,
      'vehicleName': instance.vehicleName,
      'license': instance.license,
      'aadhaar': instance.aadhaar,
      'pan': instance.pan,
      'address': instance.address,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
