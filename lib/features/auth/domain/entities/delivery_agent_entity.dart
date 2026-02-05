import 'address_entity.dart';

/// Delivery Agent entity in the domain layer
/// This is a pure domain object without any framework dependencies
class DeliveryAgentEntity {
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
  final AddressEntity address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeliveryAgentEntity({
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
}
