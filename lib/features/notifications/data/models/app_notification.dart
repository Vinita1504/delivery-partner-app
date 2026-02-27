import 'dart:convert';

/// Types of notifications in the app
enum NotificationType {
  orderAssigned,
  orderPickup,
  orderDelivered,
  orderCancelled,
  general,
}

/// Notification model for in-app notification history
class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final String? orderId;
  final String? orderNumber;
  final DateTime createdAt;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.orderId,
    this.orderNumber,
    required this.createdAt,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    String? orderId,
    String? orderNumber,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type.name,
    'orderId': orderId,
    'orderNumber': orderNumber,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      orderId: json['orderId'] as String?,
      orderNumber: json['orderNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  /// Serialize a list of notifications to JSON string
  static String encodeList(List<AppNotification> notifications) {
    return jsonEncode(notifications.map((n) => n.toJson()).toList());
  }

  /// Deserialize a list of notifications from JSON string
  static List<AppNotification> decodeList(String jsonString) {
    final list = jsonDecode(jsonString) as List;
    return list
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get icon data based on notification type
  String get iconName {
    switch (type) {
      case NotificationType.orderAssigned:
        return 'assignment';
      case NotificationType.orderPickup:
        return 'local_shipping';
      case NotificationType.orderDelivered:
        return 'check_circle';
      case NotificationType.orderCancelled:
        return 'cancel';
      case NotificationType.general:
        return 'notifications';
    }
  }
}
