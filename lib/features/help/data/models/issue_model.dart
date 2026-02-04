import '../../../../core/enums/enums.dart';

/// Issue model for help feature
class IssueModel {
  final String id;
  final String orderId;
  final IssueType type;
  final String? description;
  final DateTime createdAt;

  const IssueModel({
    required this.id,
    required this.orderId,
    required this.type,
    this.description,
    required this.createdAt,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      type: IssueType.fromString(json['type'] as String),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'type': type.value,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
