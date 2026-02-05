import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/routes/app_routes.dart';

/// Recent activity section widget
class DashboardRecentActivity extends StatelessWidget {
  const DashboardRecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Deliveries',
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.orderHistory),
              child: const Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        _EmptyActivityPlaceholder(),
      ],
    );
  }
}

/// Empty state placeholder for recent activity
class _EmptyActivityPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 48.sp,
              color: context.colorScheme.outline,
            ),
            SizedBox(height: 12.h),
            Text(
              'No recent deliveries',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Start delivering to see your history',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
