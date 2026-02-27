import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/app_notification.dart';
import '../providers/notification_provider.dart';

/// Notifications page — shows all in-app notification history
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final notifications = notificationState.notifications;

    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 22.sp),
              onSelected: (value) {
                if (value == 'read_all') {
                  ref.read(notificationProvider.notifier).markAllAsRead();
                } else if (value == 'clear_all') {
                  _showClearDialog(context, ref);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'read_all',
                  child: Row(
                    children: [
                      Icon(Icons.done_all, size: 20),
                      SizedBox(width: 8),
                      Text('Mark all as read'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_sweep,
                        size: 20,
                        color: AppColors.error,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Clear all',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(context)
          : _buildNotificationList(context, ref, notifications),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 48.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No notifications yet',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You\'ll see order updates and\nassignments here',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    WidgetRef ref,
    List<AppNotification> notifications,
  ) {
    // Group notifications by date
    final today = DateTime.now();
    final todayNotifications = <AppNotification>[];
    final yesterdayNotifications = <AppNotification>[];
    final olderNotifications = <AppNotification>[];

    for (final n in notifications) {
      if (n.createdAt.isToday) {
        todayNotifications.add(n);
      } else if (today.difference(n.createdAt).inDays == 1) {
        yesterdayNotifications.add(n);
      } else {
        olderNotifications.add(n);
      }
    }

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: [
        if (todayNotifications.isNotEmpty) ...[
          _buildSectionHeader(context, 'Today'),
          ...todayNotifications.map((n) => _NotificationTile(notification: n)),
        ],
        if (yesterdayNotifications.isNotEmpty) ...[
          _buildSectionHeader(context, 'Yesterday'),
          ...yesterdayNotifications.map(
            (n) => _NotificationTile(notification: n),
          ),
        ],
        if (olderNotifications.isNotEmpty) ...[
          _buildSectionHeader(context, 'Earlier'),
          ...olderNotifications.map((n) => _NotificationTile(notification: n)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      child: Text(
        title,
        style: context.textTheme.labelLarge?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to clear all notifications? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(notificationProvider.notifier).clearAll();
              Navigator.pop(ctx);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual notification tile widget
class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref
            .read(notificationProvider.notifier)
            .deleteNotification(notification.id);
      },
      child: InkWell(
        onTap: () => _handleTap(context, ref),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.transparent
                : AppColors.primarySurface.withValues(alpha: 0.5),
            border: Border(
              bottom: BorderSide(color: AppColors.grey200, width: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(_getIcon(), size: 20.sp, color: _getIconColor()),
              ),
              SizedBox(width: 12.w),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.body,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12.sp,
                          color: AppColors.grey400,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          notification.createdAt.timeAgo,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColors.grey400,
                          ),
                        ),
                        if (notification.orderNumber != null) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '#${notification.orderNumber}',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow for order-linked notifications
              if (notification.orderId != null)
                Padding(
                  padding: EdgeInsets.only(left: 4.w, top: 8.h),
                  child: Icon(
                    Icons.chevron_right,
                    size: 20.sp,
                    color: AppColors.grey400,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    // Mark as read
    ref.read(notificationProvider.notifier).markAsRead(notification.id);

    // Navigate to order details if linked to an order
    if (notification.orderId != null) {
      context.push('/order/${notification.orderId}');
    }
  }

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.orderAssigned:
        return Icons.assignment_rounded;
      case NotificationType.orderPickup:
        return Icons.local_shipping_rounded;
      case NotificationType.orderDelivered:
        return Icons.check_circle_rounded;
      case NotificationType.orderCancelled:
        return Icons.cancel_rounded;
      case NotificationType.general:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.orderAssigned:
        return AppColors.statusAssigned;
      case NotificationType.orderPickup:
        return AppColors.statusPickedUp;
      case NotificationType.orderDelivered:
        return AppColors.statusDelivered;
      case NotificationType.orderCancelled:
        return AppColors.error;
      case NotificationType.general:
        return AppColors.info;
    }
  }

  Color _getIconBackgroundColor() {
    switch (notification.type) {
      case NotificationType.orderAssigned:
        return AppColors.statusAssigned.withValues(alpha: 0.1);
      case NotificationType.orderPickup:
        return AppColors.statusPickedUp.withValues(alpha: 0.1);
      case NotificationType.orderDelivered:
        return AppColors.statusDelivered.withValues(alpha: 0.1);
      case NotificationType.orderCancelled:
        return AppColors.error.withValues(alpha: 0.1);
      case NotificationType.general:
        return AppColors.info.withValues(alpha: 0.1);
    }
  }
}
