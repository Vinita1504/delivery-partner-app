import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../controllers/auth_controller.dart';

/// Profile page - Show delivery partner account information with premium UI
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final agent = authState.agent;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.grey50,
      drawer: const AppDrawer(currentRoute: '/profile'),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'My Profile',
          style: AppTextStyles.heading4.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Header with Avatar
            _buildProfileHeader(agent?.name, agent?.email),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Personal Info
                  _buildSectionHeader('Personal Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard(agent),
                  const SizedBox(height: 24),

                  // Settings
                  _buildSectionHeader('Settings'),
                  const SizedBox(height: 12),
                  _buildSettingsCard(),
                  const SizedBox(height: 32),

                  // Logout Button
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String? name, String? email) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.2),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.white,
              child: Text(
                name?.substring(0, 1).toUpperCase() ?? 'U',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.primary,
                  fontSize: 40,
                ),
              ),
            ),
          ).animate().scale(
            duration: AnimationConstants.slow,
            curve: Curves.elasticOut,
          ),

          const SizedBox(height: 16),
          Text(
            name ?? 'User Name',
            style: AppTextStyles.heading3.copyWith(color: AppColors.white),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),

          const SizedBox(height: 4),
          Text(
            email ?? 'user@example.com',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildInfoCard(dynamic agent) {
    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.badge_outlined,
              'Partner ID',
              agent?.userId ?? 'DP-2024-001',
              showDivider: true,
            ),
            _buildInfoRow(
              Icons.phone_outlined,
              'Phone Number',
              agent?.phone ?? '+91 98765 43210',
              showDivider: true,
            ),
            _buildInfoRow(
              Icons.location_on_outlined,
              'Service Area',
              agent?.address?.city ?? 'Not Available',
              showDivider: false,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: AppColors.grey200, height: 1),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return AnimatedCard(
      child: Column(
        children: [
          _buildSettingsItem(
            Icons.lock_outline_rounded,
            'Change Password',
            () => context.push('/profile/change-password'),
            showDivider: true,
          ),
          _buildSettingsItem(
            Icons.notifications_outlined,
            'Notifications',
            () {},
            showDivider: true,
            trailing: Switch(
              value: true,
              onChanged: (v) {},
              activeColor: AppColors.primary,
            ),
          ),
          _buildSettingsItem(
            Icons.help_outline_rounded,
            'Help & Support',
            () => context.push('/help'),
            showDivider: false,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool showDivider = true,
    Widget? trailing,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: trailing == null ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.grey600, size: 24),
                  const SizedBox(width: 16),
                  Expanded(child: Text(title, style: AppTextStyles.bodyLarge)),
                  if (trailing != null)
                    trailing
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.grey400,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(color: AppColors.grey200, height: 1, indent: 56),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return GradientButton(
      text: 'Logout',
      icon: Icons.logout_rounded,
      onPressed: () async {
        await ref.read(authControllerProvider.notifier).logout();
        if (context.mounted) {
          context.go('/login');
        }
      },
      gradient: LinearGradient(
        colors: [Colors.red.shade400, Colors.red.shade600],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1);
  }
}
