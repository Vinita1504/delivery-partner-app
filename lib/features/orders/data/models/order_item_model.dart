import 'package:json_annotation/json_annotation.dart';

part 'order_item_model.g.dart';

/// Order item model matching API response
@JsonSerializable()
class OrderItemModel {
  final String id;
  final String? productId;
  final String productName;
  final int quantity;
  final String? unit;
  final double price;
  final double totalPrice;
  final String? productImage;
  final String? specialRequirements;

  const OrderItemModel({
    required this.id,
    this.productId,
    required this.productName,
    required this.quantity,
    this.unit,
    required this.price,
    required this.totalPrice,
    this.productImage,
    this.specialRequirements,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  /// Formatted quantity with unit (e.g., "2 kg" or "2")
  String get formattedQuantity =>
      unit != null && unit!.isNotEmpty ? '$quantity $unit' : '$quantity';

  /// Check if product has an image
  bool get hasImage => productImage != null && productImage!.isNotEmpty;

  /// Check if item has special requirements
  bool get hasSpecialRequirements =>
      specialRequirements != null && specialRequirements!.isNotEmpty;

  OrderItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    int? quantity,
    String? unit,
    double? price,
    double? totalPrice,
    String? productImage,
    String? specialRequirements,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
      productImage: productImage ?? this.productImage,
      specialRequirements: specialRequirements ?? this.specialRequirements,
    );
  }
}
