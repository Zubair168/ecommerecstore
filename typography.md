# Typography System

This document specifies the exact typography hierarchy, font styles, sizes, line heights, letter spacing, and Flutter `TextStyle` specifications derived from the Online Shop Figma design.

---

## 1. Font Family & Weight System

- **Primary Font Family**: `Inter` (Google Font)
- **Fallback Font Families**: `Outfit`, `Roboto`, `sans-serif`
- **Supported Font Weights**:
  - `Regular`: `FontWeight.w400`
  - `Medium`: `FontWeight.w500`
  - `SemiBold`: `FontWeight.w600`
  - `Bold`: `FontWeight.w700`

---

## 2. Text Style Hierarchy

| Style Name | Font Size | Font Weight | Line Height | Letter Spacing | Target Use Cases |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `Display / Hero` | `32.0` | `Bold (700)` | `40.0` (1.25) | `-0.5px` | Onboarding headlines, Splash title |
| `Heading 1` | `24.0` | `Bold (700)` | `32.0` (1.33) | `-0.3px` | Page titles, Modal headers |
| `Heading 2` | `20.0` | `SemiBold (600)` | `28.0` (1.40) | `-0.2px` | Section titles, Product detail title |
| `Heading 3` | `18.0` | `SemiBold (600)` | `24.0` (1.33) | `0.0px` | Card headers, Dialog titles |
| `Body Large` | `16.0` | `Regular (400)` | `24.0` (1.50) | `0.0px` | Main body paragraphs, Form inputs |
| `Body Large Medium` | `16.0` | `Medium (500)` | `24.0` (1.50) | `0.0px` | Button labels, Active input text |
| `Body Medium` | `14.0` | `Regular (400)` | `20.0` (1.43) | `0.0px` | Standard list text, Product info |
| `Body Medium Medium`| `14.0` | `Medium (500)` | `20.0` (1.43) | `0.0px` | Subtitles, Filter labels |
| `Body Medium SemiBold`| `14.0` | `SemiBold (600)` | `20.0` (1.43) | `0.0px` | Product price, Card titles |
| `Body Small` | `12.0` | `Regular (400)` | `16.0` (1.33) | `0.0px` | Captions, Timestamps, Muted labels |
| `Body Small Medium` | `12.0` | `Medium (500)` | `16.0` (1.33) | `0.0px` | Rating score, Category chip labels |
| `Caption / Badge` | `10.0` | `SemiBold (600)` | `14.0` (1.40) | `0.5px` | Discount badges, Icon notification counts |

---

## 3. Flutter `TextTheme` Implementation Code

Below is the complete Flutter `TextTheme` code snippet for `lib/theme/app_typography.dart`:

```dart
import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamily = 'Inter';

  static const TextTheme textTheme = TextTheme(
    // Display / Hero (32px Bold)
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      height: 40.0 / 32.0,
      letterSpacing: -0.5,
      color: Color(0xFF101828),
    ),

    // Heading 1 (24px Bold)
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      height: 32.0 / 24.0,
      letterSpacing: -0.3,
      color: Color(0xFF101828),
    ),

    // Heading 2 (20px SemiBold)
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      height: 28.0 / 20.0,
      letterSpacing: -0.2,
      color: Color(0xFF101828),
    ),

    // Heading 3 (18px SemiBold)
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      height: 24.0 / 18.0,
      color: Color(0xFF101828),
    ),

    // Body Large (16px Regular)
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 24.0 / 16.0,
      color: Color(0xFF344054),
    ),

    // Body Medium (14px Regular)
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 20.0 / 14.0,
      color: Color(0xFF475467),
    ),

    // Body Small / Caption (12px Regular)
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      height: 16.0 / 12.0,
      color: Color(0xFF667085),
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
      color: Color(0xFF344054),
    ),
  );
}
```
