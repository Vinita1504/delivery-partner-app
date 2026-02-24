import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

class VerifyOtpForgotPasswordPage extends ConsumerStatefulWidget {
  final String phone;

  const VerifyOtpForgotPasswordPage({super.key, required this.phone});

  @override
  ConsumerState<VerifyOtpForgotPasswordPage> createState() =>
      _VerifyOtpForgotPasswordPageState();
}

class _VerifyOtpForgotPasswordPageState
    extends ConsumerState<VerifyOtpForgotPasswordPage> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyOtp() async {
    if (_otpController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 4-digit OTP'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final success = await ref
        .read(authControllerProvider.notifier)
        .forgotPasswordVerifyOtp(widget.phone, _otpController.text);

    if (mounted) {
      setState(() => _isLoading = false);
    }

    if (success) {
      if (mounted) {
        context.pushReplacementNamed(
          'resetPassword',
          extra: {'phone': widget.phone, 'otp': _otpController.text},
        );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text('Verify OTP', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Enter the 4-digit OTP sent to +91 ${widget.phone}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: Pinput(
                  length: 4,
                  controller: _otpController,
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      color: AppColors.textPrimary,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey300),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                  ),
                  onCompleted: (_) => _handleVerifyOtp(),
                ),
              ),
              const SizedBox(height: 48),
              GradientButton(
                text: 'Verify',
                isLoading: _isLoading,
                onPressed: _handleVerifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
