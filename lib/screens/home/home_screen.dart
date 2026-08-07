import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../widgets/index.dart';
import '../../providers/cart_provider.dart';

const _kOrange = Color(0xFFFF5722);
const _kNavy = Color(0xFF1D2939);
const _kCoral = Color(0xFFFF6542);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _saleSeconds = 45 * 86400 + 20 * 3600 + 32 * 60 + 24; // 45d 20h 32m 24s matching design
  int _dealSeconds = 20 * 3600 + 32 * 60 + 14;              // 20h 32m 14s

  late Timer _timer;
  late PageController _heroPageCtrl;
  Timer? _heroTimer;
  int _heroIndex = 0;

  final Set<int> _wFlash = {};
  final Set<int> _wDeals = {};
  final Set<int> _wNew = {};

  // Real Photo Category Items — using AI-generated product category images
  static final _photoCategories = [
    {'label': 'Men', 'img': AppAssets.catPhotoMen},
    {'label': 'Women', 'img': AppAssets.catPhotoWomen},
    {'label': 'Shoes', 'img': AppAssets.catPhotoShoes},
    {'label': 'Electronics', 'img': AppAssets.catPhotoElec},
    {'label': 'Bags', 'img': AppAssets.catPhotoBags},
    {'label': 'Watches', 'img': AppAssets.catPhotoWatches},
  ];

  static const _flash = [
    {
      'title': 'Slim Fit Navy Hoodie',
      'price': 29.99, 'orig': 45.00, 'badge': 'SALE',
      'badgeColor': Color(0xFFEF4444),
      'hasSold': 82, 'total': 100,
      'img': AppAssets.catPhotoMen,
    },
    {
      'title': 'Classic White Sneakers',
      'price': 49.99, 'orig': 80.00, 'badge': '50% OFF',
      'badgeColor': Color(0xFFEF4444),
      'hasSold': 45, 'total': 100,
      'img': AppAssets.catPhotoShoes,
    },
    {
      'title': 'Pro Wireless Headphones',
      'price': 89.99, 'orig': 149.00, 'badge': '-40%',
      'badgeColor': Color(0xFFEF4444),
      'hasSold': 82, 'total': 100,
      'img': AppAssets.catPhotoElec,
    },
  ];

  static const _deals = [
    {
      'title': 'Brown Leather Crossbody',
      'price': 44.99, 'orig': 75.00, 'badge': '-40%',
      'img': AppAssets.catPhotoBags,
    },
    {
      'title': 'Steel Chronograph Watch',
      'price': 129.99, 'orig': 220.00, 'badge': '-41%',
      'img': AppAssets.catPhotoWatches,
    },
    {
      'title': 'Floral Wrap Summer Dress',
      'price': 39.99, 'orig': 65.00, 'badge': '-38%',
      'img': AppAssets.catPhotoWomen,
    },
  ];

  static const _featuredList = [
    {
      'title': 'Slim Fit Navy Hoodie',
      'price': 29.99, 'orig': 45.00, 'badge': '-33%',
      'rating': '4.8 (124)', 'sold': '82 Sold',
      'img': AppAssets.catPhotoMen,
    },
    {
      'title': 'Classic White Sneakers',
      'price': 49.99, 'orig': 80.00, 'badge': '-38%',
      'rating': '4.9 (521)', 'sold': '145 Sold',
      'img': AppAssets.catPhotoShoes,
    },
  ];

  static const _newProducts = [
    {'title': 'Minimalist Brown Bag', 'category': 'Clothing', 'price': 9.00, 'orig': 15.00, 'badge': '-56%', 'img': AppAssets.catPhotoWomen},
    {'title': 'Slim Fit Navy Hoodie', 'category': 'Men', 'price': 29.99, 'orig': 45.00, 'badge': '-33%', 'img': AppAssets.catPhotoMen},
    {'title': 'Classic White Sneakers', 'category': 'Shoes', 'price': 49.99, 'orig': 80.00, 'badge': '-38%', 'img': AppAssets.catPhotoShoes},
    {'title': 'Pro Wireless Headphones', 'category': 'Electronics', 'price': 89.99, 'orig': 149.00, 'badge': '-40%', 'img': AppAssets.catPhotoElec},
  ];

  @override
  void initState() {
    super.initState();
    _heroPageCtrl = PageController();
    _startTimer();
    _startHeroAutoScroll();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_saleSeconds > 0) _saleSeconds--;
        if (_dealSeconds > 0) _dealSeconds--;
      });
    });
  }

  void _startHeroAutoScroll() {
    _heroTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_heroPageCtrl.hasClients) return;
      final next = (_heroIndex + 1) % 3;
      _heroPageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _heroTimer?.cancel();
    _heroPageCtrl.dispose();
    super.dispose();
  }

  String _p(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    const kOrange = Color(0xFFFF5722);
    const kNavy = Color(0xFF1D2939);
    const kCoral = Color(0xFFFF6542);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: kOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Outfit'),
                    children: [
                      TextSpan(text: 'Online', style: TextStyle(color: Color(0xFFFF5722))),
                      TextSpan(text: 'Shop', style: TextStyle(color: Color(0xFF1D2939))),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF344054)),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                  child: Stack(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications_outlined, size: 20, color: Color(0xFF344054)),
                      ),
                      Positioned(
                        top: 6, right: 6,
                        child: Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(color: kOrange, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Lively Auto-Scrolling Hero Banner ────────────────────────
          SliverToBoxAdapter(child: _heroBannerSlider(kNavy)),

          // ── Real Photo Category Circles Row ─────────────────────────
          SliverToBoxAdapter(child: _photoCategoryRow()),

          // ── Flash Sale Header with original asset logo & countdown ──
          SliverToBoxAdapter(child: _flashSaleHeader(kOrange, kCoral)),
          SliverToBoxAdapter(child: _flashSaleList(kOrange)),

          // ── Limited-Time Deals ─────────────────────────────────────
          SliverToBoxAdapter(
            child: _sectionHeader(
              title: 'Limited-Time Deals',
              onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productGrid),
              orange: kOrange,
            ),
          ),
          SliverToBoxAdapter(child: _dealsList(kOrange)),

          // ── Seasonal Special Banner ──────────────────────────────────
          SliverToBoxAdapter(child: _seasonalBanner(kOrange)),

          // ── Featured Products (Horizontal Scroll List) ───────────────
          SliverToBoxAdapter(
            child: _sectionHeader(
              title: 'Featured Products',
              onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productGrid),
              orange: kOrange,
            ),
          ),
          SliverToBoxAdapter(child: _featuredHorizontalList(kOrange)),

          // ── Deal of the Day ──────────────────────────────────────────
          SliverToBoxAdapter(child: _dealOfTheDayCard(kOrange, kCoral)),

          // ── New Products Header & Grid ───────────────────────────────
          SliverToBoxAdapter(
            child: _sectionHeader(
              title: 'New Products',
              onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productGrid),
              orange: kOrange,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _buildNewProductCard(i, kOrange),
                childCount: _newProducts.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) => CustomBottomNavBar(
          currentTab: NavTab.home,
          cartBadgeCount: cart.totalQuantity,
          onTabSelected: (tab) {
            switch (tab) {
              case NavTab.category:
                Navigator.pushReplacementNamed(context, AppRoutes.categories);
              case NavTab.cart:
                Navigator.pushReplacementNamed(context, AppRoutes.cart);
              case NavTab.settings:
                Navigator.pushReplacementNamed(context, AppRoutes.settings);
              default:
                break;
            }
          },
        ),
      ),
    );
  }

  // ── Auto-scrolling Hero Banner Slider ─────────────────────────────────────────
  Widget _heroBannerSlider(Color navy) {
    final slides = [
      {
        'title': 'Summer Collection',
        'subtitle': 'Up to 50% OFF on Women Fashion',
        'badge': 'NEW ARRIVALS',
        'color1': const Color(0xFFFF6542),
        'color2': const Color(0xFFFF8A65),
        'img': AppAssets.catPhotoWomen,
      },
      {
        'title': 'Premium Electronics',
        'subtitle': 'Wireless Headphones & Earbuds',
        'badge': 'HOT DEALS',
        'color1': const Color(0xFF1D2939),
        'color2': const Color(0xFF344054),
        'img': AppAssets.catPhotoElec,
      },
      {
        'title': 'Step Into Style',
        'subtitle': 'Top Rated Sneakers & Shoes',
        'badge': 'TRENDING',
        'color1': const Color(0xFF0284C7),
        'color2': const Color(0xFF38BDF8),
        'img': AppAssets.catPhotoShoes,
      },
    ];

    return Container(
      height: 160,
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          PageView.builder(
            controller: _heroPageCtrl,
            onPageChanged: (i) => setState(() => _heroIndex = i),
            itemCount: slides.length,
            itemBuilder: (context, i) {
              final slide = slides[i];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [slide['color1'] as Color, slide['color2'] as Color],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10, top: 0, bottom: 0,
                      child: Image.asset(
                        slide['img'] as String,
                        width: 170, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              (slide['color1'] as Color).withValues(alpha: 0.95),
                              (slide['color1'] as Color).withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 160, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              slide['badge'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            slide['title'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, height: 1.1),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            slide['subtitle'] as String,
                            style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 10, left: 16,
            child: Row(
              children: List.generate(
                slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 4),
                  width: _heroIndex == i ? 18 : 6,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _heroIndex == i ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Real Photo Category Circle Chips ───────────────────────────────────────
  Widget _photoCategoryRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: SizedBox(
        height: 90,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _photoCategories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 18),
          itemBuilder: (context, i) {
            final cat = _photoCategories[i];
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.productGrid),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 58, height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEAECF0), width: 1),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        cat['img'] as String,
                        width: 58, height: 58, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFF2F4F7),
                          child: const Icon(Icons.person, color: Color(0xFF667085), size: 24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['label'] as String,
                    style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF344054),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Flash Sale Header matching original asset ────────────────────────────────
  Widget _flashSaleHeader(Color orange, Color coral) {
    final days = _saleSeconds ~/ 86400;
    final hrs = (_saleSeconds % 86400) ~/ 3600;
    final mins = (_saleSeconds % 3600) ~/ 60;
    final secs = _saleSeconds % 60;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Original Flash Sale logo image asset
          Image.asset(
            AppAssets.userFlashSale,
            height: 26,
            fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Text('FLASH SALE',
                  style: TextStyle(fontWeight: FontWeight.w900, color: orange, fontSize: 14)),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 20, color: const Color(0xFFEAECF0)),
          const SizedBox(width: 8),
          const Text('Promotion ends in',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF475467))),
          const Spacer(),
          // Coral Countdown Boxes matching original screenshot
          Row(
            children: [
              _cdBox(_p(days), 'Days', coral),
              const SizedBox(width: 4),
              _cdBox(_p(hrs), 'Hrs', coral),
              const SizedBox(width: 4),
              _cdBox(_p(mins), 'Min', coral),
              const SizedBox(width: 4),
              _cdBox(_p(secs), 'Sec', coral),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cdBox(String val, String label, [Color color = _kCoral]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26, height: 26,
          alignment: Alignment.center,
            decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            val,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF98A2B3))),
      ],
    );
  }

  Widget _flashSaleList(Color orange) {
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _flash.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final p = _flash[i];
          return SizedBox(
            width: 148,
            child: _FlashCard(
              p: p,
              wishlisted: _wFlash.contains(i),
              onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails),
              onHeart: () => setState(() =>
                  _wFlash.contains(i) ? _wFlash.remove(i) : _wFlash.add(i)),
            ),
          );
        },
      ),
    );
  }

  Widget _dealsList(Color orange) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _deals.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final p = _deals[i];
          return SizedBox(
            width: 148,
            child: _FlashCard(
              p: p,
              wishlisted: _wDeals.contains(i),
              showProgress: false,
              onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails),
              onHeart: () => setState(() =>
                  _wDeals.contains(i) ? _wDeals.remove(i) : _wDeals.add(i)),
            ),
          );
        },
      ),
    );
  }

  Widget _seasonalBanner(Color orange) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.productGrid),
      child: Container(
        height: 125,
        margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              right: 0, top: 0, bottom: 0,
              child: Image.asset(AppAssets.userHeroPromo,
                  width: 130, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink()),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text('Seasonal Special',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                    SizedBox(height: 2),
                    Text('Refresh your wardrobe with our\nlimited-time seasonal offers.',
                        style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.3)),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Explore Now',
                          style: TextStyle(color: orange, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Featured Products Horizontal Scroll List ────────────────────────────────
  Widget _featuredHorizontalList(Color orange) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _featuredList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final item = _featuredList[i];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails),
            child: Container(
              width: 270,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      item['img'] as String,
                      width: 95, height: 110, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 95, height: 110, color: const Color(0xFFEAECF0)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF101828)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('\$${(item['price'] as double).toStringAsFixed(2)}',
                                style: TextStyle(color: orange, fontWeight: FontWeight.w800, fontSize: 13)),
                            const SizedBox(width: 6),
                            Text('\$${(item['orig'] as double).toStringAsFixed(2)}',
                                style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF98A2B3), fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 14),
                            const SizedBox(width: 2),
                            Text('${item['rating']}  ${item['sold']}',
                                style: const TextStyle(fontSize: 10, color: Color(0xFF667085))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dealOfTheDayCard(Color orange, Color coral) {
    final hrs = _dealSeconds ~/ 3600;
    final mins = (_dealSeconds % 3600) ~/ 60;
    final secs = _dealSeconds % 60;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Clock & White Countdown Boxes matching screenshot
          Row(
            children: [
              const Text('Deal of the Day',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF101828))),
              const SizedBox(width: 6),
              const Icon(Icons.access_time_rounded, size: 18, color: Color(0xFF101828)),
              const Spacer(),
              _whiteTimeBox(''),
              const SizedBox(width: 4),
              _whiteTimeBox(_p(hrs)),
              const SizedBox(width: 4),
              _whiteTimeBox(_p(mins)),
              const SizedBox(width: 4),
              _whiteTimeBox(_p(secs)),
            ],
          ),
          const SizedBox(height: 14),

          // Product Row with -12% Badge overlay
          Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      AppAssets.productFashion,
                      width: 85, height: 85, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(width: 85, height: 85, color: const Color(0xFFEAECF0)),
                    ),
                  ),
                  Positioned(
                    top: 6, left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _kCoral,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('-12%', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Winter Front Zipper And Front Pocket Hoodie Warm For Men',
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF101828), height: 1.3),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('\$9.00', style: TextStyle(color: orange, fontWeight: FontWeight.w800, fontSize: 14)),
                        const SizedBox(width: 6),
                        const Text('\$15.00', style: TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF98A2B3), fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 14),
                        SizedBox(width: 4),
                        Text('4.5 ( 2 )', style: TextStyle(fontSize: 11, color: Color(0xFF667085))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Yellow Stock Progress Bar matching screenshot
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.72,
              backgroundColor: Color(0xFFEAECF0),
              valueColor: AlwaysStoppedAnimation(Color(0xFFFFC107)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),

          // Available: 84 | Sold: 31 bottom label matching screenshot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 11, color: Color(0xFF667085)),
                  children: [
                    TextSpan(text: 'Available: '),
                    TextSpan(text: '84', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF101828))),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 11, color: Color(0xFF667085)),
                  children: [
                    TextSpan(text: 'Sold: '),
                    TextSpan(text: '31', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF101828))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _whiteTimeBox(String val) {
    if (val.isEmpty) return const SizedBox.shrink();
    return Container(
      width: 26, height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        val,
        style: const TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w800, fontSize: 11),
      ),
    );
  }

  Widget _sectionHeader({required String title, required VoidCallback onSeeAll, Color orange = _kOrange}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF101828))),
          GestureDetector(
            onTap: onSeeAll,
            child: Text('See All', style: TextStyle(color: orange, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildNewProductCard(int i, Color orange) {
    final p = _newProducts[i];
    final isWish = _wNew.contains(i);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEAECF0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    p['img'] as String,
                    width: double.infinity, height: 150, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(height: 150, color: const Color(0xFFF2F4F7)),
                  ),
                ),
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.circular(4)),
                    child: Text(p['badge'] as String, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                  ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => isWish ? _wNew.remove(i) : _wNew.add(i)),
                    child: Container(
                      width: 28, height: 28,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(isWish ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 16, color: isWish ? Colors.red : const Color(0xFF98A2B3)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['category'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
                  const SizedBox(height: 2),
                  Text(p['title'] as String, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('\$${(p['price'] as double).toStringAsFixed(2)}', style: const TextStyle(color: _kOrange, fontWeight: FontWeight.w800, fontSize: 13)),
                      const SizedBox(width: 4),
                      Text('\$${(p['orig'] as double).toStringAsFixed(2)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF98A2B3), fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 14),
                      const SizedBox(width: 2),
                      const Text('4.5', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                      const SizedBox(width: 4),
                      Text('(2) | 10 Sold', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ── Customer Reviews Strip matching Figma ─────────────────────────────────
  Widget _reviewsStrip() {
    final reviews = [
      {'name': 'Jack wylde', 'rating': 5, 'time': '2 Weeks ago', 'text': 'Absolutely love this bag! The quality is amazing for the price.', 'img': AppAssets.productFashion},
      {'name': 'Alexa young', 'rating': 5, 'time': '1 Week ago', 'text': 'Perfect fit and great quality. Will buy again!', 'img': AppAssets.productShoe},
      {'name': 'Mark Johnson', 'rating': 4, 'time': '3 Days ago', 'text': 'Really happy with this purchase. Fast shipping too.', 'img': AppAssets.productHeadphone},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: reviews.map((r) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        r['img'] as String,
                        width: 36, height: 36, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 36, height: 36,
                          decoration: const BoxDecoration(color: Color(0xFFF2F4F7), shape: BoxShape.circle),
                          child: Center(child: Text((r['name'] as String).substring(0, 1),
                              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF344054)))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r['name'] as String,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                          Text(r['time'] as String,
                              style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < (r['rating'] as int) ? Icons.star_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFFFC107), size: 13,
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(r['text'] as String,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF475467), height: 1.4)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FlashCard extends StatelessWidget {
  final Map<String, dynamic> p;
  final bool wishlisted;
  final bool showProgress;
  final VoidCallback onTap;
  final VoidCallback onHeart;

  const _FlashCard({
    required this.p,
    required this.wishlisted,
    this.showProgress = true,
    required this.onTap,
    required this.onHeart,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = p['badgeColor'] as Color? ?? _kOrange;
    final sold = p['hasSold'] as int? ?? 0;
    final total = p['total'] as int? ?? 100;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEAECF0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    p['img'] as String,
                    width: double.infinity, height: 135, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(height: 135, color: const Color(0xFFF2F4F7)),
                  ),
                ),
                Positioned(
                  top: 6, left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(4)),
                    child: Text(p['badge'] as String, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                  ),
                ),
                Positioned(
                  top: 6, right: 6,
                  child: GestureDetector(
                    onTap: onHeart,
                    child: Container(
                      width: 26, height: 26,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(wishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 14, color: wishlisted ? Colors.red : const Color(0xFF98A2B3)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['title'] as String, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('\$${(p['price'] as double).toStringAsFixed(2)}', style: const TextStyle(color: _kOrange, fontWeight: FontWeight.w800, fontSize: 12)),
                      const SizedBox(width: 4),
                      Text('\$${(p['orig'] as double).toStringAsFixed(2)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF98A2B3), fontSize: 9)),
                    ],
                  ),
                  if (showProgress) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 14),
                        const SizedBox(width: 2),
                        const Text('4.8', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                        const SizedBox(width: 4),
                        Text('(124) | $sold Sold', style: TextStyle(fontSize: 10, color: Color(0xFF667085))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: sold / total,
                      backgroundColor: const Color(0xFFF2F4F7),
                      valueColor: const AlwaysStoppedAnimation(_kOrange),
                      minHeight: 4,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
