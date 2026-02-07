// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliverySlotModel _$DeliverySlotModelFromJson(Map<String, dynamic> json) =>
    DeliverySlotModel(
      id: json['id'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      slotDate: json['slotDate'] as String,
    );

Map<String, dynamic> _$DeliverySlotModelToJson(DeliverySlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'slotDate': instance.slotDate,
    };
