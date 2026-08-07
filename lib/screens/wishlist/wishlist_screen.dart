import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/index.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  int _selectedLayout = 0; // 0: Layout, 1: Filter

  static final _wishlistItems = [
    {
      'title': 'Winter Front Zipper And Front Pocket Hoodie Warm For Men',
      'category': 'Clothing',
      'price': '\$9.00',
      'orig': '\$19.00',
      'img': AppAssets.productFashion,
    },
    {
      'title': 'Perfect shoes for trekking with double sole inside',
      'category': 'Shoes',
      'price': '\$70.00',
      'orig': '\$80.00',
      'img': AppAssets.productShoe,
    },
    {
      'title': 'Full titanium Rolex with silver chains outside',
      'category': 'Watch',
      'price': '\$120.00',
      'orig': '\$130.00',
      'img': AppAssets.productHeadphone,
    },
    {
      'title': 'Sleeveless t-shirt with fur inside for cold and harsh weather',
      'category': 'Clothing',
      'price': '\$40.00',
      'orig': '\$55.00',
      'img': AppAssets.productFashion,
    },
  ];

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);
    const kOrange = Color(0xFFFF5722);

    // If app uses auth, show prompt when not signed in
    // (lightweight check without importing AuthService here to avoid extra dependency)

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF344054), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Wishlist',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar matching professional design
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomSearchBar(
              hintText: 'Search Products...',
              onChanged: (v) {},
            ),
          ),
          const SizedBox(height: 8),

          // Layout / Filter Segmented Toggle matching 25_wishlist.png
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedLayout = 0),
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: _selectedLayout == 0 ? kNavy : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.grid_view_rounded, size: 16, color: _selectedLayout == 0 ? Colors.white : const Color(0xFF667085)),
                            const SizedBox(width: 6),
                            Text('Layout', style: TextStyle(color: _selectedLayout == 0 ? Colors.white : const Color(0xFF667085), fontWeight: FontWeight.w700, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedLayout = 1),
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: _selectedLayout == 1 ? kNavy : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.tune_rounded, size: 16, color: _selectedLayout == 1 ? Colors.white : const Color(0xFF667085)),
                            const SizedBox(width: 6),
                            Text('Filter', style: TextStyle(color: _selectedLayout == 1 ? Colors.white : const Color(0xFF667085), fontWeight: FontWeight.w700, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Wishlist Items List
          Expanded(
            child: AuthService.currentUser == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Please sign in to view your wishlist', style: TextStyle(fontSize: 16, color: Color(0xFF667085))),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.login), child: const Text('Sign in')),
                      ],
                    ),
                  )
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _wishlistItems.length,
              separatorBuilder: (_, __) => const Divider(height: 24, color: Color(0xFFEAECF0)),
              itemBuilder: (context, i) {
                final item = _wishlistItems[i];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(item['img']!, width: 70, height: 70, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 70, height: 70, color: const Color(0xFFF2F4F7))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['category']!, style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
                            const SizedBox(height: 2),
                            Text(item['title']!, maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(item['price']!, style: const TextStyle(color: kOrange, fontWeight: FontWeight.w800, fontSize: 13)),
                                const SizedBox(width: 6),
                                Text(item['orig']!, style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF98A2B3), fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.favorite_rounded, color: Color(0xFF98A2B3), size: 20),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Action Button: Add to cart (Dark Navy)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Add to cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
