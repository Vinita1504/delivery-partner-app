import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/enums/enums.dart';
import '../../data/models/order_model.dart';
import '../../../../core/widgets/status_badge.dart';
import '../providers/order_detail_provider.dart';

/// Order details page - Show all info required to complete one order
class OrderDetailsPage extends ConsumerWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderDetailProvider(orderId));

    if (state.isLoading && !state.hasData) {
      return Scaffold(
        appBar: AppBar(title: Text('Order #$orderId')),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (state.hasError) {
      return Scaffold(
        appBar: AppBar(title: Text('Order #$orderId')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                state.error!,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(orderDetailProvider(orderId).notifier)
                    .fetchOrderDetails(orderId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!state.hasData) {
      return Scaffold(
        appBar: AppBar(title: Text('Order #$orderId')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final order = state.order!;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text('Order #${order.orderNumber}'),
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () =>
                context.push('/help', extra: {'orderId': order.id}),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline
                  _buildOrderTimeline(order),
                  const SizedBox(height: 20),

                  // Map Placeholder
                  _buildMapPlaceholder(order),
                  const SizedBox(height: 20),

                  // Customer info
                  Text(
                    'Customer Details',
                    style: AppTextStyles.labelLarge,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 8),
                  AnimatedCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          Icons.person_rounded,
                          order.customerDisplayName,
                          'Customer Name',
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.phone_rounded,
                              color: AppColors.primary,
                            ),
                            onPressed: () => _callCustomer(order.customerPhone),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          Icons.location_on_rounded,
                          order.deliveryAddress?.city ?? 'Unknown Area',
                          order.deliveryAddress?.fullAddress ??
                              'Address not available',
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                  const SizedBox(height: 20),

                  // Order items (if available)
                  if (order.orderItems.isNotEmpty) ...[
                    Text(
                      'Order Items',
                      style: AppTextStyles.labelLarge,
                    ).animate().fadeIn(delay: 250.ms),
                    const SizedBox(height: 8),
                    AnimatedCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ...order.orderItems.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                        Text(
                                          item.formattedQuantity,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${item.totalPrice.toStringAsFixed(0)}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),
                    const SizedBox(height: 20),
                  ],

                  // Payment info
                  Text(
                    'Payment Details',
                    style: AppTextStyles.labelLarge,
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 8),
                  AnimatedCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: AppTextStyles.caption,
                                ),
                                Text(
                                  order.formattedAmount,
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            PaymentBadge(isCod: order.isCod),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                  const SizedBox(height: 100), // Space for fab
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: !order.isDelivered
          ? _buildBottomAction(context, ref, order, state.isUpdating)
          : null,
    );
  }

  Widget _buildOrderTimeline(OrderModel order) {
    final steps = [
      OrderStatus.assigned,
      OrderStatus.pickedUp,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];
    final currentStepIndex = steps.indexWhere((s) => s == order.status);
    final actualIndex = currentStepIndex >= 0 ? currentStepIndex : 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isCompleted = index <= actualIndex;
          final isCurrent = index == actualIndex;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index == 0
                            ? Colors.transparent
                            : (index <= actualIndex
                                  ? AppColors.primary
                                  : AppColors.grey200),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.primary
                            : AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.primary
                              : AppColors.grey300,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: AppColors.white,
                            )
                          : null,
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index == steps.length - 1
                            ? Colors.transparent
                            : (index < actualIndex
                                  ? AppColors.primary
                                  : AppColors.grey200),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  steps[index].displayName.split(' ').first,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isCurrent ? AppColors.primary : AppColors.grey500,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildMapPlaceholder(OrderModel order) {
    return GestureDetector(
      onTap: () async {
        if (order.deliveryAddress?.hasCoordinates == true) {
          final uri = Uri.parse(order.deliveryAddress!.mapsUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_rounded, color: AppColors.primary, size: 32),
              const SizedBox(height: 8),
              Text(
                'Navigate to Location',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.grey600, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLarge),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    WidgetRef ref,
    OrderModel order,
    bool isLoading,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: GradientButton(
          text: order.nextActionText,
          icon: _getActionIcon(order.status),
          onPressed: () => _handleAction(context, ref, order),
          isLoading: isLoading,
        ),
      ),
    ).animate().slideY(
      begin: 1.0,
      duration: 400.ms,
      curve: Curves.easeOutQuart,
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    OrderModel order,
  ) async {
    final notifier = ref.read(orderDetailProvider(orderId).notifier);

    if (order.status == OrderStatus.outForDelivery) {
      if (order.isCod) {
        context.push(
          '/order/$orderId/cod',
          extra: {'amount': order.totalAmount},
        );
      } else {
        context.push('/order/$orderId/otp');
      }
    } else if (order.status == OrderStatus.assigned) {
      await notifier.markAsPickedUp();
    } else if (order.status == OrderStatus.pickedUp) {
      await notifier.markAsOutForDelivery();
    }
  }

  Future<void> _callCustomer(String phone) async {
    if (phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  IconData _getActionIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.assigned:
        return Icons.inventory_rounded;
      case OrderStatus.pickedUp:
        return Icons.local_shipping_rounded;
      case OrderStatus.outForDelivery:
        return Icons.check_circle_rounded;
      default:
        return Icons.arrow_forward_rounded;
    }
  }
}
