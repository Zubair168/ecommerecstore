# Spacing & Layout System

This document outlines the spacing tokens, grid system, padding, margins, border radii, elevations, and card layout dimensions extracted from the Online Shop Figma design.

---

## 1. Spatial Grid System

The design is built upon an **8pt Spatial Grid System** (with 4pt micro-spacing increments).

| Token Name | Pixel Value | Typical Application |
| :--- | :--- | :--- |
| `space4` | `4.0` | Micro spacing (icon-to-text gap, badge padding) |
| `space8` | `8.0` | Small gap (chip padding, rating stars spacing) |
| `space12` | `12.0` | Compact container padding, list item gaps |
| `space16` | `16.0` | Standard page horizontal padding, card content padding |
| `space20` | `20.0` | Section spacing, screen side margin on large screens |
| `space24` | `24.0` | Major section gap, header-to-content spacing |
| `space32` | `32.0` | Hero section spacing, top onboarding margin |
| `space40` | `40.0` | Modal top gap, splash screen padding |

---

## 2. Page & Section Margins

- **Screen Horizontal Margin**: `16.0` (or `20.0` for tablet/wide layouts)
- **Top Safe Area Gap**: `12.0` below standard Flutter `SafeArea`
- **Bottom Action Bar Margin**: `16.0` padding surrounding sticky action buttons
- **Section Vertical Gap**: `24.0` between distinct homepage blocks

---

## 3. Padding Standards

- **Buttons (Primary / Secondary)**:
  - Vertical Padding: `14.0` to `16.0`
  - Horizontal Padding: `24.0`
  - Fixed Button Height: `52.0`
- **Text Inputs (`CustomTextField`)**:
  - Vertical Content Padding: `14.0`
  - Horizontal Content Padding: `16.0`
- **Cards & List Items**:
  - Card Inner Padding: `12.0` to `16.0`
  - List Tile Content Padding: `12.0` horizontal, `8.0` vertical
- **Chips & Pills**:
  - Horizontal Padding: `16.0`
  - Vertical Padding: `8.0`

---

## 4. Border Radius Standards

| Token Name | Radius Value | Target UI Elements |
| :--- | :--- | :--- |
| `radiusSmall` | `8.0` | Input fields, small tags, quantity steppers |
| `radiusMedium` | `12.0` | Standard buttons, product cards, category tiles |
| `radiusLarge` | `16.0` | Modal sheets, promotional banners, order cards |
| `radiusExtraLarge` | `24.0` | Bottom sheet top corners, dialog popups |
| `radiusPill` | `100.0` | Fully rounded chips, avatars, badge counts |

---

## 5. Grid Layout Specifications

### Product 2-Column Grid (`ProductGrid`)
- **CrossAxisCount**: `2`
- **CrossAxisSpacing**: `16.0` (Horizontal gap between cards)
- **MainAxisSpacing**: `16.0` (Vertical gap between card rows)
- **ChildAspectRatio**: `0.68` (Width-to-height ratio accommodating image + details)

### Category Grid (`CategoryGrid`)
- **CrossAxisCount**: `4` (or `2` depending on view mode)
- **CrossAxisSpacing**: `12.0`
- **MainAxisSpacing**: `12.0`
- **ChildAspectRatio**: `0.90`

---

## 6. Elevation & Shadows

| Level | BoxShadow Properties | Target UI Elements |
| :--- | :--- | :--- |
| `elevationLow` | `BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))` | Product cards, search bar |
| `elevationMedium` | `BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))` | Floating action bar, dropdowns |
| `elevationHigh` | `BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8))` | Bottom sheets, dialog modals |

---

## 7. Flutter AppSpacing Utility Code

```dart
import 'package:flutter/material.dart';

class AppSpacing {
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;

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
```
