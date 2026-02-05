import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/extensions.dart';

/// Individual stat card widget
class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const DashboardStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(color: color),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: context.textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stats section with overview title and stat cards
class DashboardStatsSection extends StatelessWidget {
  final int assignedCount;
  final int deliveredCount;
  final Color assignedColor;
  final Color deliveredColor;

  const DashboardStatsSection({
    super.key,
    required this.assignedCount,
    required this.deliveredCount,
    required this.assignedColor,
    required this.deliveredColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Overview",
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                icon: Icons.assignment_rounded,
                label: 'Assigned',
                value: '$assignedCount',
                color: assignedColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DashboardStatCard(
                icon: Icons.check_circle_rounded,
                label: 'Delivered',
                value: '$deliveredCount',
                color: deliveredColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
