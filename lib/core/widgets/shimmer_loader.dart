import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

/// Shimmer loading placeholder
class ShimmerLoader extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final Widget? child;

  const ShimmerLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.child,
  });

  factory ShimmerLoader.card({double? height}) => ShimmerLoader(
    width: double.infinity,
    height: height ?? 80,
    borderRadius: BorderRadius.circular(12),
  );

  factory ShimmerLoader.text({double? width}) => ShimmerLoader(
    width: width ?? 100,
    height: 14,
    borderRadius: BorderRadius.circular(4),
  );

  factory ShimmerLoader.circle({double size = 48}) => ShimmerLoader(
    width: size,
    height: size,
    borderRadius: BorderRadius.circular(size / 2),
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      child:
          child ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: borderRadius ?? BorderRadius.circular(4),
            ),
          ),
    );
  }
}

/// Order card shimmer skeleton
class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.grey200,
        highlightColor: AppColors.grey100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Address
            Container(
              width: double.infinity,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),

            // Bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  width: 50,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashboard stats shimmer skeleton
class DashboardStatsSkeleton extends StatelessWidget {
  const DashboardStatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      child: Row(
        children: [
          Expanded(child: _buildStatCard()),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard()),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard()),
        ],
      ),
    );
  }

  Widget _buildStatCard() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
