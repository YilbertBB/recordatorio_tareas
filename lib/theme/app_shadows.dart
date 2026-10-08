import 'package:flutter/material.dart';
import 'app_colors.dart';

/// "Dark Luminous Stacking" — sombras sutiles + Amber Aura para urgencia.
/// En OLED el peso visual lo dan los halos de color, no las dropshadows.
class AppShadows {
  AppShadows._();

  /// Layer 1: Cards & Inset Rails
  /// Sombra prácticamente invisible sobre OLED; la jerarquía la da el border.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x33000000), // negro suave
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  /// Layer 2: The Amber Aura — FABs & Active Timers (urgencia alta)
  /// Dual-ring: inner border + diffuse blur (según DESIGN.md)
  static const List<BoxShadow> primaryHalo = [
    BoxShadow(
      color: Color(0x2EF97316), // rgba(249,115,22,0.18)
      blurRadius: 24,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
  ];

  /// Layer 2b: Cyan halo — para checklists resueltas / progress pasivo
  static const List<BoxShadow> cyanHalo = [
    BoxShadow(
      color: Color(0x2E38BDF8), // rgba(56,189,248,0.18)
      blurRadius: 24,
      offset: Offset.zero,
    ),
  ];

  /// Layer 2c: Emerald halo — para estados "listo / completado"
  static const List<BoxShadow> emeraldHalo = [
    BoxShadow(
      color: Color(0x2E10B981), // rgba(16,185,129,0.18)
      blurRadius: 24,
      offset: Offset.zero,
    ),
  ];

  /// Layer 3: Bottom Sheets — deep ambient drop sobre OLED
  static const List<BoxShadow> sheet = [
    BoxShadow(
      color: Color(0x66020617), // rgba(2,6,23,0.4)
      blurRadius: 32,
      offset: Offset(0, -8),
    ),
  ];

  /// Nav bar bottom — sutil elevación
  static const List<BoxShadow> navBar = [
    BoxShadow(
      color: Color(0x66020617),
      blurRadius: 24,
      offset: Offset(0, -4),
    ),
  ];

  /// Hairline superior del sheet (blanco translúcido)
  static const Border sheetHairline = Border(
    top: BorderSide(color: Color(0x14FFFFFF), width: 1),
  );

  /// Card border — hairline slate/blanco 7%
  static const Border cardBorder = Border.fromBorderSide(
    BorderSide(color: AppColors.surfaceBorder, width: 1),
  );

  /// Borde secundario — slate-700 para inputs / secondary buttons
  static const Border secondaryBorder = Border.fromBorderSide(
    BorderSide(color: Color(0xFF334155), width: 1),
  );

  /// Hero timer border — amber translúcido (1.5px, inner ring)
  static const Border heroBorder = Border.fromBorderSide(
    BorderSide(color: Color(0x66F97316), width: 1.5),
  );

  /// Border de inputs focus (amber ring)
  static const Border focusBorder = Border.fromBorderSide(
    BorderSide(color: Color(0xFFF97316), width: 1),
  );
}