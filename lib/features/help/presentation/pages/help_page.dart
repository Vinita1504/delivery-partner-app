import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/text_fields.dart';
import '../../../../core/widgets/animated_card.dart';
import '../../../../core/enums/enums.dart';

/// Help & Issue page - Report delivery-related issues with premium UI
class HelpPage extends StatefulWidget {
  final String? orderId;

  const HelpPage({super.key, this.orderId});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  IssueType? _selectedIssue;
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitIssue() async {
    if (_selectedIssue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an issue type')),
      );
      return;
    }

    if (_selectedIssue == IssueType.other &&
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your issue')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Implement actual issue submission
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Issue reported successfully. Support team will contact you shortly.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.orderId != null) ...[
              _buildOrderInfo(),
              const SizedBox(height: 24),
            ],

            Text(
              'What issue are you facing?',
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 16),

            // Issue options
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: IssueType.values.length,
              itemBuilder: (context, index) {
                final issue = IssueType.values[index];
                return _buildIssueOption(issue, index);
              },
            ),

            const SizedBox(height: 24),

            // Description field for "Other"
            if (_selectedIssue == IssueType.other) ...[
              Text(
                'Please describe the issue',
                style: AppTextStyles.labelLarge,
              ).animate().fadeIn(),
              const SizedBox(height: 8),

              AnimatedCard(
                child: CustomTextField(
                  label: '',
                  hint: 'Enter detailed description here...',
                  controller: _descriptionController,
                  maxLines: 4,
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
              const SizedBox(height: 24),
            ],

            GradientButton(
              text: 'Submit Issue',
              isLoading: _isLoading,
              onPressed: _submitIssue,
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

            const SizedBox(height: 24),
            _buildSupportContact(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reporting for Order',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '#${widget.orderId}',
                style: AppTextStyles.heading4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildIssueOption(IssueType issue, int index) {
    final isSelected = _selectedIssue == issue;

    return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnimatedCard(
            onTap: () => setState(() => _selectedIssue = issue),
            padding: const EdgeInsets.all(
              4,
            ), // Inner padding handled by container for border
            backgroundColor: isSelected
                ? AppColors.primary.withValues(alpha: 0.05)
                : AppColors.white,
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.grey100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getIssueIcon(issue),
                      color: isSelected ? AppColors.primary : AppColors.grey600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.displayName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        if (isSelected)
                          Text(
                            'Tap to select',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                    )
                  else
                    Icon(Icons.circle_outlined, color: AppColors.grey300),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 100 * index))
        .slideX(begin: 0.1);
  }

  Widget _buildSupportContact() {
    return Column(
      children: [
        Text(
          'Or contact support directly',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.phone_rounded, size: 18),
              label: const Text('Call Support'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
            Container(
              width: 1,
              height: 16,
              color: AppColors.grey300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.email_outlined, size: 18),
              label: const Text('Email Us'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  IconData _getIssueIcon(IssueType issue) {
    switch (issue) {
      case IssueType.customerNotAvailable:
        return Icons.person_off_outlined;
      case IssueType.otpNotReceived:
        return Icons.sms_failed_outlined;
      case IssueType.addressIssue:
        return Icons.location_off_outlined;
      case IssueType.paymentIssue:
        return Icons.payment_outlined;
      case IssueType.productDamaged:
        return Icons.broken_image_outlined;
      case IssueType.customerRefused:
        return Icons.block_outlined;
      case IssueType.other:
        return Icons.help_outline_rounded;
    }
  }
}
