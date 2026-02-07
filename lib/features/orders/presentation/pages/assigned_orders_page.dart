import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      ref.read(ordersProvider.notifier).fetchOrders();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(ordersProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(ordersProvider.notifier).refresh(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(ordersProvider.notifier).refresh(),
        color: AppColors.primary,
        child: _buildBody(ordersState),
      ),
    );
  }

  Widget _buildBody(OrdersState ordersState) {
    if (ordersState.isLoading) {
      return _buildLoadingState();
    }

    if (ordersState.hasError) {
      return _buildErrorState(ordersState.error!);
    }

    if (ordersState.isEmpty) {
      return _buildEmptyState();
    }

    return _buildOrdersList(ordersState);
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => const OrderCardSkeleton(),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                error,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.read(ordersProvider.notifier).fetchOrders(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
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
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          ordersState.orders.length + (ordersState.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= ordersState.orders.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
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
