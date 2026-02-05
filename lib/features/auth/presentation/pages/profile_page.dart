import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../main.dart';
import '../controllers/auth_controller.dart';
import '../../domain/entities/delivery_agent_entity.dart';

/// Profile page - Show delivery partner account information with premium UI
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final agent = authState.agent;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
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
                  _buildPersonalInfoCard(agent),
                  const SizedBox(height: 24),

                  // Vehicle Info
                  _buildSectionHeader('Vehicle Information'),
                  const SizedBox(height: 12),
                  _buildVehicleInfoCard(agent),
                  const SizedBox(height: 24),

                  // Address Info
                  _buildSectionHeader('Address'),
                  const SizedBox(height: 12),
                  _buildAddressCard(agent),
                  const SizedBox(height: 24),

                  // Documents
                  _buildSectionHeader('Documents'),
                  const SizedBox(height: 12),
                  _buildDocumentsCard(agent),
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

  Widget _buildPersonalInfoCard(DeliveryAgentEntity? agent) {
    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.badge_outlined,
              'Partner ID',
              agent?.userId ?? 'Not Available',
              showDivider: true,
            ),
            _buildInfoRow(
              Icons.phone_outlined,
              'Phone Number',
              agent?.phone ?? 'Not Available',
              showDivider: true,
            ),
            _buildInfoRow(
              Icons.email_outlined,
              'Email Address',
              agent?.email ?? 'Not Available',
              showDivider: false,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildVehicleInfoCard(DeliveryAgentEntity? agent) {
    String vehicleTypeLabel = 'Not Available';
    if (agent?.vehicleType != null) {
      switch (agent!.vehicleType.toLowerCase()) {
        case 'twowheeler':
          vehicleTypeLabel = 'Two Wheeler';
          break;
        case 'threewheeler':
          vehicleTypeLabel = 'Three Wheeler';
          break;
        case 'fourwheeler':
          vehicleTypeLabel = 'Four Wheeler';
          break;
        default:
          vehicleTypeLabel = agent.vehicleType;
      }
    }

    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.two_wheeler_outlined,
              'Vehicle Type',
              vehicleTypeLabel,
              showDivider: true,
            ),
            _buildInfoRow(
              Icons.directions_car_outlined,
              'Vehicle Name',
              agent?.vehicleName ?? 'Not Available',
              showDivider: true,
            ),
            _buildInfoRow(
              Icons.confirmation_number_outlined,
              'Vehicle Number',
              agent?.vehicleNo ?? 'Not Available',
              showDivider: true,
            ),
            _buildInfoRow(
              Icons.card_membership_outlined,
              'License Number',
              agent?.license ?? 'Not Available',
              showDivider: false,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1);
  }

  Widget _buildAddressCard(DeliveryAgentEntity? agent) {
    final address = agent?.address;
    String fullAddress = 'Not Available';
    if (address != null) {
      fullAddress =
          '${address.street}, ${address.city}, ${address.state} - ${address.zip}, ${address.country}';
    }

    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Area Address',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fullAddress,
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
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildDocumentsCard(DeliveryAgentEntity? agent) {
    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.credit_card_outlined,
              'Aadhaar Number',
              agent?.aadhaar ?? 'Not Available',
              showDivider: true,
            ),
            _buildInfoRow(
              Icons.account_balance_wallet_outlined,
              'PAN Number',
              agent?.pan ?? 'Not Available',
              showDivider: false,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.1);
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

  Widget _buildLogoutButton() {
    return GradientButton(
      text: 'Logout',
      icon: Icons.logout_rounded,
      onPressed: () async {
        await ref.read(authControllerProvider.notifier).logout();
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Logged out successfully!'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        // Navigation handled by GoRouter redirect
      },
      gradient: LinearGradient(
        colors: [Colors.red.shade400, Colors.red.shade600],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1);
  }
}
