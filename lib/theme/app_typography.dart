import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tipografía — Plus Jakarta Sans + JetBrains Mono
class AppTypography {
  AppTypography._();

  static const String _jakarta = 'PlusJakartaSans';
  static const String _mono = 'JetBrainsMono';

  // ─── Displays ───────────────────────────────────────────────
  static const TextStyle displayLg = TextStyle(
    fontFamily: _jakarta,
    fontSize: 44,
    fontWeight: FontWeight.w700,
    height: 52 / 44,
    letterSpacing: -0.02,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayLgMobile = TextStyle(
    fontFamily: _jakarta,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -0.02,
    color: AppColors.textPrimary,
  );

  // ─── Timer ──────────────────────────────────────────────────
  static const TextStyle timerDisplay = TextStyle(
    fontFamily: _mono,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 60 / 56,
    letterSpacing: -0.03,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle timerDisplayMobile = TextStyle(
    fontFamily: _mono,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 46 / 40,
    letterSpacing: -0.03,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ─── Headlines ──────────────────────────────────────────────
  static const TextStyle headlineLg = TextStyle(
    fontFamily: _jakarta,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 34 / 28,
    letterSpacing: -0.015,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: _jakarta,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 28 / 22,
    letterSpacing: -0.01,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: _jakarta,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: AppColors.textPrimary,
  );

  // ─── Body ───────────────────────────────────────────────────
  static const TextStyle bodyLg = TextStyle(
    fontFamily: _jakarta,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: _jakarta,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: _jakarta,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.textPrimary,
  );

  // ─── Labels ─────────────────────────────────────────────────
  static const TextStyle labelLg = TextStyle(
    fontFamily: _mono,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 18 / 13,
    letterSpacing: 0.02,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: _mono,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 14 / 11,
    letterSpacing: 0.04,
    color: AppColors.textSecondary,
  );
}
