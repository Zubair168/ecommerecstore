import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerecstore/firebase_options.dart';
import 'package:ecommerecstore/routes/app_routes.dart';
import 'package:ecommerecstore/services/notification_service.dart';
import 'package:ecommerecstore/services/product_service.dart';
import 'package:ecommerecstore/providers/cart_provider.dart';
import 'package:ecommerecstore/theme/app_theme.dart';

// Import all screens
import 'package:ecommerecstore/screens/auth/login_screen.dart';
import 'package:ecommerecstore/screens/auth/register_screen.dart';
import 'package:ecommerecstore/screens/auth/forgot_password_screen.dart';
import 'package:ecommerecstore/screens/onboarding/onboarding_screen.dart';
import 'package:ecommerecstore/screens/filter/filter_screen.dart';
import 'package:ecommerecstore/screens/notifications/notifications_screen.dart';
import 'package:ecommerecstore/screens/home/home_screen.dart';
import 'package:ecommerecstore/screens/cart/cart_screen.dart';
import 'package:ecommerecstore/screens/wishlist/wishlist_screen.dart';
import 'package:ecommerecstore/screens/profile/profile_screen.dart';
import 'package:ecommerecstore/screens/categories/categories_screen.dart';
import 'package:ecommerecstore/screens/product/product_grid_screen.dart';
import 'package:ecommerecstore/screens/product/product_details_screen.dart';
import 'package:ecommerecstore/screens/checkout/checkout_screen.dart';
import 'package:ecommerecstore/screens/checkout/payment_method_screen.dart';
import 'package:ecommerecstore/screens/checkout/payment_success_screen.dart';
import 'package:ecommerecstore/screens/splash/splash_screen.dart';
import 'package:ecommerecstore/screens/orders/my_orders_screen.dart';
import 'package:ecommerecstore/screens/orders/order_details_screen.dart';
import 'package:ecommerecstore/screens/orders/cancel_request_screen.dart';
import 'package:ecommerecstore/screens/orders/return_request_screen.dart';
import 'package:ecommerecstore/screens/orders/track_order_screen.dart';
import 'package:ecommerecstore/screens/address/shipping_address_screen.dart';
import 'package:ecommerecstore/screens/profile/edit_profile_screen.dart';
import 'package:ecommerecstore/screens/settings/settings_screen.dart';
import 'package:ecommerecstore/screens/review/reviews_screen.dart';
import 'package:ecommerecstore/screens/search/search_screen.dart';
import 'package:ecommerecstore/screens/profile/setup_profile_screen.dart';
import 'package:ecommerecstore/screens/settings/chat_screen.dart';
import 'package:ecommerecstore/screens/settings/feedback_screen.dart';
import 'package:ecommerecstore/screens/settings/language_screen.dart';
import 'package:ecommerecstore/screens/settings/terms_privacy_screen.dart';
import 'package:ecommerecstore/screens/vendor/vendor_profile_screen.dart';
import 'package:ecommerecstore/screens/voucher/vouchers_screen.dart';
import 'package:ecommerecstore/screens/product/compare_products_screen.dart';

import 'package:ecommerecstore/config/app_config.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('Configured API URL: ${AppConfig.apiUrl}');

    // Initialize Firebase before starting the app to prevent late-initialization errors
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 8));

    // Optional background services
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await NotificationService.initialize();

    // Seed Firestore data in background
    ProductService.seedProducts();
  } catch (e) {
    debugPrint('Initialization error: $e');
  }

  // Load persisted cart before starting the app
  final cartProvider = await CartProvider.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cartProvider),
      ],
      child: const OnlineShopApp(),
    ),
  );
}

class OnlineShopApp extends StatelessWidget {
  const OnlineShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Shop',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: AppRoutes.splash,
      routes: {
        // Auth flow
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
        AppRoutes.setupProfile: (_) => const SetupProfileScreen(),

        // Main
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.categories: (_) => const CategoriesScreen(),
        AppRoutes.search: (_) => const SearchScreen(),
        AppRoutes.wishlist: (_) => const WishlistScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.notifications: (_) => const NotificationsScreen(),

        // Filter & Products
        AppRoutes.filter: (_) => const FilterScreen(),
        AppRoutes.productGrid: (_) => const ProductGridScreen(),
        AppRoutes.productDetails: (_) => const ProductDetailsScreen(),
        AppRoutes.compareProducts: (_) => const CompareProductsScreen(),
        AppRoutes.vendorProfile: (_) => const VendorProfileScreen(),
        AppRoutes.review: (_) => const ReviewsScreen(),

        // Cart & Checkout
        AppRoutes.cart: (_) => const CartScreen(),
        AppRoutes.checkout: (_) => const CheckoutScreen(),
        AppRoutes.paymentMethod: (_) => const PaymentMethodScreen(),
        AppRoutes.addCard: (_) => const AddCardScreen(),
        AppRoutes.paymentSuccess: (_) => const PaymentSuccessScreen(),

        // Orders
        AppRoutes.myOrders: (_) => const MyOrdersScreen(),
        AppRoutes.orderDetails: (_) => const OrderDetailsScreen(),
        AppRoutes.trackOrder: (_) => const TrackOrderScreen(),
        AppRoutes.cancelRequest: (_) => const CancelRequestScreen(),
        AppRoutes.returnRequest: (_) => const ReturnRequestScreen(),

        // Address, Profile & Settings
        AppRoutes.shippingAddress: (_) => const ShippingAddressScreen(),
        AppRoutes.addAddress: (_) => const AddAddressScreen(),
        AppRoutes.editProfile: (_) => const EditProfileScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
        AppRoutes.chat: (_) => const ChatScreen(),
        AppRoutes.language: (_) => const LanguageScreen(),
        AppRoutes.termsPrivacy: (_) => const TermsPrivacyScreen(),
        AppRoutes.feedback: (_) => const FeedbackScreen(),
        AppRoutes.voucher: (_) => const VouchersScreen(),
      },
    );
  }
}
