import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_model.g.dart';

/// Dashboard statistics model matching API response
@JsonSerializable()
class DashboardStatsModel {
  @JsonKey(defaultValue: 0)
  final int assignedCount;
  @JsonKey(defaultValue: 0)
  final int deliveredToday;
  @JsonKey(defaultValue: 0)
  final int totalDelivered;

  const DashboardStatsModel({
    this.assignedCount = 0,
    this.deliveredToday = 0,
    this.totalDelivered = 0,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);

  /// Check if there are pending assignments
  bool get hasPendingOrders => assignedCount > 0;

  /// Check if any deliveries were made today
  bool get hasDeliveriesToday => deliveredToday > 0;

  /// Empty stats for initial/error state
  static const DashboardStatsModel empty = DashboardStatsModel();

  DashboardStatsModel copyWith({
    int? assignedCount,
    int? deliveredToday,
    int? totalDelivered,
  }) {
    return DashboardStatsModel(
      assignedCount: assignedCount ?? this.assignedCount,
      deliveredToday: deliveredToday ?? this.deliveredToday,
      totalDelivered: totalDelivered ?? this.totalDelivered,
    );
  }
}
