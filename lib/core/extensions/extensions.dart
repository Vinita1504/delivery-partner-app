import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom extensions on String
extension StringExtension on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get titleCase => split(' ').map((word) => word.capitalize).join(' ');
  bool get isValidEmail =>
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(this);
  bool get isValidOtp => RegExp(r'^[0-9]{4}$').hasMatch(this);
  String get maskedPhone =>
      length < 4 ? this : '${'*' * (length - 4)}${substring(length - 4)}';
}

/// Custom extensions on nullable String
extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  String orDefault(String defaultValue) => isNullOrEmpty ? defaultValue : this!;
}

/// Custom extensions on int
extension IntExtension on int {
  String get toCurrency => '₹$this';
  String get formatted => toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
  Duration get seconds => Duration(seconds: this);
  Duration get milliseconds => Duration(milliseconds: this);
  Duration get minutes => Duration(minutes: this);
}

/// Custom extensions on double
extension DoubleExtension on double {
  String get toCurrency => '₹${toStringAsFixed(2)}';
  String get formatted => toStringAsFixed(2);
}

/// Custom extensions on DateTime
extension DateTimeExtension on DateTime {
  String get toDateString =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

  String get toTimeString {
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final period = hour >= 12 ? 'PM' : 'AM';
    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String get toDateTimeString => '$toDateString at $toTimeString';
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);
    if (difference.inDays > 7) return toDateString;
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}

/// Custom extensions on BuildContext
extension ContextExtension on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : null,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  Future<T?> navigateTo<T>(Widget page) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));

  Future<T?> navigateAndReplace<T>(Widget page) => Navigator.of(
    this,
  ).pushReplacement<T, void>(MaterialPageRoute(builder: (_) => page));

  Future<T?> navigateAndClearStack<T>(Widget page) =>
      Navigator.of(this).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        (route) => false,
      );

  void pop<T>([T? result]) => Navigator.of(this).pop(result);
}

/// Custom extensions on Widget
extension WidgetExtension on Widget {
  Widget withPadding(EdgeInsetsGeometry padding) =>
      Padding(padding: padding, child: this);
  Widget withAllPadding(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);
  Widget centered() => Center(child: this);
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);
  Widget onTap(VoidCallback onTap) =>
      GestureDetector(onTap: onTap, child: this);
}

/// Custom extensions on List
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
  T? elementAtOrNull(int index) =>
      (index < 0 || index >= length) ? null : this[index];
}
