import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../main.dart';
import '../extensions/extensions.dart';
import '../routes/app_routes.dart';

/// Navigation drawer for the app
class AppDrawer extends ConsumerWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final agent = authState.agent;

    return Drawer(
      child: Column(
        children: [
          // User Account Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: context.colorScheme.surface,
              radius: 32.r,
              child: Text(
                agent?.name.substring(0, 1).toUpperCase() ?? 'D',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            accountName: Text(
              agent?.name ?? 'Delivery Partner',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onPrimary,
              ),
            ),
            accountEmail: Text(
              agent?.email ?? 'partner@dehatfresh.com',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onPrimary.withValues(alpha: 0.9),
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerMenuItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  route: AppRoutes.dashboard,
                  currentRoute: currentRoute,
                ),
                _DrawerMenuItem(
                  icon: Icons.assignment_rounded,
                  title: 'Assigned Orders',
                  route: AppRoutes.assignedOrders,
                  currentRoute: currentRoute,
                ),
                _DrawerMenuItem(
                  icon: Icons.history_rounded,
                  title: 'Order History',
                  route: AppRoutes.orderHistory,
                  currentRoute: currentRoute,
                ),
                const Divider(),
                _DrawerMenuItem(
                  icon: Icons.person_rounded,
                  title: 'Profile',
                  route: AppRoutes.profile,
                  currentRoute: currentRoute,
                ),
                _DrawerMenuItem(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  route: AppRoutes.changePassword,
                  currentRoute: currentRoute,
                ),
                _DrawerMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  route: AppRoutes.help,
                  currentRoute: currentRoute,
                ),
              ],
            ),
          ),

          // Logout Button
          const Divider(height: 1),
          _LogoutTile(ref: ref),
        ],
      ),
    );
  }
}

/// Individual drawer menu item widget
class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final String currentRoute;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        size: 22.sp,
        color: isSelected
            ? context.colorScheme.primary
            : context.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      selectedTileColor: context.colorScheme.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      onTap: () {
        if (!isSelected) {
          context.push(route);
        }
      },
    );
  }
}

/// Logout tile widget
class _LogoutTile extends StatelessWidget {
  final WidgetRef ref;

  const _LogoutTile({required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.logout_rounded,
        size: 22.sp,
        color: context.colorScheme.error,
      ),
      title: Text(
        'Logout',
        style: context.textTheme.bodyLarge?.copyWith(
          color: context.colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => _handleLogout(context),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Logout', style: dialogContext.textTheme.titleLarge),
        content: Text(
          'Are you sure you want to logout?',
          style: dialogContext.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12.w),
                      const Text('Logged out successfully!'),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: context.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
