import 'package:json_annotation/json_annotation.dart';

part 'order_item_model.g.dart';

/// Order item model matching API response
@JsonSerializable()
class OrderItemModel {
  final String id;
  final String? productId;
  final String productName;
  final int quantity;
  final String? weight;
  final String? unit;
  @JsonKey(name: 'unitPrice')
  final double price;
  final double totalPrice;
  final String? productImage;
  final String? specialRequirements;
  final String? bucketId;
  final List<dynamic>? bucketItems;

  const OrderItemModel({
    required this.id,
    this.productId,
    required this.productName,
    required this.quantity,
    this.weight,
    this.unit,
    required this.price,
    required this.totalPrice,
    this.productImage,
    this.specialRequirements,
    this.bucketId,
    this.bucketItems,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  /// Formatted quantity with unit (e.g., "1 kg" or "2")
  String get formattedQuantity {
    if (weight != null && weight!.isNotEmpty) {
      return unit != null && unit!.isNotEmpty ? '$weight $unit' : weight!;
    }
    return unit != null && unit!.isNotEmpty ? '$quantity $unit' : '$quantity';
  }

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
    String? weight,
    String? unit,
    double? price,
    double? totalPrice,
    String? productImage,
    String? specialRequirements,
    String? bucketId,
    List<dynamic>? bucketItems,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
      productImage: productImage ?? this.productImage,
      specialRequirements: specialRequirements ?? this.specialRequirements,
      bucketId: bucketId ?? this.bucketId,
      bucketItems: bucketItems ?? this.bucketItems,
    );
  }
}
