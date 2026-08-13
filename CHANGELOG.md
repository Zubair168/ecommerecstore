# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-08-13

### Added

#### Authentication
- Firebase Email/Password sign-up and login
- Google Sign-In integration
- Forgot Password (email reset) flow
- User profile setup screen after first login
- Firebase Auth session persistence

#### Product Catalogue
- Product listing with real-time Firestore streaming
- Product detail screen with image gallery and full description
- Product grid and category-based browsing screens
- Product search with Firestore prefix matching
- **Search debouncing** (300 ms) to reduce Firestore read costs
- Individual recent-search chip dismissal
- Auto-save searched terms to recent history
- Filter & Sort screen: category, sort order, price range, rating, brand
- Product comparison screen

#### Shopping Cart
- Add/remove/update quantity of cart items
- Persistent cart (SharedPreferences-backed CartProvider)
- Real-time cart item count badge on bottom navigation

#### Checkout & Orders
- Checkout screen with delivery address, notes, and payment selection
- Cash on Delivery (COD) option with $2.00 handling fee breakdown
- Credit Card payment method screen
- Payment success screen with animated confirmation
- My Orders screen: real-time Firestore stream + local fallback list
- Order Details screen with itemised order summary
- Track Order screen with step-by-step timeline view
- Cancel / Return request screens
- Voucher / discount code screen

#### Notifications
- Firebase Cloud Messaging (FCM) integration for push notifications
- In-app Notifications screen connected to real Firestore `notifications` collection
- Real order-confirmed notification created on checkout completion

#### User Profile & Settings
- Edit Profile screen (name, avatar upload)
- Shipping Address management
- App settings: notifications, language, dark mode toggle
- Wishlist screen with grid/list layout toggle
- Vendor Profile and Reviews screens
- Feedback submission screen
- Terms & Privacy screen

#### Firebase & Backend
- Firestore `products` collection with auto-seed on first launch
- Firestore `orders` collection for placed orders
- Firestore `notifications` collection for per-user alerts
- Firebase Cloud Functions (deploy-functions workflow)

#### UI / Design System
- Custom design system: `AppColors`, `AppTypography`, `AppSpacing`, `AppTheme`
- Consistent dark navy (`#1D2939`) accent throughout all screens
- Custom widgets: `PrimaryButton`, `SecondaryButton`, `ProductCard`,
  `CategoryChip`, `CustomSearchBar`, `CustomAppBar`, `QuantityStepper`,
  `RatingBar`, `ReviewCard`, `OrderCard`, `CartItemTile`
- Onboarding screen with animated slides
- Splash screen

### Changed
- Filter & Sort screen accent colour changed from orange to dark navy for visual consistency
- My Orders screen: safe `Map<String, dynamic>` conversion to prevent Firestore type-cast crashes

### Fixed
- `MainAxisAlignment.spaceBetween` typo in My Orders screen
- `AppColors.textDisabled` reference fix in Notifications screen
- `BoxConstraints` infinite-width layout exception on order action buttons
- Firestore `_Map<dynamic, dynamic>` cast crash when rendering order items

### Testing
- Unit tests for product search helper logic (`test/search_debounce_test.dart`)
- CI smoke test (`test/widget_test.dart`)
- GitHub Actions CI workflow (`.github/workflows/flutter_test.yml`) running on every push and pull request

### Infrastructure
- GitHub Actions: `flutter_test.yml` — automated `flutter test` on every push / PR
- GitHub Actions: `deploy-functions.yml` — automated Firebase Cloud Functions deployment on `main` push
- Semantic versioning adopted: `1.0.0+1`

---

## [Unreleased]

> Future improvements will be tracked here before the next release.
