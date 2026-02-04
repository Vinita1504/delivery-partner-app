import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/animation_constants.dart';

/// Animated card with tap scale effect
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.border,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationConstants.fast,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: AnimationConstants.pressedScale).animate(
          CurvedAnimation(
            parent: _controller,
            curve: AnimationConstants.sharpCurve,
          ),
        );

    _elevationAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AnimationConstants.sharpCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shadow =
            widget.boxShadow ??
            [
              BoxShadow(
                color: AppColors.black.withValues(
                  alpha: 0.04 * _elevationAnimation.value,
                ),
                blurRadius: 12 * _elevationAnimation.value,
                offset: Offset(0, 4 * _elevationAnimation.value),
              ),
            ];

        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? AppColors.white,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              border: widget.border,
              boxShadow: shadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: widget.onTap != null ? _onTapDown : null,
                onTapUp: widget.onTap != null ? _onTapUp : null,
                onTapCancel: widget.onTap != null ? _onTapCancel : null,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Staggered list item wrapper for entrance animations
class StaggeredListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration? delay;
  final Duration? duration;

  const StaggeredListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final staggerDelay = delay ?? AnimationConstants.staggerDelay;
    final animDuration = duration ?? AnimationConstants.normal;

    return child
        .animate()
        .fadeIn(delay: staggerDelay * index, duration: animDuration)
        .slideY(
          begin: 0.1,
          delay: staggerDelay * index,
          duration: animDuration,
          curve: AnimationConstants.defaultCurve,
        );
  }
}
