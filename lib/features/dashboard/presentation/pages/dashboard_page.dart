import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_greeting.dart';
import '../widgets/dashboard_stats_section.dart';
import '../widgets/dashboard_quick_actions.dart';
import 'notification_test_page.dart';

/// Dashboard page - Home overview with stats and quick actions
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Fetch dashboard stats on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final dashboardState = ref.watch(dashboardProvider);
    final agentName = authState.agent?.name;

    final stats = dashboardState.displayStats;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(currentRoute: AppRoutes.dashboard),
      appBar: DashboardAppBar(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardGreeting(userName: agentName),
              SizedBox(height: 24.h),
              if (dashboardState.isLoading && !dashboardState.hasData)
                _buildLoadingStats()
              else if (dashboardState.hasError)
                _buildErrorState(dashboardState.error!)
              else
                DashboardStatsSection(
                  assignedCount: stats.assignedCount,
                  deliveredCount: stats.deliveredToday,
                  returnPickupCount: stats.returnPickupCount,
                  codCollected: stats.codCollected,
                  codPending: stats.codPending,
                  assignedColor: AppColors.statusAssigned,
                  deliveredColor: AppColors.statusDelivered,
                  returnPickupColor: AppColors.warning,
                ),
              SizedBox(height: 24.h),
              DashboardQuickActions(
                assignedCount: stats.assignedCount,
                primaryColor: AppColors.primary,
                assignedColor: AppColors.statusAssigned,
                secondaryColor: AppColors.secondary,
                historyColor: AppColors.grey600,
              ),
              SizedBox(height: 24.h),
              // DEV: Test notification panel
              _TestNotifButton(),
              SizedBox(height: 24.h),
              // const DashboardRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingStats() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 100.h,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            height: 100.h,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: AppColors.error, fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () => ref.read(dashboardProvider.notifier).fetchStats(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// DEV ONLY: Button to open the notification test panel.
class _TestNotifButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationTestPage()),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6F00), Color(0xFFF57C00)],
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6F00).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bug_report_rounded, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              'Test Notifications',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
