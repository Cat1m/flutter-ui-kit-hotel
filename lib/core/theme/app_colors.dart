// app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===== BRAND PALETTE (4 màu đề xuất cho Hotel Booking) =====
  // Primary (brand): Teal sâu – tạo cảm giác thư thái, tin cậy
  static const Color primarySea = Color(0xFF047A96);
  static const Color primarySeaLight = Color(0xFF58C6D4);
  static const Color primarySeaDark = Color(0xFF005E6A);

  // Secondary (accent phụ): Sky pastel – nhấn nhẹ cho nút/link phụ
  static const Color secondarySky = Color(0xFFADC2EC);
  static const Color secondarySkyLight = Color(0xFFDDE7FF);
  static const Color secondarySkyDark = Color(0xFF6B8BC4);

  // Neutral background: Ivory – nền ấm, dễ đọc nội dung
  static const Color neutralIvory = Color(0xFFEFE7D3);
  // Biến thể dùng cho bề mặt (card/list) hơi khác nền để tách lớp
  static const Color surfaceIvoryVariant = Color(0xFFF3EEE3);

  // Highlight / CTA: Gold nhạt – tạo điểm nhấn “Đặt phòng ngay”
  static const Color accentGold = Color(0xFFF3CD87);
  static const Color accentGoldContainer = Color(0xFFFFF1D3);

  // ===== NEUTRALS (giữ lại để dùng chung outline/divider/text) =====
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color neutral10 = Color(0xFFFAFAFA);
  static const Color neutral20 = Color(0xFFF5F5F5);
  static const Color neutral30 = Color(0xFFEEEEEE);
  static const Color neutral40 = Color(0xFFE0E0E0);
  static const Color neutral50 = Color(0xFFBDBDBD);
  static const Color neutral60 = Color(0xFF9E9E9E);
  static const Color neutral70 = Color(0xFF757575);
  static const Color neutral80 = Color(0xFF424242);
  static const Color neutral90 = Color(0xFF212121);
  static const Color neutral100 = black;

  // ===== SEMANTIC (giữ như cũ) =====
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // ===== LIGHT THEME ROLES (đi theo palette mới) =====
  static const Color backgroundLight = neutralIvory; // nền chính
  static const Color surface = white; // bề mặt card/list
  static const Color surfaceVariant = surfaceIvoryVariant;
  static const Color outline = Color(0xFF7B756A); // outline ấm (warm gray)
  static const Color onSurface = Color(0xFF1F1B16);
  static const Color onSurfaceVariant = Color(0xFF4B463F);
  static const Color onPrimary = white; // chữ trên primary teal
  static const Color inverseSurface = Color(0xFF35312B);
  static const Color inverseOnSurface = Color(0xFFFBEEE0);

  // ===== DARK THEME ROLES =====
  static const Color backgroundDark = Color(0xFF101114);
  static const Color surfaceDark = Color(0xFF1D1B20);
  static const Color surfaceVariantDark = Color(0xFF49454F);
  static const Color outlineDark = Color(0xFF938F99);
  static const Color onSurfaceDark = Color(0xFFE6E0E9);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);
  static const Color onPrimaryDark =
      black; // primaryLight đủ sáng → dùng text đen để tăng contrast

  // ===== LIGHT COLOR SCHEME =====
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primarySea,
    onPrimary: onPrimary,
    primaryContainer: Color(0xFFBEEAF1),
    onPrimaryContainer: Color(0xFF001F25),
    secondary: secondarySky,
    onSecondary: Color(0xFF102A56),
    secondaryContainer: secondarySkyLight,
    onSecondaryContainer: Color(0xFF0E2040),
    tertiary: accentGold,
    onTertiary: Color(0xFF3A2A00),
    tertiaryContainer: accentGoldContainer,
    onTertiaryContainer: Color(0xFF231A00),
    error: error,
    onError: onPrimary,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: surface,
    onSurface: onSurface,
    surfaceContainerHighest: surfaceVariant,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: Color(0xFFCFC6B8),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: inverseSurface,
    onInverseSurface: inverseOnSurface,
    inversePrimary: Color(0xFF95D7E2),
    surfaceTint: primarySea,
  );

  // ===== DARK COLOR SCHEME =====
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primarySeaLight,
    onPrimary: onPrimaryDark,
    primaryContainer: primarySeaDark,
    onPrimaryContainer: Color(0xFFBEEAF1),
    secondary: Color(0xFFBFD0F5),
    onSecondary: Color(0xFF14294E),
    secondaryContainer: Color(0xFF3E5A92),
    onSecondaryContainer: Color(0xFFDDE7FF),
    tertiary: Color(0xFFF6D79D),
    onTertiary: Color(0xFF3A2A00),
    tertiaryContainer: Color(0xFF5A4200),
    onTertiaryContainer: Color(0xFFFFE9B3),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: surfaceDark,
    onSurface: onSurfaceDark,
    surfaceContainerHighest: surfaceVariantDark,
    onSurfaceVariant: onSurfaceVariantDark,
    outline: outlineDark,
    outlineVariant: Color(0xFF49454F),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E0E9),
    onInverseSurface: Color(0xFF322F35),
    inversePrimary: primarySea,
    surfaceTint: primarySeaLight,
  );

  // ===== GRADIENTS (theo primary mới) =====
  static const Gradient primaryGradient = LinearGradient(
    colors: [primarySea, primarySeaDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient successGradient = LinearGradient(
    colors: [success, successDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient infoGradient = LinearGradient(
    colors: [info, infoDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== Backward-compat aliases (để code cũ không vỡ) =====
  @Deprecated('Đổi sang AppColors.primarySea')
  static const Color primaryRed = primarySea;
  @Deprecated('Đổi sang AppColors.primarySeaLight')
  static const Color primaryRedLight = primarySeaLight;
  @Deprecated('Đổi sang AppColors.primarySeaDark')
  static const Color primaryRedDark = primarySeaDark;

  @Deprecated('Đổi sang AppColors.secondarySky')
  static const Color secondaryBlue = secondarySky;
  @Deprecated('Đổi sang AppColors.secondarySkyLight')
  static const Color secondaryBlueLight = secondarySkyLight;
  @Deprecated('Đổi sang AppColors.secondarySkyDark')
  static const Color secondaryBlueDark = secondarySkyDark;
}
