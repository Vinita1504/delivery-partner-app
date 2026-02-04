import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Order status badge with color and optional pulse animation
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final IconData? icon;
  final bool animate;
  final bool small;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
    this.icon,
    this.animate = false,
    this.small = false,
  });

  // Factory constructors for order statuses
  factory StatusBadge.assigned() => const StatusBadge(
    label: 'Assigned',
    color: AppColors.statusAssigned,
    icon: Icons.assignment_turned_in_rounded,
  );

  factory StatusBadge.pickedUp() => const StatusBadge(
    label: 'Picked Up',
    color: AppColors.statusPickedUp,
    icon: Icons.inventory_2_rounded,
  );

  factory StatusBadge.outForDelivery({bool animate = true}) => StatusBadge(
    label: 'Out for Delivery',
    color: AppColors.statusOutForDelivery,
    icon: Icons.local_shipping_rounded,
    animate: animate,
  );

  factory StatusBadge.delivered() => const StatusBadge(
    label: 'Delivered',
    color: AppColors.statusDelivered,
    icon: Icons.check_circle_rounded,
  );

  // Payment type badges
  factory StatusBadge.cod({bool small = false}) =>
      StatusBadge(label: 'COD', color: AppColors.codBadge, small: small);

  factory StatusBadge.prepaid({bool small = false}) => StatusBadge(
    label: 'Online / Paid',
    color: AppColors.prepaidBadge,
    small: small,
  );

  @override
  Widget build(BuildContext context) {
    Widget badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 12,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(small ? 6 : 8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && !small) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: (small ? AppTextStyles.caption : AppTextStyles.labelSmall)
                .copyWith(
                  color: textColor ?? color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );

    if (animate) {
      badge = badge
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 2000.ms, color: color.withValues(alpha: 0.3));
    }

    return badge;
  }
}

/// Payment type badge
class PaymentBadge extends StatelessWidget {
  final bool isCod;
  final bool small;

  const PaymentBadge({super.key, required this.isCod, this.small = false});

  @override
  Widget build(BuildContext context) {
    return isCod
        ? StatusBadge.cod(small: small)
        : StatusBadge.prepaid(small: small);
  }
}
