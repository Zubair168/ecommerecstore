# Reusable Components Inventory

This document defines all 21 core reusable UI components from the Online Shop Figma design, providing exact visual specifications, props, states, and recommended Flutter implementation widget trees.

---

## 1. App Bar (`CustomAppBar`)
- **Visual Description**: Top header bar with trailing action icons and leading back arrow or logo.
- **Props**:
  - `String? title`
  - `Widget? leading` (Back button or menu)
  - `List<Widget>? actions` (Notification bell, search, wishlist)
  - `bool centerTitle` (Default: `true`)
  - `Color backgroundColor` (Default: `#FFFFFF`)
- **Flutter Implementation**: `AppBar` or custom `PreferredSizeWidget` container with `SizedBox(height: 56.0)`.

---

## 2. Search Bar (`CustomSearchBar`)
- **Visual Description**: Rounded search input container with search magnifying glass icon, placeholder text, and optional filter trailing icon button.
- **Props**:
  - `String hintText` (e.g., `"Search category, product..."`)
  - `VoidCallback? onTap`
  - `ValueChanged<String>? onChanged`
  - `VoidCallback? onFilterTap`
  - `bool readOnly` (Default: `false`)
- **States**: Default, Focused (Primary border color `#FF5722`), Filled.
- **Flutter Implementation**: `Container` with `BoxDecoration(color: Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12.0))` containing `TextField`.

---

## 3. Product Card (`ProductCard`)
- **Visual Description**: 2-column grid or list card featuring product image, brand/category label, title, current price, original strikethrough price, rating star with score, discount badge, and wishlist heart icon button.
- **Props**:
  - `String imageUrl`
  - `String title`
  - `double price`
  - `double? originalPrice`
  - `double rating`
  - `int reviewCount`
  - `bool isWishlisted`
  - `String? discountTag` (e.g., `"50% OFF"`)
  - `VoidCallback onTap`
  - `VoidCallback onWishlistTap`
- **Flutter Implementation**: `Card` / `Container` with rounded corners `16.0`, `Column` layout, `Stack` for discount badge & heart icon.

---

## 4. Category Card (`CategoryCard`)
- **Visual Description**: Compact tile displaying category graphic/icon inside a circular or rounded square background with category name below.
- **Props**:
  - `String title`
  - `String iconPath` (SVG asset)
  - `Color backgroundColor` (Soft accent tint)
  - `bool isSelected`
  - `VoidCallback onTap`
- **Flutter Implementation**: `GestureDetector` -> `Column(children: [Container(padding: 12, decoration: BoxDecoration(...)), Text(title)])`.

---

## 5. Promotional Banner (`PromoBanner`)
- **Visual Description**: Full-width hero banner slider showcasing special deals, bold call-to-action text, sale tag graphic, and background gradient.
- **Props**:
  - `String title` (e.g., `"50% OFF Special Sale"`)
  - `String subtitle`
  - `String buttonText`
  - `String imageAsset`
  - `VoidCallback onActionTap`
- **Flutter Implementation**: `Container` with gradient background `#FF5722` to `#FF7043`, `Row` layout containing text stack and promo graphic.

---

## 6. Cart Item Tile (`CartItemTile`)
- **Visual Description**: Horizontal list tile with product thumbnail, title, selected attribute (size/color), unit price, Quantity Stepper, and trash delete button.
- **Props**:
  - `String title`
  - `String attributes` (e.g., `"Color: Black, Size: L"`)
  - `double price`
  - `int quantity`
  - `ValueChanged<int> onQuantityChanged`
  - `VoidCallback onDelete`
- **Flutter Implementation**: `Container` with `#FFFFFF` background, border `#EAECF0`, `Row` layout containing image, info `Column`, and bottom quantity controller.

---

## 7. Quantity Stepper (`QuantityStepper`)
- **Visual Description**: Compact inline controller with minus button, current quantity integer, and plus button.
- **Props**:
  - `int value`
  - `int min` (Default: `1`)
  - `int max` (Default: `99`)
  - `ValueChanged<int> onChanged`
- **Flutter Implementation**: `Row` containing two circular/square `InkWell` containers with `SvgPicture.asset(icon_minus)` and `SvgPicture.asset(icon_plus)`.

---

## 8. Rating Widget (`RatingBar`)
- **Visual Description**: Inline 5-star indicator showing filled star icons, half stars, and numeric rating score text.
- **Props**:
  - `double rating` (e.g., `4.8`)
  - `int? maxStars` (Default: `5`)
  - `double iconSize` (Default: `16.0`)
  - `bool showScoreText`
- **Flutter Implementation**: `Row(children: [Row(...stars), Text('$rating')])`.

---

## 9. Review Card (`ReviewCard`)
- **Visual Description**: Customer review tile with reviewer user avatar, name, star rating score, date timestamp, written text review, attached review photos, and helpful like button.
- **Props**:
  - `String avatarUrl`
  - `String userName`
  - `double rating`
  - `String date`
  - `String comment`
  - `List<String>? reviewImages`
  - `int likesCount`
  - `VoidCallback onLikeTap`
- **Flutter Implementation**: `Container` with `#F9FAFB` fill, `Column` layout with user header, star rating, comment paragraph, and image grid.

---

## 10. Primary Button (`PrimaryButton`)
- **Visual Description**: Bold full-width button with vivid primary color fill (`#FF5722`), white text, rounded corners (`12.0` or pill `24.0`), and subtle elevation.
- **Props**:
  - `String text`
  - `VoidCallback? onPressed`
  - `bool isLoading`
  - `Widget? icon`
  - `double height` (Default: `52.0`)
- **States**: Enabled, Disabled (`#F2F4F7` background with `#98A2B3` text), Pressed/Focused, Loading (`CircularProgressIndicator`).
- **Flutter Implementation**: `ElevatedButton` or custom `InkWell` container.

---

## 11. Secondary Button (`SecondaryButton`)
- **Visual Description**: Outlined or soft filled button with primary text color, white background, and `#EAECF0` or `#FF5722` border outline.
- **Props**:
  - `String text`
  - `VoidCallback? onPressed`
  - `Widget? icon`
- **Flutter Implementation**: `OutlinedButton(style: OutlinedButton.styleFrom(side: BorderSide(color: Color(0xFFFF5722))))`.

---

## 12. Text Field (`CustomTextField`)
- **Visual Description**: Form input box with label header, placeholder hint, prefix icon, suffix icon (password toggle/clear), and error text.
- **Props**:
  - `String label`
  - `String hintText`
  - `TextEditingController? controller`
  - `bool obscureText`
  - `Widget? prefixIcon`
  - `Widget? suffixIcon`
  - `String? errorText`
- **States**: Normal, Focused (Orange border `#FF5722`), Error (Red border `#F04438`), Disabled.
- **Flutter Implementation**: `TextField` wrapped in `Column` with top `Text(label)`.

---

## 13. Chip & Tag (`CustomChip`)
- **Visual Description**: Compact pill container used for sizes, attributes, categories, and recent search tags.
- **Props**:
  - `String label`
  - `bool isSelected`
  - `VoidCallback onTap`
- **Flutter Implementation**: `ChoiceChip` or `Container` with `BorderRadius.circular(20.0)`.

---

## 14. Filter Chip (`FilterChipTile`)
- **Visual Description**: Selectable filter option chip with checkmark or border highlight when active.
- **Props**:
  - `String label`
  - `bool isSelected`
  - `ValueChanged<bool> onSelected`
- **Flutter Implementation**: `FilterChip`.

---

## 15. Bottom Navigation Bar (`CustomBottomNavBar`)
- **Visual Description**: Fixed bottom bar featuring 4 main tabs (`Home`, `Cart`, `Wishlist`, `Profile`) with active orange highlight (`#FF5722`), unselected muted grey icons (`#667085`), and badge notifications.
- **Props**:
  - `int currentIndex`
  - `ValueChanged<int> onTap`
  - `int cartBadgeCount`
- **Flutter Implementation**: `BottomNavigationBar` or custom `Container` `Row` with `InkWell` tabs.

---

## 16. Navigation Drawer / Side Menu (`CustomDrawer`)
- **Visual Description**: Sliding side panel displaying user avatar header, account navigation links, category quick links, settings, and logout option.
- **Props**:
  - `String userName`
  - `String userEmail`
  - `String avatarUrl`
  - `List<DrawerMenuItem> items`
- **Flutter Implementation**: `Drawer` with `UserAccountsDrawerHeader`.

---

## 17. Notification Badge (`BadgeWidget`)
- **Visual Description**: Small circular red count badge overlaid on top right of cart or notification bell icon.
- **Props**:
  - `int count`
  - `Widget child`
- **Flutter Implementation**: `Stack(children: [child, Positioned(right: 0, top: 0, child: CircleAvatar(...))])`.

---

## 18. Notification Tile (`NotificationTile`)
- **Visual Description**: List item displaying notification category icon, title, description body, and timestamp.
- **Props**:
  - `String title`
  - `String body`
  - `String timestamp`
  - `bool isUnread`
  - `String iconAsset`
- **Flutter Implementation**: `ListTile` with custom `#FFFFFF` / `#F9FAFB` background.

---

## 19. Order Card (`OrderCard`)
- **Visual Description**: Order summary card displaying order ID, date, item thumbnails preview, total price, status badge (`Pending`, `In Delivery`, `Completed`, `Cancelled`), and action buttons (`Track Order`, `Reorder`).
- **Props**:
  - `String orderId`
  - `String date`
  - `String status` (Enum)
  - `double totalPrice`
  - `int itemQuantity`
  - `VoidCallback onPrimaryAction`
- **Flutter Implementation**: `Card` with header status strip and bottom action buttons.

---

## 20. Shipping Address Card (`AddressCard`)
- **Visual Description**: Selectable address container displaying address type tag (`Home` / `Office`), recipient name, phone number, address text, and radio button selector.
- **Props**:
  - `String title` (e.g., `"Home Address"`)
  - `String recipientName`
  - `String phone`
  - `String addressLine`
  - `bool isSelected`
  - `VoidCallback onSelect`
  - `VoidCallback onEdit`
- **Flutter Implementation**: `Container` with radio button leading widget and edit icon button trailing.

---

## 21. Payment Method Card (`PaymentCardWidget`)
- **Visual Description**: Card item featuring payment brand logo (Visa, Mastercard, PayPal, Apple Pay, COD), masked card number / account details, and radio selector.
- **Props**:
  - `String brandName`
  - `String logoAsset`
  - `String lastFourDigits`
  - `bool isSelected`
  - `VoidCallback onTap`
- **Flutter Implementation**: `GestureDetector` -> `Container` with rounded border and radio button indicator.
