import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/animation_constants.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../providers/order_detail_provider.dart';

/// OTP Verification page with Pinput for prepaid orders
class OtpVerificationPage extends ConsumerStatefulWidget {
  final String orderId;
  final String? devOtp; // For dev mode testing

  const OtpVerificationPage({super.key, required this.orderId, this.devOtp});

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isLoading = false;
  bool _canResend = false;
  int _resendSeconds = 60;
  Timer? _timer;
  String? _devOtp;

  @override
  void initState() {
    super.initState();
    _devOtp = widget.devOtp;
    _startResendTimer();
    // Auto-focus the pin field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startResendTimer() {
    _timer?.cancel();
    _resendSeconds = 60;
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

    final notifier = ref.read(orderDetailProvider(widget.orderId).notifier);
    final response = await notifier.verifyOtp(_pinController.text);

    if (!mounted) return;

    if (response != null && response['success'] == true) {
      // OTP verified - now complete the delivery
      final completed = await notifier.completeDelivery();

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (completed) {
        HapticFeedback.mediumImpact();
        // Delivery completed - navigate to success page
        context.go('/order/${widget.orderId}/success');
      } else {
        // Failed to complete delivery
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'OTP verified but failed to complete delivery. Please try again.',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } else {
      // OTP verification failed
      setState(() => _isLoading = false);
      HapticFeedback.heavyImpact();
      _pinController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response?['message'] ?? 'Invalid OTP. Please try again.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    HapticFeedback.lightImpact();
    setState(() {
      _canResend = false;
    });

    final notifier = ref.read(orderDetailProvider(widget.orderId).notifier);
    final response = await notifier.sendOtp();

    if (!mounted) return;

    if (response != null && response['success'] == true) {
      // Update devOtp if available
      if (response['devOtp'] != null) {
        setState(() => _devOtp = response['devOtp'] as String?);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'OTP sent successfully'),
          backgroundColor: AppColors.success,
        ),
      );
      _startResendTimer();
    } else {
      setState(() => _canResend = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response?['message'] ?? 'Failed to send OTP. Please try again.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
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
            // Show devOtp hint in debug mode
            if (_devOtp != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(
                    AppColors.warning.r.toInt(),
                    AppColors.warning.g.toInt(),
                    AppColors.warning.b.toInt(),
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color.fromRGBO(
                      AppColors.warning.r.toInt(),
                      AppColors.warning.g.toInt(),
                      AppColors.warning.b.toInt(),
                      0.3,
                    ),
                  ),
                ),
                child: Text(
                  'Dev OTP: $_devOtp',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
