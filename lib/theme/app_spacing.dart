import 'package:flutter/material.dart';

/// Design system spacing & layout constants for Online Shop Flutter App
class AppSpacing {
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space80 = 80.0;
  static const double space100 = 100.0;

  // BorderRadius
  static final BorderRadius radiusSmall = BorderRadius.circular(8.0);
  static final BorderRadius radiusMedium = BorderRadius.circular(12.0);
  static final BorderRadius radiusLarge = BorderRadius.circular(16.0);
  static final BorderRadius radiusExtraLarge = BorderRadius.circular(24.0);
  static final BorderRadius radiusPill = BorderRadius.circular(100.0);

  // BoxShadows
  static const List<BoxShadow> shadowLow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowHigh = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 24.0,
      offset: Offset(0, 8),
    ),
  ];
}
