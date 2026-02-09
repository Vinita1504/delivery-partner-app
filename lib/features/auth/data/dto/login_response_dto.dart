import 'package:json_annotation/json_annotation.dart';

import '../models/delivery_agent_model.dart';

part 'login_response_dto.g.dart';

/// Data Transfer Object for login API response
/// Parses the 'data' object from API response containing agent, token, and tenantId
@JsonSerializable()
class LoginResponseDTO {
  final String token;
  final String tenantId;
  final DeliveryAgentModel agent;

  const LoginResponseDTO({
    required this.token,
    required this.tenantId,
    required this.agent,
  });

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDTOToJson(this);
}
