import 'package:delivery_partner_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/extensions.dart';

/// Dashboard app bar widget
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;

  const DashboardAppBar({super.key, required this.onMenuPressed});

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
            'assets/images/app_logo_splash.png',
            height: 32.h,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.local_shipping_rounded,
              size: 32.sp,
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_2_outlined),
          onPressed: () {
            context.push(AppRoutes.profile);
          },
        ),
      ],
    );
  }
}
