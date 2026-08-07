# Color System

This document specifies every color token used across the Online Shop Figma design, formatted for Flutter implementation.

---

## 1. Color Palette Tokens

| Category | Token Name | HEX Code | Color Preview / Description | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Primary** | `primary` | `#FF5722` | Vibrant Coral / Deep Orange | Main action buttons, active tab indicators, selected radio buttons |
| | `primaryHover` | `#F04438` | Dark Coral Red | Button hover/pressed states |
| | `primarySoft` | `#FFF4F2` | Soft Orange Tint | Active selection background, pill chip fill |
| **Secondary**| `secondary` | `#1D2939` | Dark Slate / Charcoal | Header titles, dark action buttons, contrast elements |
| | `secondaryLight` | `#344054` | Medium Slate | Subtitles, icon fills |
| **Accent** | `starRating` | `#FDB022` | Warm Gold / Yellow | Star rating filled icon |
| | `accentBlue` | `#2E90FA` | Electric Blue | Info badges, order status tags |
| **Success** | `success` | `#12B76A` | Emerald Green | Order confirmed, payment success icon, stock available |
| | `successBg` | `#ECFDF3` | Light Mint Green | Success banner & tag background |
| **Error** | `error` | `#F04438` | Bright Crimson Red | Error toast, delete item button, discount tag, order cancelled |
| | `errorBg` | `#FEF3F2` | Light Red Tint | Error banner & invalid field background |
| **Warning** | `warning` | `#F79009` | Warm Amber / Orange | Pending order, countdown timer tag |
| | `warningBg` | `#FEF0C7` | Soft Amber Tint | Pending banner background |
| **Background**| `background` | `#FFFFFF` | Pure White | Main screen background |
| | `backgroundAlt`| `#F9FAFB` | Cool Light Grey | Input field fill, card fill, secondary section background |
| **Surface** | `surface` | `#FFFFFF` | Card Surface White | Elevated cards, bottom sheets, dialog modals |
| | `surfaceDisabled`| `#F2F4F7` | Neutral Grey | Disabled button & input background |
| **Text** | `textPrimary` | `#101828` | Deep Charcoal Slate | High-emphasis body text, titles, headings |
| | `textSecondary`| `#667085` | Medium Cool Grey | Low-emphasis body text, captions, placeholder hints |
| | `textDisabled` | `#98A2B3` | Muted Grey | Disabled text labels |
| **Borders** | `border` | `#EAECF0` | Soft Light Grey | Card outlines, text field borders, list item dividers |
| | `borderActive` | `#FF5722` | Primary Coral | Focused input border, active card outline |
| **Dividers** | `divider` | `#E4E7EC` | Light Neutral Line | Horizontal section dividers, bottom bar top border |

---

## 2. Flutter Color Class Code

Below is the ready-to-use Flutter `AppColors` dart class for `lib/theme/app_colors.dart`:

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Secondary
  static const Color primary = Color(0xFFFF5722);
  static const Color primaryHover = Color(0xFFF04438);
  static const Color primarySoft = Color(0xFFFFF4F2);
  
  static const Color secondary = Color(0xFF1D2939);
  static const Color secondaryLight = Color(0xFF344054);

  // Accents & Badges
  static const Color starRating = Color(0xFFFDB022);
  static const Color accentBlue = Color(0xFF2E90FA);

  // Status & Feedback Colors
  static const Color success = Color(0xFF12B76A);
  static const Color successBg = Color(0xFFECFDF3);

  static const Color error = Color(0xFFF04438);
  static const Color errorBg = Color(0xFFFEF3F2);

  static const Color warning = Color(0xFFF79009);
  static const Color warningBg = Color(0xFFFEF0C7);

  // Background & Surface Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundAlt = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDisabled = Color(0xFFF2F4F7);

  // Typography Colors
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textDisabled = Color(0xFF98A2B3);

  // Borders & Dividers
  static const Color border = Color(0xFFEAECF0);
  static const Color borderActive = Color(0xFFFF5722);
  static const Color divider = Color(0xFFE4E7EC);
}
```
