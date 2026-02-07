import 'package:json_annotation/json_annotation.dart';

part 'order_status_history_model.g.dart';

/// Order status history model matching API response
@JsonSerializable()
class OrderStatusHistoryModel {
  final String id;
  final String status;
  final String? reason;
  final String? changedBy;
  final DateTime createdAt;

  const OrderStatusHistoryModel({
    required this.id,
    required this.status,
    this.reason,
    this.changedBy,
    required this.createdAt,
  });

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusHistoryModelToJson(this);

  /// Formatted time for display
  String get formattedTime {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Formatted date for display
  String get formattedDate {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;
    return '$day/$month/$year';
  }

  /// Full formatted datetime
  String get formattedDateTime => '$formattedDate at $formattedTime';

  OrderStatusHistoryModel copyWith({
    String? id,
    String? status,
    String? reason,
    String? changedBy,
    DateTime? createdAt,
  }) {
    return OrderStatusHistoryModel(
      id: id ?? this.id,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      changedBy: changedBy ?? this.changedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
