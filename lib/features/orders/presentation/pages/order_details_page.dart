import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/enums/enums.dart';
import '../../data/models/order_model.dart';
import '../../../../core/widgets/status_badge.dart';

/// Order details page - Show all info required to complete one order
class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  OrderModel? _order;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    // TODO: Replace with actual API call using provider
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data for now
    if (mounted) {
      setState(() {
        _order = OrderModel(
          id: widget.orderId,
          customerId: 'C001',
          customerName: 'Rahul Sharma',
          customerPhone: '9876543210',
          deliveryAddress: '123, Main Street, Sector 5, Near Park',
          areaName: 'Green Valley',
          paymentType: PaymentType.cod,
          amount: 450,
          status: OrderStatus.assigned,
          createdAt: DateTime.now(),
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAction() async {
    if (_order == null) return;

    if (_order!.status == OrderStatus.outForDelivery) {
      if (_order!.isCod) {
        context.push(
          '/order/${widget.orderId}/cod',
          extra: {'amount': _order!.amount},
        );
      } else {
        context.push('/order/${widget.orderId}/otp');
      }
    } else {
      // Simulate status update for other states
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));

      if (mounted && _order != null) {
        OrderStatus nextStatus;
        switch (_order!.status) {
          case OrderStatus.assigned:
            nextStatus = OrderStatus.pickedUp;
            break;
          case OrderStatus.pickedUp:
            nextStatus = OrderStatus.outForDelivery;
            break;
          default:
            nextStatus = _order!.status;
        }

        setState(() {
          _order = _order!.copyWith(status: nextStatus);
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _callCustomer() async {
    final uri = Uri.parse('tel:${_order?.customerPhone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _order == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Order #${widget.orderId}')),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Order #${widget.orderId}')),
        body: const Center(child: Text('Order not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text('Order #${_order!.id}'),
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () =>
                context.push('/help', extra: {'orderId': _order!.id}),
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
                  _buildOrderTimeline(),
                  const SizedBox(height: 20),

                  // Map Placeholder
                  _buildMapPlaceholder(),
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
                          Icons.person_rounded,
                          _order!.customerName,
                          'Customer Name',
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.phone_rounded,
                              color: AppColors.primary,
                            ),
                            onPressed: _callCustomer,
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.location_on_rounded,
                          _order!.areaName,
                          _order!.deliveryAddress,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                  const SizedBox(height: 20),

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
                                  '₹${_order!.amount.toStringAsFixed(0)}',
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            PaymentBadge(isCod: _order!.isCod),
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
      bottomSheet: !_order!.isDelivered ? _buildBottomAction() : null,
    );
  }

  Widget _buildOrderTimeline() {
    final steps = OrderStatus.values
        .where((s) => s != OrderStatus.cancelled)
        .toList();
    final currentStepIndex = steps.indexOf(_order!.status);

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
          final isCompleted = index <= currentStepIndex;
          final isCurrent = index == currentStepIndex;

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
                            : (index <= currentStepIndex
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
                            : (index < currentStepIndex
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

  Widget _buildMapPlaceholder() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        image: const DecorationImage(
          image: AssetImage('assets/images/app_logo.png'), // Placeholder
          opacity: 0.1,
          fit: BoxFit.contain,
        ),
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
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildInfoRow(
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

  Widget _buildBottomAction() {
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
          text: _order!.nextActionText,
          icon: _getActionIcon(),
          onPressed: _handleAction,
          isLoading: _isLoading,
        ),
      ),
    ).animate().slideY(
      begin: 1.0,
      duration: 400.ms,
      curve: Curves.easeOutQuart,
    );
  }

  IconData _getActionIcon() {
    switch (_order!.status) {
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
