import 'package:json_annotation/json_annotation.dart';

import 'order_model.dart';

part 'orders_response_model.g.dart';

/// Paginated orders response model matching API
@JsonSerializable()
class OrdersResponseModel {
  final bool success;
  final OrdersDataModel data;

  const OrdersResponseModel({required this.success, required this.data});

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersResponseModelToJson(this);
}

/// Orders data with pagination
@JsonSerializable()
class OrdersDataModel {
  final List<OrderModel> orders;
  final PaginationModel pagination;

  const OrdersDataModel({required this.orders, required this.pagination});

  factory OrdersDataModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersDataModelToJson(this);
}

/// Pagination model for list responses
@JsonSerializable()
class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  /// Check if there are more pages to load
  bool get hasMorePages => page < totalPages;

  /// Check if this is the first page
  bool get isFirstPage => page == 1;

  /// Check if this is the last page
  bool get isLastPage => page >= totalPages;

  PaginationModel copyWith({
    int? total,
    int? page,
    int? limit,
    int? totalPages,
  }) {
    return PaginationModel(
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
