// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersResponseModel _$OrdersResponseModelFromJson(Map<String, dynamic> json) =>
    OrdersResponseModel(
      success: json['success'] as bool,
      data: OrdersDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrdersResponseModelToJson(
  OrdersResponseModel instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

OrdersDataModel _$OrdersDataModelFromJson(Map<String, dynamic> json) =>
    OrdersDataModel(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OrdersDataModelToJson(OrdersDataModel instance) =>
    <String, dynamic>{
      'orders': instance.orders,
      'pagination': instance.pagination,
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
    };
