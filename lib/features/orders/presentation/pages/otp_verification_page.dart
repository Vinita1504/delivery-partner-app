import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/gradient_button.dart';

/// OTP Verification page with Pinput for prepaid orders
class OtpVerificationPage extends StatefulWidget {
  final String orderId;

  const OtpVerificationPage({super.key, required this.orderId});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isLoading = false;
  bool _canResend = false;
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-focus the pin field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startResendTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_pinController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 1));
    HapticFeedback.mediumImpact();

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/order/${widget.orderId}/success');
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    HapticFeedback.lightImpact();
    setState(() {
      _canResend = false;
      _resendSeconds = 60;
    });

    // Simulate OTP resend
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP sent successfully'),
          backgroundColor: AppColors.success,
        ),
      );
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            // Icon
            _buildIcon(),
            const SizedBox(height: 24),

            // Title and subtitle
            _buildTitle(),
            const SizedBox(height: 40),

            // OTP Input
            _buildPinput(),
            const SizedBox(height: 32),

            // Verify button
            _buildVerifyButton(),
            const SizedBox(height: 24),

            // Resend section
            _buildResendSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.sms_rounded,
            size: 40,
            color: AppColors.primary,
          ),
        )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          duration: AnimationConstants.normal,
          curve: Curves.elasticOut,
        )
        .fadeIn();
  }

  Widget _buildTitle() {
    return Column(
          children: [
            Text(
              'OTP Verification',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'An OTP has been sent to the customer\'s phone.\nAsk them for the 4-digit code.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 100.ms)
        .slideY(begin: 0.1, duration: AnimationConstants.normal);
  }

  Widget _buildPinput() {
    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
    );

    return Center(
          child: Pinput(
            length: 4,
            controller: _pinController,
            focusNode: _focusNode,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            keyboardType: TextInputType.number,
            showCursor: true,
            cursor: _buildCursor(),
            onCompleted: (_) => _verifyOtp(),
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms)
        .slideY(begin: 0.1, duration: AnimationConstants.normal);
  }

  Widget _buildCursor() {
    return Container(
      width: 2,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return GradientButton(
          text: 'Verify OTP',
          isLoading: _isLoading,
          onPressed: _verifyOtp,
        )
        .animate()
        .fadeIn(delay: 300.ms)
        .slideY(begin: 0.1, duration: AnimationConstants.normal);
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        Text(
          "Didn't receive the code?",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        if (_canResend)
          TextButton(
            onPressed: _resendOtp,
            child: Text(
              'Resend OTP',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          )
        else
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Resend in ${_resendSeconds}s',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: AppColors.grey200),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }
}
