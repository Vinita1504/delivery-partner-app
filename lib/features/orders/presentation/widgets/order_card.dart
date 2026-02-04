import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/enums/enums.dart';
import '../../data/models/order_model.dart';

/// Animated order card widget for order lists
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final int? index;

  const OrderCard({super.key, required this.order, this.onTap, this.index});

  @override
  Widget build(BuildContext context) {
    Widget card = AnimatedCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      backgroundColor: AppColors.white,
      boxShadow: AppColors.cardShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row - Order ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '#${order.id}',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          const SizedBox(height: 14),

          // Customer name
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 16,
                color: AppColors.grey500,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.customerName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Area/Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.grey500,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.areaName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Divider
          Container(height: 1, color: AppColors.grey100),
          const SizedBox(height: 14),

          // Bottom row - Payment type and Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PaymentBadge(isCod: order.isCod, small: true),
              Row(
                children: [
                  Text(
                    '₹',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    order.amount.toStringAsFixed(0),
                    style: AppTextStyles.heading4.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    // Add stagger animation if index is provided
    if (index != null) {
      card = card
          .animate()
          .fadeIn(
            delay: Duration(milliseconds: 50 * index!),
            duration: AnimationConstants.normal,
          )
          .slideY(
            begin: 0.1,
            delay: Duration(milliseconds: 50 * index!),
            duration: AnimationConstants.normal,
            curve: AnimationConstants.defaultCurve,
          );
    }

    return card;
  }

  Widget _buildStatusBadge(OrderStatus status) {
    switch (status) {
      case OrderStatus.assigned:
        return StatusBadge.assigned();
      case OrderStatus.pickedUp:
        return StatusBadge.pickedUp();
      case OrderStatus.outForDelivery:
        return StatusBadge.outForDelivery(animate: true);
      case OrderStatus.delivered:
        return StatusBadge.delivered();
      case OrderStatus.cancelled:
        return StatusBadge(
          label: 'Cancelled',
          color: AppColors.error,
          icon: Icons.cancel_rounded,
        );
    }
  }
}
