import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/enums/enums.dart';
import '../../../orders/data/models/order_model.dart';

/// Order History page - Shows all delivered orders
class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  final List<String> _filters = ['All', 'Today', 'This Week', 'This Month'];

  // Mock data - Replace with actual provider
  final List<OrderModel> _deliveredOrders = [
    OrderModel(
      id: 'ORD-1001',
      customerId: 'C001',
      customerName: 'Amit Kumar',
      customerPhone: '9876543210',
      deliveryAddress: '123, Main Street, Sector 5',
      areaName: 'Green Valley',
      paymentType: PaymentType.cod,
      amount: 450,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    OrderModel(
      id: 'ORD-1000',
      customerId: 'C002',
      customerName: 'Priya Sharma',
      customerPhone: '9876543211',
      deliveryAddress: '456, Park Road, Block B',
      areaName: 'Sunrise Colony',
      paymentType: PaymentType.prepaid,
      amount: 680,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    OrderModel(
      id: 'ORD-999',
      customerId: 'C003',
      customerName: 'Rahul Verma',
      customerPhone: '9876543212',
      deliveryAddress: '789, Lake View',
      areaName: 'Central Market',
      paymentType: PaymentType.cod,
      amount: 320,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    OrderModel(
      id: 'ORD-998',
      customerId: 'C004',
      customerName: 'Sneha Patel',
      customerPhone: '9876543213',
      deliveryAddress: '234, MG Road',
      areaName: 'Central Market',
      paymentType: PaymentType.prepaid,
      amount: 1150,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _filters.map((f) => Tab(text: f)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _filters.map((_) => _buildOrdersList()).toList(),
      ),
    );
  }

  Widget _buildOrdersList() {
    if (_deliveredOrders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _deliveredOrders.length,
      itemBuilder: (context, index) {
        final order = _deliveredOrders[index];
        return _buildHistoryCard(order, index);
      },
    );
  }

  Widget _buildHistoryCard(OrderModel order, int index) {
    return AnimatedCard(
          margin: const EdgeInsets.only(bottom: 12),
          onTap: () => _showOrderDetails(order),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.statusDelivered.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: AppColors.statusDelivered,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '#${order.id}',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  PaymentBadge(isCod: order.isCod, small: true),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.customerName,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  Text(
                    '₹${order.amount.toStringAsFixed(0)}',
                    style: AppTextStyles.heading4.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(order.createdAt),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 50 * index))
        .slideY(
          begin: 0.1,
          delay: Duration(milliseconds: 50 * index),
          duration: AnimationConstants.normal,
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_rounded,
              size: 48,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No order history',
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completed orders will appear here',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #${order.id}', style: AppTextStyles.heading3),
                StatusBadge.delivered(),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              Icons.person_rounded,
              'Customer',
              order.customerName,
            ),
            _buildDetailRow(Icons.phone_rounded, 'Phone', order.customerPhone),
            _buildDetailRow(
              Icons.location_on_rounded,
              'Address',
              order.deliveryAddress,
            ),
            _buildDetailRow(
              Icons.currency_rupee_rounded,
              'Amount',
              '₹${order.amount.toStringAsFixed(0)}',
            ),
            _buildDetailRow(
              Icons.payment_rounded,
              'Payment',
              order.paymentType.displayName,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grey500),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
