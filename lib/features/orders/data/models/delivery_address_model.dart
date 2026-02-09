import 'package:json_annotation/json_annotation.dart';

part 'delivery_address_model.g.dart';

/// Delivery address model matching API response
@JsonSerializable()
class DeliveryAddressModel {
  final String id;
  @JsonKey(name: 'fullName')
  final String name;
  @JsonKey(name: 'phoneNumber')
  final String phone;
  @JsonKey(name: 'address')
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final double? latitude;
  final double? longitude;

  const DeliveryAddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.latitude,
    this.longitude,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryAddressModelToJson(this);

  /// Full formatted address for display
  String get fullAddress {
    final parts = <String>[
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2!,
      if (landmark != null && landmark!.isNotEmpty) 'Near $landmark',
      '$city, $state - $pincode',
    ];
    return parts.join(', ');
  }

  /// Check if map navigation is available
  bool get hasCoordinates => latitude != null && longitude != null;

  /// Google Maps URL for navigation
  String get mapsUrl => hasCoordinates
      ? 'https://maps.google.com/?q=$latitude,$longitude'
      : 'https://maps.google.com/?q=${Uri.encodeComponent(fullAddress)}';

  DeliveryAddressModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? landmark,
    double? latitude,
    double? longitude,
  }) {
    return DeliveryAddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      landmark: landmark ?? this.landmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
