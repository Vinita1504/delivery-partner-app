import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/local_notification_service.dart';

/// Debug screen to fire local test notifications for each order status.
/// Accessible from the Dashboard via a "Test Notifications" button.
class NotificationTestPage extends ConsumerWidget {
  const NotificationTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifService = ref.read(localNotificationServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔔 Test Notifications'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _InfoBanner(),
          SizedBox(height: 20.h),
          _SectionHeader(title: 'Delivery Partner Scenarios'),
          SizedBox(height: 12.h),
          _NotifCard(
            icon: Icons.assignment_ind_rounded,
            color: const Color(0xFF4CAF50),
            title: 'Order Assigned',
            body: 'Order #ABC12345 has been assigned to you.',
            onTap: () => notifService.showOrderNotification(
              title: '🆕 New Order Assigned',
              body: 'Order #ABC12345 has been assigned to you. Please pick it up.',
              payload: 'test-order-id-001',
            ),
          ),
          SizedBox(height: 12.h),
          _NotifCard(
            icon: Icons.local_shipping_rounded,
            color: const Color(0xFF2196F3),
            title: 'Order Pickup Ready',
            body: 'Your order #ABC12345 is ready for pickup.',
            onTap: () => notifService.showOrderNotification(
              title: '📦 Ready for Pickup',
              body: 'Order #ABC12345 is packed and waiting at the warehouse.',
              payload: 'test-order-id-002',
            ),
          ),
          SizedBox(height: 12.h),
          _NotifCard(
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF4CAF50),
            title: 'Order Delivered',
            body: 'Order #DEF67890 marked as delivered.',
            onTap: () => notifService.showOrderNotification(
              title: '✅ Order Delivered',
              body: 'Great job! Order #DEF67890 was successfully delivered.',
              payload: 'test-order-id-003',
            ),
          ),
          SizedBox(height: 12.h),
          _NotifCard(
            icon: Icons.replay_rounded,
            color: const Color(0xFFFF9800),
            title: 'Return Pickup Assigned',
            body: 'Return pickup for order #GHI11111 assigned to you.',
            onTap: () => notifService.showOrderNotification(
              title: '🔄 Return Pickup Assigned',
              body: 'Return pickup for order #GHI11111 has been assigned to you.',
              payload: 'test-order-id-004',
            ),
          ),
          SizedBox(height: 12.h),
          _NotifCard(
            icon: Icons.cancel_rounded,
            color: const Color(0xFFF44336),
            title: 'Order Cancelled',
            body: 'Order #JKL22222 has been cancelled.',
            onTap: () => notifService.showGeneralNotification(
              title: '❌ Order Cancelled',
              body: 'Order #JKL22222 has been cancelled by the customer.',
              payload: 'test-order-id-005',
            ),
          ),
          SizedBox(height: 12.h),
          _NotifCard(
            icon: Icons.info_rounded,
            color: const Color(0xFF607D8B),
            title: 'General Notification',
            body: 'This is a general app notification.',
            onTap: () => notifService.showGeneralNotification(
              title: '📢 App Announcement',
              body: 'A new feature is available. Check it out!',
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFF9800), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.bug_report_rounded, color: Color(0xFFE65100)),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'DEV ONLY — Tap any button to fire a local notification. '
              'No network call is made.',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFFE65100)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Colors.grey.shade500,
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22.w),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.send_rounded, color: color, size: 18.w),
            ],
          ),
        ),
      ),
    );
  }
}
