import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/text_fields.dart';
import '../../../../core/utils/validators.dart';
import '../../../../main.dart'; // Import for scaffoldMessengerKey
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// Login page - Authenticate delivery partner (simple, no animations)
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
    log('[LOGIN_PAGE] _handleLogin called');
    if (!_formKey.currentState!.validate()) {
      log('[LOGIN_PAGE] Form validation failed');
      return;
    }

    log('[LOGIN_PAGE] Form validated, calling login...');
    final success = await ref
        .read(authControllerProvider.notifier)
        .login(_emailController.text.trim(), _passwordController.text);

    log('[LOGIN_PAGE] Login returned: $success');

    // Use the global scaffoldMessengerKey to show snackbar
    // This works even if the widget is unmounted (due to GoRouter redirect)
    if (success) {
      log('[LOGIN_PAGE] Showing success snackbar via global key...');
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Login successful! Welcome back.'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      // Navigation is handled automatically by GoRouter redirect
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Show error snackbar if there's an error
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      log(
        '[LOGIN_PAGE] AuthState changed - isLoading: ${next.isLoading}, isAuthenticated: ${next.isAuthenticated}, error: ${next.errorMessage}',
      );
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
            // color: AppColors.primarySurface,
            shape: BoxShape.circle,
            // boxShadow: [
            //   BoxShadow(
            //     color: AppColors.primary.withValues(alpha: 0.2),
            //     blurRadius: 24,
            //     offset: const Offset(0, 8),
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              'assets/images/app_logo.png',
              width: 100.w,
              height: 100.w,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.local_shipping_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Dehat Delivery ',
          style: AppTextStyles.heading1.copyWith(color: AppColors.textPrimary),
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
    );
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
    );
  }

  Widget _buildLoginButton(AuthState authState) {
    return GradientButton(
      text: 'Login',
      isLoading: authState.isLoading,
      onPressed: _handleLogin,
    );
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
    );
  }
}
