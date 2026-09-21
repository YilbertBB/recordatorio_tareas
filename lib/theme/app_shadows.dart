import 'package:flutter/material.dart';
import 'app_colors.dart';

/// "Tactile Tonal Layers" — sombras cálidas, no agresivas.
class AppShadows {
  AppShadows._();

  /// Layer 1: Cards & Inset Rails
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A1E1E24), // rgba(30,30,36,0.04)
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0DE85D04), // rgba(232,93,4,0.05)
      blurRadius: 16,
      offset: Offset(0, 6),
      spreadRadius: -4,
    ),
  ];

  /// Layer 2: FABs & Active Timers (halo cálido)
  static const List<BoxShadow> primaryHalo = [
    BoxShadow(
      color: Color(0x47E85D04), // rgba(232,93,4,0.28)
      blurRadius: 20,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  /// Layer 3: Bottom Sheets
  static const List<BoxShadow> sheet = [
    BoxShadow(
      color: Color(0x141E1E24), // rgba(30,30,36,0.08)
      blurRadius: 32,
      offset: Offset(0, -8),
    ),
  ];

  /// Nav bar bottom
  static const List<BoxShadow> navBar = [
    BoxShadow(color: Color(0x0D1E1E24), blurRadius: 20, offset: Offset(0, -4)),
  ];

  /// Hairline superior del sheet
  static const Border sheetHairline = Border(
    top: BorderSide(color: Color(0xCCFFFFFF), width: 0.8),
  );

  /// Card border
  static const Border cardBorder = Border.fromBorderSide(
    BorderSide(color: AppColors.surfaceBorder, width: 1),
  );

  /// Hero timer border
  static const Border heroBorder = Border.fromBorderSide(
    BorderSide(color: Color(0x66E85D04), width: 1.5),
  );
}
