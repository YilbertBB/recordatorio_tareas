import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  /// Tema OSCURO principal de la app (Obsidian Hearth).
  /// Mantengo el nombre `light()` para no romper imports existentes,
  /// pero puedes renombrarlo a `dark()` y actualizar el MaterialApp.
  static ThemeData light() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.surfaceCanvas,

      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,

        // Primary — Amber glow
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,

        // Secondary — Sky cyan
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,

        // Tertiary — Emerald
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,

        // Error
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,

        // Surfaces
        surface: AppColors.surfaceCanvas,
        onSurface: AppColors.textPrimary,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,

        // Outline
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,

        // Inverse (para snackbars, tooltips)
        inverseSurface: AppColors.textPrimary,
        onInverseSurface: AppColors.surfaceCanvas,
        inversePrimary: AppColors.inversePrimary,

        // Tint
        surfaceTint: AppColors.primary,
      ),

      textTheme: TextTheme(
        displayLarge: AppTypography.displayLg,
        displayMedium: AppTypography.displayLgMobile,
        headlineLarge: AppTypography.headlineLg,
        headlineMedium: AppTypography.headlineMd,
        headlineSmall: AppTypography.headlineSm,
        bodyLarge: AppTypography.bodyLg,
        bodyMedium: AppTypography.bodyMd,
        bodySmall: AppTypography.bodySm,
        labelLarge: AppTypography.labelLg,
        labelMedium: AppTypography.labelMd,
      ),

      splashFactory: InkRipple.splashFactory,

      // Bottom Sheets — fondo surface-2 oscuro con hairline superior
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        modalBarrierColor: AppColors.scrim,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brSheetTop),
      ),

      // Inputs — inset surface-0 con focus amber
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: AppTypography.bodyMd.copyWith(
          color: AppColors.textTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.brLg,
          borderSide: const BorderSide(color: Color(0xFF334155), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.brLg,
          borderSide: const BorderSide(color: Color(0xFF334155), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.brLg,
          borderSide: const BorderSide(color: Color(0xFFF97316), width: 1),
        ),
      ),

      // TextButton, IconButton, etc. heredan del colorScheme
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      dividerColor: AppColors.surfaceBorder,
    );
  }
}