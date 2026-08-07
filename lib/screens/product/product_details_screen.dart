import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImage = 0;
  bool _isWishlisted = false;
  int _quantity = 1;
  bool _isDescExpanded = false;

  final _images = [
    AppAssets.productFashion,
    AppAssets.productShoe,
    AppAssets.productHeadphone,
    AppAssets.productSwitchConsole1,
  ];

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);
    const kOrange = Color(0xFFFF5722);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(color: Color(0xFFF2F4F7), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF344054), size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product',
          style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              width: 36, height: 36,
              decoration: const BoxDecoration(color: Color(0xFFF2F4F7), shape: BoxShape.circle),
              child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF344054), size: 18),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),

          // ── Main Gallery Container matching screenshot ──────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vertical thumbnails on left matching screenshot
                Column(
                  children: List.generate(_images.length, (i) {
                    final isSel = _selectedImage == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedImage = i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: 54, height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSel ? const Color(0xFFE91E63) : const Color(0xFFEAECF0),
                            width: isSel ? 1.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            _images[i], fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF2F4F7)),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 12),

                // Main Image display with Compare & Heart buttons
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 245,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            _images[_selectedImage],
                            width: double.infinity,
                            height: 245,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF2F4F7)),
                          ),
                        ),
                      ),

                    // Top-right action buttons (Compare & Heart)
                    Positioned(
                      top: 10, right: 10,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, AppRoutes.compareProducts),
                            child: Container(
                              width: 34, height: 34,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.compare_arrows_rounded, color: Color(0xFF344054), size: 18),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => setState(() => _isWishlisted = !_isWishlisted),
                            child: Container(
                              width: 34, height: 34,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(
                                _isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: _isWishlisted ? Colors.red : const Color(0xFF344054),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
          const SizedBox(height: 16),

          // ── Product Category & Title ──────────────────────────────────────
          const Text('Clothing', style: TextStyle(fontSize: 11, color: Color(0xFF98A2B3))),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Simple minimalist Brown Bag',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF101828)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFECE5), borderRadius: BorderRadius.circular(6)),
                child: const Text('-25%', style: TextStyle(color: kOrange, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Star Rating & Price line
          Row(
            children: const [
              Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 16),
              SizedBox(width: 4),
              Text('4.5', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF101828))),
              SizedBox(width: 4),
              Text('( 2 reviews )', style: TextStyle(fontSize: 11, color: Color(0xFF98A2B3))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text('\$9.00', style: TextStyle(color: kOrange, fontWeight: FontWeight.w900, fontSize: 18)),
              SizedBox(width: 8),
              Text('\$15.00', style: TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF98A2B3), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 14),

          // Coupon / Voucher Bar matching screenshot
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.confirmation_number_outlined, color: Color(0xFF475467), size: 18),
                const SizedBox(width: 8),
                const Text('Coupons & Vouchers', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF344054))),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFF98A2B3), size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Description Section ──────────────────────────────────────────
          Text(
            'Elevate your everyday look with this timeless leather handbag. Crafted from premium materials, it offers a spacious interior, sturdy handles, and elegant detailing — perfect for both work and casual outings. Designed for comfort and versatility, this backpack features multiple compartments, water-resistant fabric, and a sleek modern look — ideal for daily commutes, college, or short trips.',
            maxLines: _isDescExpanded ? 20 : 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Color(0xFF475467), height: 1.5),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _isDescExpanded = !_isDescExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isDescExpanded ? 'View Less' : 'View More',
                  style: const TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 12),
                ),
                Icon(
                  _isDescExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  size: 18, color: const Color(0xFF101828),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Rating and Reviews Section matching screenshot ────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Rating and Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF101828))),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.review),
                child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF98A2B3), size: 22),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Big 4.5 Rating Breakdown Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFFE0B2)),
            ),
            child: Row(
              children: [
                // 4.5 yellow circle on left
                Column(
                  children: [
                    Container(
                      width: 54, height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFFC107), width: 2),
                      ),
                      child: const Text('4.5', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF101828))),
                    ),
                    const SizedBox(height: 4),
                    const Text('2 reviews', style: TextStyle(fontSize: 9, color: Color(0xFF98A2B3))),
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(5, (_) => const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 10)),
                    ),
                  ],
                ),
                const SizedBox(width: 20),

                // Rating Progress Bars on right
                Expanded(
                  child: Column(
                    children: [
                      _starRow('5 Star', 0.5, '50 %'),
                      _starRow('4 Star', 0.5, '50 %'),
                      _starRow('3 Star', 0.0, '0 %'),
                      _starRow('2 Star', 0.0, '0 %'),
                      _starRow('1 Star', 0.0, '0 %'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Customer Review 1: Jack wylde
          _reviewCard(
            name: 'Jack wylde',
            time: '2 Weeks ago',
            text: 'Absolutely love this bag! The quality is amazing for the price and it looks even better in person',
            photos: [AppAssets.userHeroPromo, AppAssets.productShoe, AppAssets.productFashion],
          ),
          const SizedBox(height: 12),

          // Customer Review 2: Alexa young
          _reviewCard(
            name: 'Alexa young',
            time: '2 Weeks ago',
            text: 'Absolutely love this bag! The quality is amazing for the price and it looks even better in person',
            photos: [AppAssets.productFashion, AppAssets.productHeadphone, AppAssets.productSwitchConsole1],
          ),

          const SizedBox(height: 30),
        ],
      ),

      // ── Bottom Action Bar (- 1 + Quantity Stepper + Dark Navy Buy Now Button) ──
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEAECF0))),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Quantity Stepper matching screenshot
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () { if (_quantity > 1) setState(() => _quantity--); },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF344054))),
                      ),
                    ),
                    Text('$_quantity', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                    InkWell(
                      onTap: () => setState(() => _quantity++),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF344054))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Dark Navy Buy now Button matching screenshot
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.checkout),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Buy now', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _starRow(String label, double val, String pct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF98A2B3))),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: val,
                backgroundColor: const Color(0xFFF2F4F7),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFFC107)),
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(pct, style: const TextStyle(fontSize: 9, color: Color(0xFF98A2B3))),
        ],
      ),
    );
  }

  Widget _reviewCard({
    required String name,
    required String time,
    required String text,
    required List<String> photos,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF2F4F7),
              child: Text(name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF344054))),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
              ],
            ),
            const Spacer(),
            const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF98A2B3)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            ...List.generate(5, (_) => const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 12)),
            const SizedBox(width: 4),
            const Text('5 stars', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF344054))),
          ],
        ),
        const SizedBox(height: 2),
        const Text('Variant: XXL Black', style: TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF475467), height: 1.4)),
        const SizedBox(height: 8),
        Row(
          children: photos.map((p) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  p, width: 64, height: 64, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: const Color(0xFFF2F4F7)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
