import 'package:flutter/material.dart';
import '../../main.dart'; // To access scaffoldMessengerKey

abstract final class AppSnackbar {
  static void showError(BuildContext context, {required String message}) =>
      _show(context,
          message: message,
          icon: Icons.error_outline_rounded,
          backgroundColor: const Color(0xFFB3261E), // Material 3 Error
          foregroundColor: Colors.white);

  static void showSuccess(BuildContext context, {required String message}) =>
      _show(context,
          message: message,
          icon: Icons.check_circle_outline_rounded,
          backgroundColor: const Color(0xFF1B5E20), // Dark green
          foregroundColor: Colors.white);

  static void showInfo(BuildContext context, {required String message}) =>
      _show(context,
          message: message,
          icon: Icons.info_outline_rounded,
          backgroundColor: const Color(0xFF333333),
          foregroundColor: Colors.white);

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            Icon(icon, color: foregroundColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: TextStyle(color: foregroundColor, fontSize: 13)),
            ),
          ],
        ),
      ));
  }
}
