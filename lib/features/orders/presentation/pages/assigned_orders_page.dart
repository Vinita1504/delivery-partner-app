import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../data/models/order_model.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_card.dart';

/// Assigned Orders page - Shows all orders assigned to delivery partner
class AssignedOrdersPage extends ConsumerStatefulWidget {
  const AssignedOrdersPage({super.key});

  @override
  ConsumerState<AssignedOrdersPage> createState() => _AssignedOrdersPageState();
}

class _AssignedOrdersPageState extends ConsumerState<AssignedOrdersPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _deliveriesScrollController = ScrollController();
  final ScrollController _pickupsScrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _deliveriesScrollController.addListener(_onScroll);
    _pickupsScrollController.addListener(_onScroll);
    Future.microtask(() {
      ref.read(ordersProvider.notifier).fetchOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _deliveriesScrollController.dispose();
    _pickupsScrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final activeScrollController = _tabController.index == 0
        ? _deliveriesScrollController
        : _pickupsScrollController;

    if (activeScrollController.position.pixels >=
        activeScrollController.position.maxScrollExtent - 200) {
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Deliveries'),
            Tab(text: 'Pickups'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Deliveries Tab
          RefreshIndicator(
            onRefresh: () => ref.read(ordersProvider.notifier).refresh(),
            color: AppColors.primary,
            child: _buildBody(ordersState, isPickupTab: false),
          ),
          // Pickups Tab
          RefreshIndicator(
            onRefresh: () => ref.read(ordersProvider.notifier).refresh(),
            color: AppColors.primary,
            child: _buildBody(ordersState, isPickupTab: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(OrdersState ordersState, {required bool isPickupTab}) {
    if (ordersState.isLoading) {
      return _buildLoadingState();
    }

    if (ordersState.hasError) {
      return _buildErrorState(ordersState.error!);
    }

    // Filter orders based on tab
    final filteredOrders = ordersState.orders.where((order) {
      final isReturn =
          order.status.name == 'returnRequested' ||
          order.status.name == 'returnPickupAssigned' ||
          order.status.name == 'returnPickedUp';
      return isPickupTab ? isReturn : !isReturn;
    }).toList();

    if (filteredOrders.isEmpty && !ordersState.isLoadingMore) {
      return _buildEmptyState(isPickupTab);
    }

    return _buildOrdersList(ordersState, filteredOrders, isPickupTab);
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

  Widget _buildEmptyState(bool isPickupTab) {
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
                      isPickupTab
                          ? Icons.assignment_return_rounded
                          : Icons.local_shipping_rounded,
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
                    isPickupTab
                        ? 'No pickups assigned'
                        : 'No deliveries assigned',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .slideY(begin: 0.2, duration: AnimationConstants.normal),
              const SizedBox(height: 8),
              Text(
                    isPickupTab
                        ? 'Check back later for new return pickups.\nPull down to refresh.'
                        : 'Check back later for new deliveries.\nPull down to refresh.',
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

  Widget _buildOrdersList(
    OrdersState ordersState,
    List<OrderModel> filteredOrders,
    bool isPickupTab,
  ) {
    return ListView.builder(
      controller: isPickupTab
          ? _pickupsScrollController
          : _deliveriesScrollController,
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length + (ordersState.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= filteredOrders.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final order = filteredOrders[index];
        return OrderCard(
          order: order,
          index: index,
          onTap: () => context.push('/order/${order.id}'),
        );
      },
    );
  }
}
