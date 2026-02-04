import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/text_fields.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

/// Login page - Authenticate delivery partner with animations
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .login(_emailController.text.trim(), _passwordController.text);

    if (success && mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Show error snackbar if there's an error
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo
                _buildLogo(),
                const SizedBox(height: 32),

                // Title
                _buildTitle(),
                const SizedBox(height: 48),

                // Email field
                _buildEmailField(),
                const SizedBox(height: 20),

                // Password field
                _buildPasswordField(),
                const SizedBox(height: 32),

                // Login button
                _buildLoginButton(authState),
                const SizedBox(height: 32),

                // Info text
                _buildInfoText(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.local_shipping_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          duration: AnimationConstants.slow,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: AnimationConstants.normal);
  }

  Widget _buildTitle() {
    return Column(
          children: [
            Text(
              'Delivery Partner',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Login to start your deliveries',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: AnimationConstants.normal)
        .slideY(begin: 0.2, delay: 200.ms, duration: AnimationConstants.normal);
  }

  Widget _buildEmailField() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              label: '',
              hint: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, size: 20),
              validator: Validators.validateEmail,
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: AnimationConstants.normal)
        .slideX(
          begin: -0.1,
          delay: 300.ms,
          duration: AnimationConstants.normal,
        );
  }

  Widget _buildPasswordField() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              label: '',
              hint: 'Enter your password',
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              prefixIcon: const Icon(Icons.lock_outlined, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              validator: Validators.validatePassword,
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: AnimationConstants.normal)
        .slideX(
          begin: -0.1,
          delay: 400.ms,
          duration: AnimationConstants.normal,
        );
  }

  Widget _buildLoginButton(AuthState authState) {
    return GradientButton(
          text: 'Login',
          isLoading: authState.isLoading,
          onPressed: _handleLogin,
        )
        .animate()
        .fadeIn(delay: 500.ms, duration: AnimationConstants.normal)
        .slideY(begin: 0.2, delay: 500.ms, duration: AnimationConstants.normal);
  }

  Widget _buildInfoText() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.textHint, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Credentials are provided by admin. Contact admin if you need access.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: AnimationConstants.normal);
  }
}
