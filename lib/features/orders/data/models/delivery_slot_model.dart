import 'package:json_annotation/json_annotation.dart';

part 'delivery_slot_model.g.dart';

/// Delivery slot model matching API response
@JsonSerializable()
class DeliverySlotModel {
  final String id;
  final String? name;
  final String startTime;
  final String endTime;
  @JsonKey(name: 'date')
  final String slotDate;

  const DeliverySlotModel({
    required this.id,
    this.name,
    required this.startTime,
    required this.endTime,
    required this.slotDate,
  });

  factory DeliverySlotModel.fromJson(Map<String, dynamic> json) =>
      _$DeliverySlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverySlotModelToJson(this);

  /// Formatted time range for display (e.g., "14:00 - 16:00")
  String get formattedTimeRange => '$startTime - $endTime';

  /// Formatted date for display
  String get formattedDate {
    try {
      final date = DateTime.parse(slotDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return slotDate;
    }
  }

  /// Full slot display string
  String get displayString => '$formattedDate, $formattedTimeRange';

  DeliverySlotModel copyWith({
    String? id,
    String? startTime,
    String? endTime,
    String? slotDate,
  }) {
    return DeliverySlotModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slotDate: slotDate ?? this.slotDate,
    );
  }
}
