import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../widgets/index.dart';
import '../../providers/cart_provider.dart';
import '../../services/product_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final Set<int> _wishlist = {};
  List<DocumentSnapshot> _firestoreProducts = [];
  StreamSubscription<QuerySnapshot>? _productsSub;

  static final _catTiles = [
    {'title': 'Men', 'img': AppAssets.catPhotoMen},
    {'title': 'Women', 'img': AppAssets.catPhotoWomen},
    {'title': 'Shoes', 'img': AppAssets.catPhotoShoes},
    {'title': 'Electronics', 'img': AppAssets.catPhotoElec},
    {'title': 'Bags', 'img': AppAssets.catPhotoBags},
    {'title': 'Watches', 'img': AppAssets.catPhotoWatches},
  ];

  static final _newProducts = [
    {'title': 'Minimalist Brown Bag', 'category': 'Women', 'img': AppAssets.catPhotoWomen, 'price': 9.00, 'orig': 15.00, 'badge': '-56%'},
    {'title': 'Slim Fit Navy Hoodie', 'category': 'Men', 'img': AppAssets.catPhotoMen, 'price': 29.99, 'orig': 45.00, 'badge': '-33%'},
    {'title': 'Classic White Sneakers', 'category': 'Shoes', 'img': AppAssets.catPhotoShoes, 'price': 49.99, 'orig': 80.00, 'badge': '-38%'},
    {'title': 'Pro Wireless Headphones', 'category': 'Electronics', 'img': AppAssets.catPhotoElec, 'price': 89.99, 'orig': 149.00, 'badge': '-40%'},
    {'title': 'Brown Leather Crossbody', 'category': 'Bags', 'img': AppAssets.catPhotoBags, 'price': 44.99, 'orig': 75.00, 'badge': '-40%'},
    {'title': 'Steel Chronograph Watch', 'category': 'Watches', 'img': AppAssets.catPhotoWatches, 'price': 129.99, 'orig': 220.00, 'badge': '-41%'},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _productsSub = ProductService.productsStream.listen((snap) {
      if (mounted) setState(() => _firestoreProducts = snap.docs);
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _productsSub?.cancel();
    super.dispose();
  }

  String? _productId(int index) {
    if (_firestoreProducts.isEmpty) return null;
    return _firestoreProducts[index % _firestoreProducts.length].id;
  }

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);
    const kOrange = Color(0xFFFF5722);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: kOrange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 6),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Outfit'),
                    children: [
                      TextSpan(text: 'Online', style: TextStyle(color: kOrange)),
                      TextSpan(text: 'Shop', style: TextStyle(color: kNavy)),
                    ],
                  ),
                ),
              ],
            ),
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
                      decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabCtrl,
              labelColor: kNavy,
              unselectedLabelColor: const Color(0xFF667085),
              indicatorColor: kNavy,
              indicatorWeight: 2.5,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              tabs: const [
                Tab(text: 'Men'),
                Tab(text: 'Women'),
                Tab(text: 'Beauty & health'),
                Tab(text: 'Kids'),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category tiles (2 rows of 4)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _catTiles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.85,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, i) {
                final cat = _catTiles[i];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.productGrid),
                  child: Column(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFEAECF0), width: 1),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            cat['img'] as String,
                            width: 60, height: 60, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFF2F4F7),
                              child: const Icon(Icons.person, color: Color(0xFF667085), size: 24),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF344054)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Section title: New Products
            const Text(
              'New Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF101828)),
            ),
            const SizedBox(height: 12),

            // 2-column Grid of New Products matching 17_category.png
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _newProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, i) {
                final p = _newProducts[i];
                final isWish = _wishlist.contains(i);
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: _productId(i)),
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
                                decoration: BoxDecoration(
                                  color: kOrange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(p['badge'] as String,
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                              ),
                            ),
                            Positioned(
                              top: 8, right: 8,
                              child: GestureDetector(
                                onTap: () => setState(() => isWish ? _wishlist.remove(i) : _wishlist.add(i)),
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: Icon(
                                    isWish ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    size: 16,
                                    color: isWish ? Colors.red : const Color(0xFF98A2B3),
                                  ),
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
                              Text(p['category'] as String,
                                  style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
                              const SizedBox(height: 2),
                              Text(p['title'] as String,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('\$${(p['price'] as double).toStringAsFixed(2)}',
                                      style: const TextStyle(color: kOrange, fontWeight: FontWeight.w800, fontSize: 13)),
                                  const SizedBox(width: 4),
                                  Text('\$${(p['orig'] as double).toStringAsFixed(2)}',
                                      style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF98A2B3), fontSize: 10)),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: const [
                                  Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 12),
                                  SizedBox(width: 2),
                                  Text('4.5 (2) | 10 Sold', style: TextStyle(color: Color(0xFF98A2B3), fontSize: 10)),
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
          ],
        ),
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) => CustomBottomNavBar(
          currentTab: NavTab.category,
          cartBadgeCount: cart.totalQuantity,
          onTabSelected: (tab) {
            switch (tab) {
              case NavTab.home:
                Navigator.pushReplacementNamed(context, AppRoutes.home);
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
}
