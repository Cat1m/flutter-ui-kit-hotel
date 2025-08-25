import 'dart:ui';
import 'package:flutter/material.dart';

/// Custom spacing values
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  final double xs; // 4.0
  final double sm; // 8.0
  final double md; // 16.0
  final double lg; // 24.0
  final double xl; // 32.0
  final double xxl; // 48.0

  static const AppSpacing light = AppSpacing(
    xs: 4.0,
    sm: 8.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
    xxl: 48.0,
  );

  static const AppSpacing dark = AppSpacing(
    xs: 4.0,
    sm: 8.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
    xxl: 48.0,
  );

  @override
  AppSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t) ?? xs,
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
      xxl: lerpDouble(xxl, other.xxl, t) ?? xxl,
    );
  }
}

/// Custom elevation values
@immutable
class AppElevation extends ThemeExtension<AppElevation> {
  const AppElevation({
    required this.none,
    required this.low,
    required this.medium,
    required this.high,
    required this.veryHigh,
  });

  final double none; // 0.0
  final double low; // 2.0
  final double medium; // 4.0
  final double high; // 8.0
  final double veryHigh; // 16.0

  static const AppElevation light = AppElevation(
    none: 0.0,
    low: 2.0,
    medium: 4.0,
    high: 8.0,
    veryHigh: 16.0,
  );

  static const AppElevation dark = AppElevation(
    none: 0.0,
    low: 4.0,
    medium: 8.0,
    high: 12.0,
    veryHigh: 24.0,
  );

  @override
  AppElevation copyWith({
    double? none,
    double? low,
    double? medium,
    double? high,
    double? veryHigh,
  }) {
    return AppElevation(
      none: none ?? this.none,
      low: low ?? this.low,
      medium: medium ?? this.medium,
      high: high ?? this.high,
      veryHigh: veryHigh ?? this.veryHigh,
    );
  }

  @override
  AppElevation lerp(ThemeExtension<AppElevation>? other, double t) {
    if (other is! AppElevation) return this;
    return AppElevation(
      none: lerpDouble(none, other.none, t) ?? none,
      low: lerpDouble(low, other.low, t) ?? low,
      medium: lerpDouble(medium, other.medium, t) ?? medium,
      high: lerpDouble(high, other.high, t) ?? high,
      veryHigh: lerpDouble(veryHigh, other.veryHigh, t) ?? veryHigh,
    );
  }
}
