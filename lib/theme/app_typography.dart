import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system typography definitions for Online Shop Flutter App
class AppTypography {
  static final String fontFamily = GoogleFonts.inter().fontFamily ?? 'Inter';

  static final TextTheme textTheme = TextTheme(
    // Display / Hero (32px Bold)
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      height: 40.0 / 32.0,
      letterSpacing: -0.5,
      color: const Color(0xFF101828),
    ),

    // Heading 1 (24px Bold)
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      height: 32.0 / 24.0,
      letterSpacing: -0.3,
      color: const Color(0xFF101828),
    ),

    // Heading 2 (20px SemiBold)
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      height: 28.0 / 20.0,
      letterSpacing: -0.2,
      color: const Color(0xFF101828),
    ),

    // Heading 3 (18px SemiBold)
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      height: 24.0 / 18.0,
      color: const Color(0xFF101828),
    ),

    // Body Large (16px Regular)
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 24.0 / 16.0,
      color: const Color(0xFF344054),
    ),

    // Body Medium (14px Regular)
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 20.0 / 14.0,
      color: const Color(0xFF475467),
    ),

    // Body Small / Caption (12px Regular)
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      height: 16.0 / 12.0,
      color: const Color(0xFF667085),
    ),

    // Button Text (16px Medium)
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      height: 24.0 / 16.0,
      color: Colors.white,
    ),

    // Chip & Badge Label (10px - 12px SemiBold)
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 10.0,
      fontWeight: FontWeight.w600,
      height: 14.0 / 10.0,
      letterSpacing: 0.5,
      color: const Color(0xFF344054),
    ),
  );
}
