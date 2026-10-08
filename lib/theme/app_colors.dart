import 'package:flutter/material.dart';

/// Paleta "Obsidian Hearth" — traducida 1:1 desde DESIGN.md
/// Estética OLED oscura con acentos de fuego (amber) + cyan + esmeralda.
class AppColors {
  AppColors._();

  // ─── Canvas & Surfaces (Surface 0 → 2) ──────────────────────
  /// Surface 0 — Base background plane (OLED black-slate)
  static const Color surfaceCanvas = Color(0xFF0B1326);

  /// Variante "dim" del canvas, para fondos hundidos
  static const Color surfaceDim = Color(0xFF0B1326);

  /// Surface bright — Slate elevado con más luz
  static const Color surfaceBright = Color(0xFF31394D);

  /// Surface 1 — Card & Module Base (backed por hairline border)
  static const Color surfaceCard = Color(0xFF131B2E);

  /// Alias semántico del container-low
  static const Color surfaceContainerLowest = Color(0xFF060E20);
  static const Color surfaceContainerLow = Color(0xFF131B2E);
  static const Color surfaceContainer = Color(0xFF171F33);

  /// Surface 2 — Floating Popovers, Modals, Inputs insets
  static const Color surfaceContainerHigh = Color(0xFF222A3D);
  static const Color surfaceContainerHighest = Color(0xFF2D3449);

  /// Borde hairline para cards (rgba blanco 7%)
  static const Color surfaceBorder = Color(0x12FFFFFF);

  /// Variante "surface-variant" para chips inactivos
  static const Color surfaceVariant = Color(0xFF2D3449);

  // ─── Brand — Heat / Flame (Primary) ─────────────────────────
  /// Primary — Amber glow (timer, urgencia, acciones clave)
  static const Color primary = Color(0xFFFFB690);
  static const Color primaryContainer = Color(0xFFF97316);
  static const Color primaryFixed = Color(0xFFFFDBCA); // chip tint
  static const Color primaryFixedDim = Color(0xFFFFB690);
  static const Color onPrimary = Color(0xFF552100);
  static const Color onPrimaryContainer = Color(0xFF582200);
  static const Color onPrimaryFixed = Color(0xFF341100);
  static const Color onPrimaryFixedVariant = Color(0xFF783200);
  static const Color inversePrimary = Color(0xFF9D4300);

  /// Alias semántico para botones urgentes / pressed (hover)
  static const Color primaryDark = Color(0xFFFB923C);

  // ─── Secondary — Electric Sky Cyan ──────────────────────────
  /// Cyan dedicado a checklists, progress pasivo, temperature probe
  static const Color secondary = Color(0xFF7BD0FF);
  static const Color secondaryContainer = Color(0xFF00A6E0);
  static const Color secondaryFixed = Color(0xFFC4E7FF);
  static const Color secondaryFixedDim = Color(0xFF7BD0FF);
  static const Color onSecondary = Color(0xFF00354A);
  static const Color onSecondaryContainer = Color(0xFF00374D);
  static const Color onSecondaryFixed = Color(0xFF001E2C);
  static const Color onSecondaryFixedVariant = Color(0xFF004C69);

  // ─── Tertiary — Luminous Emerald ────────────────────────────
  /// Verde reservado a estados "completado / listo / seguro"
  static const Color tertiary = Color(0xFF4EDEA3);
  static const Color tertiaryContainer = Color(0xFF00B07A);
  static const Color tertiaryFixed = Color(0xFF6FFBBE);
  static const Color tertiaryFixedDim = Color(0xFF4EDEA3);
  static const Color onTertiary = Color(0xFF003824);
  static const Color onTertiaryContainer = Color(0xFF003B26);
  static const Color onTertiaryFixed = Color(0xFF002113);
  static const Color onTertiaryFixedVariant = Color(0xFF005236);

  // ─── Error ──────────────────────────────────────────────────
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // ─── Text & Icons Hierarchy ────────────────────────────────
  /// Headings — high-purity
  static const Color textPrimary = Color(0xFFDAE2FD);
  /// Supporting copy — mid slate
  static const Color textSecondary = Color(0xFFCBD5E1);
  /// Muted — lowest emphasis (line-through, hints)
  static const Color textTertiary = Color(0xFF94A3B8);

  // ─── Outline ────────────────────────────────────────────────
  static const Color outline = Color(0xFFA78B7D);
  static const Color outlineVariant = Color(0xFF584237);

  // ─── Extra (para chips y badges semánticos) ────────────────
  /// Amarillo cálido para fases "final 60s" (F97316 → FFB703)
  static const Color amberWarm = Color(0xFFFFB703);

  // ─── Scrim (backdrop de bottom sheets) ─────────────────────
  /// rgba(2, 6, 23, 0.55) → negro azulado profundo
  static const Color scrim = Color(0x8C020617);
}