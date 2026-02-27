// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    DashboardStatsModel(
      assignedCount: (json['assignedCount'] as num?)?.toInt() ?? 0,
      deliveredToday: (json['deliveredToday'] as num?)?.toInt() ?? 0,
      totalDelivered: (json['totalDelivered'] as num?)?.toInt() ?? 0,
      returnPickupCount: (json['returnPickupCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
  DashboardStatsModel instance,
) => <String, dynamic>{
  'assignedCount': instance.assignedCount,
  'deliveredToday': instance.deliveredToday,
  'totalDelivered': instance.totalDelivered,
  'returnPickupCount': instance.returnPickupCount,
};
