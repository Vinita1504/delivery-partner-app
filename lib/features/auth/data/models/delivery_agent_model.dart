import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/delivery_agent_entity.dart';
import 'address_model.dart';

part 'delivery_agent_model.g.dart';

/// Delivery agent model matching API response
@JsonSerializable()
class DeliveryAgentModel {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String vehicleNo;
  final String vehicleType;
  final String vehicleName;
  final String license;
  final String aadhaar;
  final String pan;
  final AddressModel address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeliveryAgentModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.vehicleNo,
    required this.vehicleType,
    required this.vehicleName,
    required this.license,
    required this.aadhaar,
    required this.pan,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryAgentModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAgentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryAgentModelToJson(this);

  /// Convert to domain entity
  DeliveryAgentEntity toEntity() {
    return DeliveryAgentEntity(
      id: id,
      userId: userId,
      name: name,
      phone: phone,
      email: email,
      vehicleNo: vehicleNo,
      vehicleType: vehicleType,
      vehicleName: vehicleName,
      license: license,
      aadhaar: aadhaar,
      pan: pan,
      address: address.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  DeliveryAgentModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? vehicleNo,
    String? vehicleType,
    String? vehicleName,
    String? license,
    String? aadhaar,
    String? pan,
    AddressModel? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryAgentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleName: vehicleName ?? this.vehicleName,
      license: license ?? this.license,
      aadhaar: aadhaar ?? this.aadhaar,
      pan: pan ?? this.pan,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
