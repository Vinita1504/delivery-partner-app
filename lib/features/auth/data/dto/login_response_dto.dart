import 'package:json_annotation/json_annotation.dart';

import '../models/delivery_agent_model.dart';

part 'login_response_dto.g.dart';

/// Data Transfer Object for login API response
@JsonSerializable()
class LoginResponseDTO {
  final bool success;
  final String message;
  final String token;
  final DeliveryAgentModel agent;

  const LoginResponseDTO({
    required this.success,
    required this.message,
    required this.token,
    required this.agent,
  });

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDTOToJson(this);
}
