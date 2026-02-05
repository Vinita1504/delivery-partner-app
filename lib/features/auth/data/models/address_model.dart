import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/address_entity.dart';

part 'address_model.g.dart';

/// Address model for delivery agent profile
@JsonSerializable()
class AddressModel {
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;

  const AddressModel({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  /// Convert to domain entity
  AddressEntity toEntity() {
    return AddressEntity(
      street: street,
      city: city,
      state: state,
      zip: zip,
      country: country,
    );
  }

  AddressModel copyWith({
    String? street,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    return AddressModel(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
    );
  }
}
