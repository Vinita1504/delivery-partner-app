// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStatusHistoryModel _$OrderStatusHistoryModelFromJson(
  Map<String, dynamic> json,
) => OrderStatusHistoryModel(
  id: json['id'] as String,
  status: json['status'] as String,
  reason: json['reason'] as String?,
  changedBy: json['changedBy'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$OrderStatusHistoryModelToJson(
  OrderStatusHistoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'reason': instance.reason,
  'changedBy': instance.changedBy,
  'createdAt': instance.createdAt.toIso8601String(),
};
