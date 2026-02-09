// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseDTO _$LoginResponseDTOFromJson(Map<String, dynamic> json) =>
    LoginResponseDTO(
      token: json['token'] as String,
      tenantId: json['tenantId'] as String,
      agent: DeliveryAgentModel.fromJson(json['agent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseDTOToJson(LoginResponseDTO instance) =>
    <String, dynamic>{
      'token': instance.token,
      'tenantId': instance.tenantId,
      'agent': instance.agent,
    };
