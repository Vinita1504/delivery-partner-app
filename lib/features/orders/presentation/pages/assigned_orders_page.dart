import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_card.dart';

/// Assigned Orders page - Shows all orders assigned to delivery partner
class AssignedOrdersPage extends ConsumerStatefulWidget {
  const AssignedOrdersPage({super.key});

  @override
  ConsumerState<AssignedOrdersPage> createState() => _AssignedOrdersPageState();
}

class _AssignedOrdersPageState extends ConsumerState<AssignedOrdersPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ordersProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(currentRoute: '/assigned-orders'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Assigned Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(ordersProvider.notifier).refreshOrders(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(ordersProvider.notifier).refreshOrders(),
        color: AppColors.primary,
        child: ordersState.isLoading
            ? _buildLoadingState()
            : ordersState.orders.isEmpty
            ? _buildEmptyState()
            : _buildOrdersList(ordersState),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => const OrderCardSkeleton(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inbox_rounded,
                      size: 64,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  )
                  .animate()
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: AnimationConstants.slow,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(),
              const SizedBox(height: 24),
              Text(
                    'No orders assigned',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .slideY(begin: 0.2, duration: AnimationConstants.normal),
              const SizedBox(height: 8),
              Text(
                    'Check back later for new deliveries.\nPull down to refresh.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.2, duration: AnimationConstants.normal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(OrdersState ordersState) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ordersState.orders.length,
      itemBuilder: (context, index) {
        final order = ordersState.orders[index];
        return OrderCard(
          order: order,
          index: index,
          onTap: () => context.push('/order/${order.id}'),
        );
      },
    );
  }
}
