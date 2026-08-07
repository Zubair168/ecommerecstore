# Screen Inventory

This document details all 54 mobile screens identified from the Online Shop Figma Community UI Kit. Every screen is mapped with its primary purpose, UI components, interactive elements, navigation targets, and overlay behaviors.

Screen screenshots are saved inside `Ecommerce App/` with standardized filenames.

---

## 1. Authentication & Onboarding Flow

### 1.1 Splash Screen
- **Screenshot**: `Ecommerce App/01_splash.png`
- **Purpose**: App launch & initial splash screen displaying brand logo.
- **Main UI Sections**: Centered Brand Logo (`Online Shop` with shopping bag vector).
- **Buttons**: N/A (auto-navigates).
- **Text Fields**: N/A.
- **Lists / Cards**: N/A.
- **Navigation Destination**: Landing Screen 1 (Onboarding 1).
- **Bottom Navigation**: Hidden.
- **Overlays**: None.

### 1.2 Landing Screen 1 (Onboarding 1)
- **Screenshot**: `Ecommerce App/02_onboarding_1.png`
- **Purpose**: Introduce key shopping feature (Browse products & special offers).
- **Main UI Sections**: Illustration graphic, Page indicator dot 1/3, Title & Subtitle.
- **Buttons**: `Next` (Primary Action), `Skip` (Header Text Button).
- **Text Fields**: N/A.
- **Navigation Destination**: Landing Screen 2 (`03_onboarding_2.png`).
- **Bottom Navigation**: Hidden.

### 1.3 Landing Screen 2 (Onboarding 2)
- **Screenshot**: `Ecommerce App/03_onboarding_2.png`
- **Purpose**: Highlight fast & reliable delivery system.
- **Main UI Sections**: Delivery illustration, Page indicator dot 2/3, Title & Subtitle.
- **Buttons**: `Next` (Primary), `Skip` (Header).
- **Navigation Destination**: Landing Screen 3 (`04_onboarding_3.png`).
- **Bottom Navigation**: Hidden.

### 1.4 Landing Screen 3 (Onboarding 3)
- **Screenshot**: `Ecommerce App/04_onboarding_3.png`
- **Purpose**: Highlight secure payment & seamless checkout.
- **Main UI Sections**: Payment illustration, Page indicator dot 3/3, Title & Subtitle.
- **Buttons**: `Get Started` (Primary Action), `Skip` (Header).
- **Navigation Destination**: Signin Screen (`05_login.png`).
- **Bottom Navigation**: Hidden.

### 1.5 Signin (Login)
- **Screenshot**: `Ecommerce App/05_login.png`
- **Purpose**: Authenticate returning user via email/password or social auth.
- **Main UI Sections**: Brand header, Input form, Social Sign-In section, Signup link.
- **Buttons**: `Sign In` (Primary), `Forgot Password?` (Text Button), `Google Sign In` (Icon Button), `Apple Sign In` (Icon Button), `Sign Up` (Text Link).
- **Text Fields**: Email address input (with email icon), Password input (with lock icon & toggle visibility).
- **Navigation Destination**: Homescreen (`16_home.png`), Forgot Password (`07_forgot_password_1.png`), Signup (`06_register.png`).
- **Bottom Navigation**: Hidden.

### 1.6 Signup (Register)
- **Screenshot**: `Ecommerce App/06_register.png`
- **Purpose**: Create a new account with full user credentials.
- **Main UI Sections**: Form header, Account Input fields, Terms agreement checkbox, Social signup.
- **Buttons**: `Sign Up` (Primary), `Google`, `Apple`, `Sign In` (Text Link).
- **Text Fields**: Full Name, Email Address, Password, Confirm Password.
- **Navigation Destination**: Setup Profile (`14_setup_profile.png`) or Homescreen (`16_home.png`).
- **Bottom Navigation**: Hidden.

### 1.7 Forgot Password Flow (1-4)
- **Screenshots**: `Ecommerce App/07_forgot_password_1.png` to `10_forgot_password_4.png`
- **Purpose**: Password recovery via email verification and 4-digit OTP code entry.
- **Main UI Sections**: Delivery method selection (Email / SMS), OTP 4-digit code entry boxes, Timer count, Success confirmation modal.
- **Buttons**: `Send Code`, `Verify OTP`, `Resend Code`, `Continue`.
- **Text Fields**: Email / Phone input, 4-digit square pin fields.
- **Navigation Destination**: Change Password (`11_change_password_1.png`).
- **Bottom Navigation**: Hidden.

### 1.8 Change Password (1-2) & Wrong Password Alert
- **Screenshots**: `Ecommerce App/11_change_password_1.png`, `12_change_password_2.png`, `13_wrong_password.png`
- **Purpose**: Reset password with validation and display error states for invalid inputs.
- **Main UI Sections**: New Password & Confirm Password input fields, Password requirement checklist, Error alert toast/banner.
- **Buttons**: `Reset Password`, `Back to Login`.
- **Text Fields**: Password input, Confirm password input.
- **Navigation Destination**: Signin Screen (`05_login.png`).

### 1.9 Setup Profile & Edit Profile
- **Screenshots**: `Ecommerce App/14_setup_profile.png`, `15_edit_profile.png`
- **Purpose**: Configure initial profile picture, phone number, gender, address, and update profile metadata.
- **Main UI Sections**: Profile Picture avatar with camera overlay button, Information fields, Save button.
- **Buttons**: `Camera / Gallery Upload`, `Save Profile`, `Update`.
- **Text Fields**: Full Name, Phone Number, Gender Dropdown, Date of Birth.
- **Navigation Destination**: Homescreen (`16_home.png`).

---

## 2. Core Exploration & Product Discovery

### 2.1 Homescreen
- **Screenshot**: `Ecommerce App/16_home.png`
- **Purpose**: Main landing view with banners, categories, flash sales, and top products.
- **Main UI Sections**:
  - Top Bar: Search input field, Notification bell icon badge, Location indicator.
  - Promo Banner Carousel: 50% Off sale graphic slider.
  - Category Scroll List: Electronics, Fashion, Beauty, Furniture, Sports.
  - Flash Sale Section: Countdown timer, Horizontal product list.
  - Popular Products Grid: 2-column product card layout with image, price, rating, wishlist heart.
- **Buttons**: Category Chips, `See All` text links, Product Card touchable, Wishlist Heart toggle.
- **Text Fields**: Header Search input.
- **Lists / Cards**: Horizontal Category ListView, Horizontal Flash Sale Cards, Vertical Grid Product Layout.
- **Navigation Destination**: Category (`17_category.png`), Product Details (`20_product_details_1.png`), Search (`24_search.png`).
- **Bottom Navigation**: Active (`Home` tab selected).

### 2.2 Category Screen
- **Screenshot**: `Ecommerce App/17_category.png`
- **Purpose**: Grid and list view of all product categories and sub-categories.
- **Main UI Sections**: Search header, Category grid tiles with custom icons and item counts.
- **Lists / Cards**: 2-column Category Card Grid.
- **Navigation Destination**: Product Grid View (`18_product_grid_view.png`).
- **Bottom Navigation**: Active (`Home` / `Categories`).

### 2.3 Product Grid View & Product List View
- **Screenshots**: `Ecommerce App/18_product_grid_view.png`, `19_product_list_view.png`
- **Purpose**: Filtered listing of products in either 2-column Grid layout or 1-column List layout.
- **Main UI Sections**: Filter bar (Layout Toggle Grid/List, Sort dropdown, Filter button), Item list, Stock status badges.
- **Buttons**: Grid/List layout toggle, Filter button, Wishlist toggle, Add to Cart quick button.
- **Navigation Destination**: Product Details (`20_product_details_1.png`), Filter Modal (`23_filter.png`).
- **Bottom Navigation**: Active.

### 2.4 Product Details (1-2)
- **Screenshots**: `Ecommerce App/20_product_details_1.png`, `21_product_details_2.png`
- **Purpose**: Comprehensive product view with image gallery, color options, size selector, specifications, and reviews.
- **Main UI Sections**: Full-bleed Image Gallery with thumbnail dots, Title, Rating breakdown, Price, Color Chips, Size Chips, Description text, Customer Reviews preview, Action bar.
- **Buttons**: `Add to Cart` (Secondary), `Buy Now` (Primary), Color Selection Chips, Size Selection Chips, Wishlist Heart icon, Share button.
- **Navigation Destination**: Cart (`26_cart_1.png`), Reviews (`46_review.png`), Compare Products (`22_compare_products.png`).
- **Bottom Navigation**: Hidden (replaced by sticky Bottom Action Bar).

### 2.5 Compare Products & Search Filter
- **Screenshots**: `Ecommerce App/22_compare_products.png`, `23_filter.png`
- **Purpose**: Side-by-side product comparison and modal filter sheet for refinement.
- **Main UI Sections**:
  - Compare Products: Dual column spec comparison matrix (Price, Brand, Rating, Screen, Battery).
  - Filter Sheet: Price Range Dual Slider, Category Chips, Brand Checkboxes, Rating Filter Stars.
- **Buttons**: `Apply Filter`, `Reset Filter`, `Compare Now`.
- **Bottom Sheet**: Filter Modal Sheet.

### 2.6 Search Screen
- **Screenshot**: `Ecommerce App/24_search.png`
- **Purpose**: Instant search with recent search tags, popular query chips, and auto-complete results.
- **Main UI Sections**: Search input field with clear icon, Recent searches list with delete cross, Trending search chips.
- **Buttons**: Clear search `X`, Recent search item delete, Search tag chips.
- **Text Fields**: Search query input.
- **Navigation Destination**: Product Grid View (`18_product_grid_view.png`).

---

## 3. Cart, Checkout & Orders

### 3.1 Wishlist
- **Screenshot**: `Ecommerce App/25_wishlist.png`
- **Purpose**: Saved items list with quick add-to-cart and item removal.
- **Main UI Sections**: Header with count, 1-column Product Cards with remove button and `Add to Cart`.
- **Buttons**: `Add to Cart`, `Remove` (Trash icon).
- **Bottom Navigation**: Active (`Wishlist` tab selected).

### 3.2 Cart (1-2)
- **Screenshots**: `Ecommerce App/26_cart_1.png`, `27_cart_2.png`
- **Purpose**: Shopping cart overview, quantity modification, promo code application, and subtotal breakdown.
- **Main UI Sections**: Cart item tiles, Promo coupon input box, Order summary card (Subtotal, Tax, Shipping, Total), Bottom Checkout bar.
- **Buttons**: `Proceed to Checkout` (Primary), Quantity `+` / `-` Steppers, `Apply Coupon`, Delete item.
- **Text Fields**: Voucher / Promo Code input.
- **Bottom Navigation**: Active / Hidden when action bar visible.

### 3.3 Checkout & Shipping Address
- **Screenshots**: `Ecommerce App/28_checkout.png`, `29_shipping_address_1.png`, `30_shipping_address_2.png`, `31_add_new_address.png`
- **Purpose**: Select shipping address, add new address with map picker/form, select delivery speed.
- **Main UI Sections**: Address selection cards (Home / Office chips), Delivery method cards (UPS, FedEx, Express), Order item preview.
- **Buttons**: `Add New Address`, `Select Address`, `Continue to Payment`.
- **Text Fields**: Full Address, City, Postal Code, Country, Address Label (Home/Work).

### 3.4 Payment Method, Payment & Card Form
- **Screenshots**: `Ecommerce App/32_payment_method.png` to `35_payment_successful.png`
- **Purpose**: Payment option selection (Credit Card, PayPal, Apple Pay, COD), New Card input, and Order Success screen.
- **Main UI Sections**: Card graphic preview, Radio button payment selector, New card form, Success illustration checkmark.
- **Buttons**: `Pay Now`, `Add Card`, `Back to Home` (Success Screen), `Track Order`.
- **Text Fields**: Cardholder Name, Card Number, Expiry Date, CVV Code.
- **Dialog / Overlays**: Payment Success Modal Dialog.

### 3.5 Order Management & Tracking
- **Screenshots**: `Ecommerce App/36_order_details.png` to `45_order_return_2.png`
- **Purpose**: View order history, track shipment status timeline, submit cancel requests, and process returns.
- **Main UI Sections**: Segmented Tab Bar (`Active`, `Completed`, `Cancelled`), Order Cards with status badges, Shipment tracking vertical step timeline, Return request form with photo upload.
- **Buttons**: `Track Order`, `Cancel Order`, `Return Items`, `Write Review`, `Submit Request`.
- **Navigation Destination**: Review (`46_review.png`), Vendor Profile (`54_vendor_profile.png`).

---

## 4. User Profile, Settings & Communication

### 4.1 Review & Feedback
- **Screenshots**: `Ecommerce App/46_review.png`, `47_feedback.png`
- **Purpose**: Customer review breakdown with star ratings and feedback form.
- **Main UI Sections**: Rating summary (4.8 / 5.0 bar chart), Review Cards with user avatars, Feedback form with star selector and image upload.
- **Buttons**: `Submit Review`, `Helpful Like`, `Upload Photo`.
- **Text Fields**: Written Feedback text area.

### 4.2 Voucher & Notifications
- **Screenshots**: `Ecommerce App/48_voucher.png`, `49_notification.png`
- **Purpose**: Active promo vouchers list and notification inbox (Promos, Order Updates, System alerts).
- **Main UI Sections**: Coupon cards with copy code button, Notification tiles with icons and timestamp.
- **Buttons**: `Copy Code`, `Use Voucher`, Notification mark as read.

### 4.3 Chat & Customer Support
- **Screenshot**: `Ecommerce App/50_chat.png`
- **Purpose**: Direct messaging between buyer and seller/customer support.
- **Main UI Sections**: Top Seller bar, Message bubble list (Sent / Received), Bottom message input bar with attachment clip and send button.
- **Buttons**: Send message arrow, Attach file paperclip.
- **Text Fields**: Message input bar.

### 4.4 Settings, Terms & Language
- **Screenshots**: `Ecommerce App/51_settings.png` to `54_vendor_profile.png`
- **Purpose**: Profile configuration, app preferences, dark mode toggle, terms agreement, language picker, and vendor storefront.
- **Main UI Sections**: Profile summary card, Settings list items (Notifications, Security, Language, Dark Mode toggle), Radio button language list, Vendor banner & catalog.
- **Buttons**: Toggle Switches, Language Selection Radio, `Logout` button.
