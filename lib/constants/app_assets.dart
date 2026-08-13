/// Design system asset paths for Online Shop Flutter App
class AppAssets {
  static const String _raw = 'assets/raw';

  // Illustrations
  static const String onboardingIllustration1 =
      '$_raw/illustrations/onboarding_illustration_1.svg';
  static const String onboardingIllustration2 =
      '$_raw/illustrations/onboarding_illustration_2.svg';
  static const String onboardingIllustration3 =
      '$_raw/illustrations/onboarding_illustration_3.svg';

  // Logos
  static const String appLogo =
      '$_raw/logos/app_logo.svg'; // SVG wrapper – use appLogoPng
  static const String appLogoPng =
      '$_raw/logos/app_logo.png'; // extracted raster
  static const String appleLogo = '$_raw/logos/apple_logo.svg';
  static const String googleLogo = '$_raw/logos/google_logo.svg';
  static const String upsLogo = '$_raw/logos/ups_logo.svg';

  // Navigation
  static const String navHome = '$_raw/navigation/nav_home.svg';
  static const String navCart = '$_raw/navigation/nav_cart.svg';
  static const String navWishlist = '$_raw/navigation/nav_wishlist.svg';
  static const String navProfile = '$_raw/navigation/nav_profile.svg';
  static const String navSearch = '$_raw/navigation/nav_search.svg';
  static const String iconBack = '$_raw/navigation/icon_back.svg';
  static const String iconClose = '$_raw/navigation/icon_close.svg';

  // Icons
  static const String iconCamera = '$_raw/icons/icon_camera.svg';
  static const String iconCameraAlt = '$_raw/icons/icon_camera_alt.svg';
  static const String iconEdit = '$_raw/icons/icon_edit.svg';
  static const String iconDelete = '$_raw/icons/icon_delete.svg';
  static const String iconLocation = '$_raw/icons/icon_location.svg';
  static const String iconNotification = '$_raw/icons/icon_notification.svg';
  static const String iconSettings = '$_raw/icons/icon_settings.svg';
  static const String iconStarFilled = '$_raw/icons/icon_star_filled.svg';
  static const String iconStarOutline = '$_raw/icons/icon_star_outline.svg';
  static const String iconLike = '$_raw/icons/icon_like.svg';
  static const String iconCoupon = '$_raw/icons/icon_coupon.svg';
  static const String iconOrder = '$_raw/icons/icon_order.svg';
  static const String iconDelivery = '$_raw/icons/icon_delivery.svg';
  static const String iconPackageDelivered =
      '$_raw/icons/icon_package_delivered.svg';
  static const String iconProcessing = '$_raw/icons/icon_processing.svg';
  static const String iconReturn = '$_raw/icons/icon_return.svg';
  static const String iconCancel = '$_raw/icons/icon_cancel.svg';
  static const String iconTickDouble = '$_raw/icons/icon_tick_double.svg';
  static const String iconClock = '$_raw/icons/icon_clock.svg';
  static const String iconGrid = '$_raw/icons/icon_grid.svg';
  static const String iconPlus = '$_raw/icons/icon_plus.svg';
  static const String iconMinus = '$_raw/icons/icon_minus.svg';
  static const String iconMoreDots = '$_raw/icons/icon_more_dots.svg';
  static const String iconFlag = '$_raw/icons/icon_flag.svg';
  static const String iconOffice = '$_raw/icons/icon_office.svg';
  static const String iconPassword = '$_raw/icons/icon_password.svg';
  static const String iconCompare = '$_raw/icons/icon_compare.svg';
  static const String iconDownload = '$_raw/icons/icon_download.svg';
  static const String iconMail = '$_raw/icons/icon_mail.svg';
  static const String iconFilterConfig = '$_raw/icons/icon_filter_config.svg';

  // Categories
  static const String catElectronics = '$_raw/categories/cat_electronics.svg';
  static const String catFashion = '$_raw/categories/cat_fashion.svg';
  static const String catBeauty = '$_raw/categories/cat_beauty.svg';
  static const String catFurniture = '$_raw/categories/cat_furniture.svg';
  static const String catSports = '$_raw/categories/cat_sports.svg';

  // Banners
  static const String bannerSale50 =
      '$_raw/banners/banner_sale_50.svg'; // SVG wrapper
  static const String bannerSale50Png =
      '$_raw/banners/banner_sale_50.png'; // raster
  static const String bannerPromoHero =
      '$_raw/banners/banner_promo_hero.svg'; // SVG wrapper
  static const String bannerPromoHeroPng =
      '$_raw/banners/banner_promo_hero.png'; // raster

  // User Provided Assets
  static const String userFlashSale = 'assets/Flash sale.png';
  static const String userHeaderTabs = 'assets/Frame 1000008199 (1).png';
  static const String userBannerHero = 'assets/Frame 1000008764 (1).png';
  static const String userHeroPromo = 'assets/Image (2).png';
  static const String userHomeIcon = 'assets/material-symbols_home.png';
  static const String userBagIcon = 'assets/ph_bag-fill.png';
  static const String userSettingIcon = 'assets/weui_setting-filled.png';
  static const String userButtonImg = 'assets/Button.png';
  static const String userSegmentedContainer =
      'assets/Segmented picker container.png';

  // Products — use the .png/.jpg variants; .svg files embed raster so SvgPicture won't render them
  static const String productHeadphone = '$_raw/products/product_headphone.png';
  static const String productFashion = '$_raw/products/product_fashion.png';
  static const String productShoe = '$_raw/products/product_shoe.png';
  static const String productSwitchConsole1 =
      '$_raw/products/product_switch_console_1.jpg';
  static const String productSwitchConsole2 =
      '$_raw/products/product_switch_console_2.jpg';

  // AI-Generated Category Photos — real product images per category
  static const String catPhotoMen = '$_raw/products/cat_fashion_men.png';
  static const String catPhotoWomen = '$_raw/products/cat_fashion_women.png';
  static const String catPhotoShoes = '$_raw/products/cat_shoes.png';
  static const String catPhotoElec = '$_raw/products/cat_electronics.png';
  static const String catPhotoBags = '$_raw/products/cat_bags.png';
  static const String catPhotoWatches = '$_raw/products/cat_watches.png';

  // Payments
  static const String iconPaymentCard = '$_raw/payments/icon_payment_card.svg';

  // Avatars
  static const String avatarUserDefault =
      '$_raw/avatars/avatar_user_default.svg';
  static const String avatarVendor = '$_raw/avatars/avatar_vendor.svg';

  // Images
  static const String bgCircleAccent = '$_raw/images/bg_circle_accent.svg';

  // Misc
  static const String badgeSaleTag = '$_raw/misc/badge_sale_tag.svg';
  static const String buttonGraphicPrimary =
      '$_raw/misc/button_graphic_primary.svg';
  static const String buttonGraphicSecondary =
      '$_raw/misc/button_graphic_secondary.svg';
  static const String containerGraphic = '$_raw/misc/container_graphic.svg';
  static const String containerPicker = '$_raw/misc/container_picker.svg';
  static const String containerTextInput =
      '$_raw/misc/container_text_input.svg';
  static const String containerVertical = '$_raw/misc/container_vertical.svg';
  static const String iconPaperclipPng = '$_raw/misc/icon_paperclip.png';
  static const String iconPaperclipSvg = '$_raw/misc/icon_paperclip.svg';
  static const String graphicPlain3 = '$_raw/misc/graphic_plain_3.svg';
}
