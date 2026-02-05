import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/routes/app_routes.dart';
import 'dashboard_action_card.dart';

/// Quick actions section widget
class DashboardQuickActions extends StatelessWidget {
  final int assignedCount;
  final Color primaryColor;
  final Color assignedColor;
  final Color secondaryColor;
  final Color historyColor;

  const DashboardQuickActions({
    super.key,
    required this.assignedCount,
    required this.primaryColor,
    required this.assignedColor,
    required this.secondaryColor,
    required this.historyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: DashboardActionCard(
                icon: Icons.local_shipping_rounded,
                label: 'Active Orders',
                subtitle: '$assignedCount pending',
                color: primaryColor,
                onTap: () => context.push(AppRoutes.assignedOrders),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DashboardActionCard(
                icon: Icons.history_rounded,
                label: 'Order History',
                subtitle: 'View all',
                color: historyColor,
                onTap: () => context.push(AppRoutes.orderHistory),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: DashboardActionCard(
                icon: Icons.person_rounded,
                label: 'Profile',
                subtitle: 'Account settings',
                color: assignedColor,
                onTap: () => context.push(AppRoutes.profile),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DashboardActionCard(
                icon: Icons.help_outline_rounded,
                label: 'Help',
                subtitle: 'Get support',
                color: secondaryColor,
                onTap: () => context.push(AppRoutes.help),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
