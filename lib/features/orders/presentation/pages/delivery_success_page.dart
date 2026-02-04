import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/gradient_button.dart';

/// Delivery success page with celebration animation
class DeliverySuccessPage extends StatefulWidget {
  final String orderId;

  const DeliverySuccessPage({super.key, required this.orderId});

  @override
  State<DeliverySuccessPage> createState() => _DeliverySuccessPageState();
}

class _DeliverySuccessPageState extends State<DeliverySuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    // Haptic feedback on success
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Confetti particles
            ..._buildConfettiParticles(),

            // Main content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Success icon with rings
                  _buildSuccessIcon(),
                  const SizedBox(height: 40),

                  // Title
                  _buildTitle(),
                  const SizedBox(height: 16),

                  // Subtitle
                  _buildSubtitle(),
                  const SizedBox(height: 40),

                  // Stats card
                  _buildStatsCard(),

                  const Spacer(),

                  // Back button
                  _buildBackButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConfettiParticles() {
    final List<Widget> particles = [];
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.statusAssigned,
    ];

    for (int i = 0; i < 20; i++) {
      final color = colors[i % colors.length];
      final left = (i * 37.0) % MediaQuery.of(context).size.width;
      final delay = (i * 80).ms;

      particles.add(
        Positioned(
          left: left,
          top: -20,
          child:
              Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                  .animate(controller: _confettiController, autoPlay: false)
                  .fadeIn(delay: delay, duration: 300.ms)
                  .slideY(
                    begin: 0,
                    end: 10,
                    delay: delay,
                    duration: 1500.ms,
                    curve: Curves.easeIn,
                  )
                  .rotate(begin: 0, end: 2, delay: delay, duration: 1500.ms)
                  .fadeOut(delay: delay + 1000.ms, duration: 500.ms),
        ),
      );
    }
    return particles;
  }

  Widget _buildSuccessIcon() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
              )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                duration: 600.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(),

          // Middle ring
          Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(alpha: 0.1),
                ),
              )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                delay: 100.ms,
                duration: 600.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(delay: 100.ms),

          // Icon container
          Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.success, Color(0xFF22C55E)],
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 56,
                  color: AppColors.white,
                ),
              )
              .animate()
              .scale(
                begin: const Offset(0, 0),
                delay: 200.ms,
                duration: 500.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
          'Delivery Successful!',
          style: AppTextStyles.heading1.copyWith(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: AnimationConstants.normal)
        .slideY(begin: 0.2, delay: 400.ms, duration: AnimationConstants.normal);
  }

  Widget _buildSubtitle() {
    return Text(
          'Order #${widget.orderId} has been\ndelivered successfully',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        )
        .animate()
        .fadeIn(delay: 500.ms, duration: AnimationConstants.normal)
        .slideY(begin: 0.2, delay: 500.ms, duration: AnimationConstants.normal);
  }

  Widget _buildStatsCard() {
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.access_time_filled_rounded,
                label: 'Time',
                value: '12 min',
                color: AppColors.statusAssigned,
              ),
              Container(width: 1, height: 40, color: AppColors.grey200),
              _buildStatItem(
                icon: Icons.check_circle_rounded,
                label: 'Status',
                value: 'Complete',
                color: AppColors.success,
              ),
              Container(width: 1, height: 40, color: AppColors.grey200),
              _buildStatItem(
                icon: Icons.star_rounded,
                label: 'Rating',
                value: '★ 5.0',
                color: AppColors.secondary,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 600.ms, duration: AnimationConstants.normal)
        .slideY(begin: 0.2, delay: 600.ms, duration: AnimationConstants.normal);
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(value, style: AppTextStyles.labelLarge),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return GradientButton(
          text: 'Back to Dashboard',
          icon: Icons.dashboard_rounded,
          onPressed: () => context.go('/dashboard'),
        )
        .animate()
        .fadeIn(delay: 700.ms, duration: AnimationConstants.normal)
        .slideY(begin: 0.2, delay: 700.ms, duration: AnimationConstants.normal);
  }
}
