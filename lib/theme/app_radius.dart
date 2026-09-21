import 'package:flutter/widgets.dart';

class AppRadius {
  AppRadius._();

  static const Radius sm = Radius.circular(4);
  static const Radius base = Radius.circular(8);
  static const Radius md = Radius.circular(12);
  static const Radius lg = Radius.circular(16);
  static const Radius xl = Radius.circular(24);

  static const BorderRadius brSm = BorderRadius.all(sm);
  static const BorderRadius brBase = BorderRadius.all(base);
  static const BorderRadius brMd = BorderRadius.all(md);
  static const BorderRadius brLg = BorderRadius.all(lg);
  static const BorderRadius brXl = BorderRadius.all(xl);
  static const BorderRadius brFull = BorderRadius.all(Radius.circular(9999));

  /// Sheet superior con esquinas redondeadas
  static const BorderRadius brSheetTop = BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );
}
