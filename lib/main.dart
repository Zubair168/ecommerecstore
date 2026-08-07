import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'services/notification_service.dart';
import 'services/product_service.dart';
import 'providers/cart_provider.dart';
import 'theme/app_theme.dart';

// Import all screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/filter/filter_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/product/product_grid_screen.dart';
import 'screens/product/product_details_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/checkout/payment_method_screen.dart';
import 'screens/checkout/payment_success_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/orders/my_orders_screen.dart';
import 'screens/orders/order_details_screen.dart';
import 'screens/orders/cancel_request_screen.dart';
import 'screens/orders/return_request_screen.dart';
import 'screens/orders/track_order_screen.dart';
import 'screens/address/shipping_address_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/review/reviews_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/profile/setup_profile_screen.dart';
import 'screens/settings/chat_screen.dart';
import 'screens/settings/feedback_screen.dart';
import 'screens/settings/language_screen.dart';
import 'screens/settings/terms_privacy_screen.dart';
import 'screens/vendor/vendor_profile_screen.dart';
import 'screens/voucher/vouchers_screen.dart';
import 'screens/product/compare_products_screen.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
