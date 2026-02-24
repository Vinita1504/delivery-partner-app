import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/text_fields.dart';
import '../../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';
import '../../../../main.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String phone;
  final String otp;

  const ResetPasswordPage({super.key, required this.phone, required this.otp});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final success = await ref
        .read(authControllerProvider.notifier)
        .forgotPasswordReset(
          widget.phone,
          widget.otp,
          _passwordController.text,
        );

    if (mounted) {
      setState(() => _isLoading = false);
    }

    if (success) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully! You can now log in.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      if (mounted) {
        context.goNamed('login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text('Set New Password', style: AppTextStyles.heading1),
                const SizedBox(height: 8),
                Text(
                  'Create a new password for your account.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'New Password',
                  hint: 'Enter your new password',
                  isVisible: _isPasswordVisible,
                  onVisibilityChanged: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  isVisible: _isConfirmVisible,
                  onVisibilityChanged: () =>
                      setState(() => _isConfirmVisible = !_isConfirmVisible),
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                const SizedBox(height: 32),
                GradientButton(
                  text: 'Reset Password',
                  isLoading: _isLoading,
                  onPressed: _handleResetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onVisibilityChanged,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          label: '',
          hint: hint,
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          prefixIcon: const Icon(Icons.lock_outlined, size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
            ),
            onPressed: onVisibilityChanged,
          ),
        ),
      ],
    );
  }
}
