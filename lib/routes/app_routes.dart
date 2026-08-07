// lib/routes/app_routes.dart

/// Named route constants for the Online Shop app.
class AppRoutes {
  // Auth flow
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String setupProfile = '/setup-profile';

  // Main shell
  static const String home = '/home';
  static const String categories = '/categories';
  static const String search = '/search';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';

  // Products
  static const String productGrid = '/products';
  static const String productDetails = '/product-details';
  static const String compareProducts = '/compare';
  static const String filter = '/filter';
  static const String review = '/review';

  // Cart & Checkout
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String shippingAddress = '/shipping-address';
  static const String addAddress = '/add-address';
  static const String paymentMethod = '/payment-method';
  static const String addCard = '/add-card';
  static const String paymentSuccess = '/payment-success';

  // Orders
  static const String myOrders = '/my-orders';
  static const String orderDetails = '/order-details';
  static const String trackOrder = '/track-order';
  static const String cancelRequest = '/cancel-request';
  static const String returnRequest = '/return-request';

  // User & Settings
  static const String editProfile = '/edit-profile';
  static const String notifications = '/notifications';
  static const String chat = '/chat';
  static const String settings = '/settings';
  static const String language = '/language';
  static const String termsPrivacy = '/terms-privacy';
  static const String voucher = '/voucher';
  static const String vendorProfile = '/vendor-profile';
  static const String feedback = '/feedback';
}
