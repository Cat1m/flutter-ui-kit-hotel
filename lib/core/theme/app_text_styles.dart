import 'package:flutter/material.dart';
import 'package:flutter_ui_kit_hotel/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // ========= FONT FAMILY CONFIG =========
  static final String headingFont = GoogleFonts.playfairDisplay().fontFamily!;
  static final String bodyFont = GoogleFonts.poppins().fontFamily!;

  // ========= DISPLAY STYLES =========
  static const double _displayLargeSize = 57;
  static const double _displayMediumSize = 45;
  static const double _displaySmallSize = 36;

  static TextStyle get displayLarge => TextStyle(
        fontFamily: headingFont,
        fontSize: _displayLargeSize,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle get displayMedium => TextStyle(
        fontFamily: headingFont,
        fontSize: _displayMediumSize,
        fontWeight: FontWeight.w600,
        height: 1.16,
      );

  static TextStyle get displaySmall => TextStyle(
        fontFamily: headingFont,
        fontSize: _displaySmallSize,
        fontWeight: FontWeight.w600,
        height: 1.22,
      );

  // ========= HEADLINE STYLES =========
  static TextStyle get headlineLarge => TextStyle(
        fontFamily: headingFont,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontFamily: headingFont,
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 1.29,
      );

  static TextStyle get headlineSmall => TextStyle(
        fontFamily: headingFont,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.33,
      );

  // ========= TITLE STYLES =========
  static TextStyle get titleLarge => TextStyle(
        fontFamily: headingFont,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
      );

  static TextStyle get titleMedium => TextStyle(
        fontFamily: headingFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.50,
      );

  static TextStyle get titleSmall => TextStyle(
        fontFamily: headingFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // ========= BODY STYLES =========
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  // ========= LABEL STYLES =========
  static TextStyle get labelLarge => TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get labelMedium => TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  static TextStyle get labelSmall => TextStyle(
        fontFamily: bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );

  // ========= TEXT THEMES =========
  static TextTheme textTheme = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColors.onSurface),
    displayMedium: displayMedium.copyWith(color: AppColors.onSurface),
    displaySmall: displaySmall.copyWith(color: AppColors.onSurface),
    headlineLarge: headlineLarge.copyWith(color: AppColors.onSurface),
    headlineMedium: headlineMedium.copyWith(color: AppColors.onSurface),
    headlineSmall: headlineSmall.copyWith(color: AppColors.onSurface),
    titleLarge: titleLarge.copyWith(color: AppColors.onSurface),
    titleMedium: titleMedium.copyWith(color: AppColors.onSurface),
    titleSmall: titleSmall.copyWith(color: AppColors.onSurface),
    bodyLarge: bodyLarge.copyWith(color: AppColors.onSurface),
    bodyMedium: bodyMedium.copyWith(color: AppColors.onSurface),
    bodySmall: bodySmall.copyWith(color: AppColors.onSurfaceVariant),
    labelLarge: labelLarge.copyWith(color: AppColors.onSurface),
    labelMedium: labelMedium.copyWith(color: AppColors.onSurfaceVariant),
    labelSmall: labelSmall.copyWith(color: AppColors.onSurfaceVariant),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColors.onSurfaceDark),
    displayMedium: displayMedium.copyWith(color: AppColors.onSurfaceDark),
    displaySmall: displaySmall.copyWith(color: AppColors.onSurfaceDark),
    headlineLarge: headlineLarge.copyWith(color: AppColors.onSurfaceDark),
    headlineMedium: headlineMedium.copyWith(color: AppColors.onSurfaceDark),
    headlineSmall: headlineSmall.copyWith(color: AppColors.onSurfaceDark),
    titleLarge: titleLarge.copyWith(color: AppColors.onSurfaceDark),
    titleMedium: titleMedium.copyWith(color: AppColors.onSurfaceDark),
    titleSmall: titleSmall.copyWith(color: AppColors.onSurfaceDark),
    bodyLarge: bodyLarge.copyWith(color: AppColors.onSurfaceDark),
    bodyMedium: bodyMedium.copyWith(color: AppColors.onSurfaceDark),
    bodySmall: bodySmall.copyWith(color: AppColors.onSurfaceVariantDark),
    labelLarge: labelLarge.copyWith(color: AppColors.onSurfaceDark),
    labelMedium: labelMedium.copyWith(color: AppColors.onSurfaceVariantDark),
    labelSmall: labelSmall.copyWith(color: AppColors.onSurfaceVariantDark),
  );

  // ========= APP BAR =========
  static TextStyle get appBarTitle => TextStyle(
        fontFamily: headingFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );
}
