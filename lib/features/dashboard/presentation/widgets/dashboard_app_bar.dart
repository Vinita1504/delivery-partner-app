import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/extensions.dart';

/// Dashboard app bar widget
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback? onNotificationPressed;

  const DashboardAppBar({
    super.key,
    required this.onMenuPressed,
    this.onNotificationPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: onMenuPressed,
      ),
      title: Row(
        children: [
          Image.asset(
            'assets/images/app_logo.png',
            height: 32.h,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.local_shipping_rounded,
              size: 32.sp,
              color: context.colorScheme.primary,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'Dehat Fresh',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onNotificationPressed,
        ),
      ],
    );
  }
}
