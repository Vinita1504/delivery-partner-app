import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_greeting.dart';
import '../widgets/dashboard_stats_section.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_recent_activity.dart';

/// Dashboard page - Home overview with stats and quick actions
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data - Replace with actual provider data
  final int _assignedCount = 5;
  final int _deliveredToday = 12;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final agentName = authState.agent?.name;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(currentRoute: AppRoutes.dashboard),
      appBar: DashboardAppBar(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () {
          // TODO: Handle notification tap
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardGreeting(userName: agentName),
            SizedBox(height: 24.h),
            DashboardStatsSection(
              assignedCount: _assignedCount,
              deliveredCount: _deliveredToday,
              assignedColor: AppColors.statusAssigned,
              deliveredColor: AppColors.statusDelivered,
            ),
            SizedBox(height: 24.h),
            DashboardQuickActions(
              assignedCount: _assignedCount,
              primaryColor: AppColors.primary,
              assignedColor: AppColors.statusAssigned,
              secondaryColor: AppColors.secondary,
              historyColor: AppColors.grey600,
            ),
            SizedBox(height: 24.h),
            const DashboardRecentActivity(),
          ],
        ),
      ),
    );
  }
}
