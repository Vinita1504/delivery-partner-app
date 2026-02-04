import 'package:flutter/material.dart';

/// Animation constants for consistent micro-animations
class AnimationConstants {
  AnimationConstants._();

  // Durations
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Stagger delays for list animations
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const Duration staggerDelayLong = Duration(milliseconds: 100);

  // Curves
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOut;
  static const Curve sharpCurve = Curves.easeOut;

  // Scale values
  static const double pressedScale = 0.97;
  static const double hoverScale = 1.02;

  // Fade values
  static const double fadeStart = 0.0;
  static const double fadeEnd = 1.0;

  // Slide offsets
  static const Offset slideFromBottom = Offset(0, 20);
  static const Offset slideFromTop = Offset(0, -20);
  static const Offset slideFromLeft = Offset(-20, 0);
  static const Offset slideFromRight = Offset(20, 0);
}

/// Common animation configurations
class AnimationConfig {
  AnimationConfig._();

  // Page entrance
  static Duration get pageEntranceDuration => AnimationConstants.normal;
  static Curve get pageEntranceCurve => AnimationConstants.defaultCurve;

  // List item stagger
  static Duration get listItemDuration => AnimationConstants.normal;
  static Duration get listItemDelay => AnimationConstants.staggerDelay;
  static Curve get listItemCurve => AnimationConstants.defaultCurve;

  // Button press
  static Duration get buttonPressDuration => AnimationConstants.fast;
  static Curve get buttonPressCurve => AnimationConstants.sharpCurve;

  // Card tap
  static Duration get cardTapDuration => AnimationConstants.fast;
  static double get cardTapScale => AnimationConstants.pressedScale;
}
