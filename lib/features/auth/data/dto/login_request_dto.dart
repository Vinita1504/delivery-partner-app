import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

/// Data Transfer Object for login request
@JsonSerializable()
class LoginRequestDTO {
  final String email;
  final String password;

  const LoginRequestDTO({required this.email, required this.password});

  factory LoginRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestDTOToJson(this);
}
