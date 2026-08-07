import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../routes/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../services/product_service.dart';

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
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    return FutureBuilder<DocumentSnapshot?>(
      future: productId != null ? ProductService.getById(productId) : Future.value(null),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final doc = snap.data;
        final product = doc?.data() as Map<String, dynamic>?;
        const kNavy = Color(0xFF1D2939);
        const kOrange = Color(0xFFFF5722);
        final cart = Provider.of<CartProvider>(context, listen: false);

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
            icon: Stack(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: const BoxDecoration(color: Color(0xFFF2F4F7), shape: BoxShape.circle),
                  child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF344054), size: 18),
                ),
                Consumer<CartProvider>(
                  builder: (context, cart, child) => cart.totalQuantity > 0 ? Positioned(
                    top: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text('${cart.totalQuantity}', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ) : const SizedBox.shrink(),
                ),
              ],
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(builder: (_) {
                  final imgs = (product?['images'] as List?)?.cast<String>() ?? _images;
                  return Column(
                    children: List.generate(imgs.length, (i) {
                      final isSel = _selectedImage == i;
                      final src = imgs[i];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedImage = i),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: 54,
                          height: 54,
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
                            child: src.startsWith('http')
                                ? Image.network(src, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF2F4F7)))
                                : Image.asset(src, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF2F4F7))),
                          ),
                        ),
                      );
                    }),
                  );
                }),
                const SizedBox(width: 12),
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
                          child: Builder(builder: (_) {
                            final imgs = (product?['images'] as List?)?.cast<String>() ?? _images;
                            return PageView.builder(
                              itemCount: imgs.length,
                              controller: PageController(initialPage: _selectedImage),
                              onPageChanged: (p) => setState(() => _selectedImage = p),
                              itemBuilder: (_, idx) {
                                final src = imgs.elementAt(idx);
                                if (src is String && src.startsWith('http')) {
                                  return Image.network(src, width: double.infinity, height: 245, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF2F4F7)));
                                }
                                return Image.asset(src, width: double.infinity, height: 245, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF2F4F7)));
                              },
                            );
                          }),
                        ),
                      ),
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
          Text(product?['category'] ?? 'Clothing', style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3))),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product?['name'] ?? 'Product',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF101828)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFECE5), borderRadius: BorderRadius.circular(6)),
                child: Text(product?['badge'] ?? '-%', style: const TextStyle(color: kOrange, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 16),
              const SizedBox(width: 4),
              Text('${(product?['rating'] ?? 0).toString()}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF101828))),
              const SizedBox(width: 4),
              Text('( ${product?['reviewCount'] ?? 0} reviews )', style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('\$${(product?['price'] ?? 0).toStringAsFixed(2)}', style: const TextStyle(color: kOrange, fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(width: 8),
              if (product?['originalPrice'] != null) Text('\$${(product?['originalPrice']).toStringAsFixed(2)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF98A2B3), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 14),
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
          Text(
            product?['description'] ?? 'No description available.',
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
                Text(_isDescExpanded ? 'View Less' : 'View More', style: const TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 12)),
                Icon(_isDescExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 18, color: const Color(0xFF101828)),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFFE0B2)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 54, height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFFC107), width: 2)),
                      child: const Text('4.5', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF101828))),
                    ),
                    const SizedBox(height: 4),
                    const Text('2 reviews', style: TextStyle(fontSize: 9, color: Color(0xFF98A2B3))),
                    Row(children: List.generate(5, (_) => const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 10))),
                  ],
                ),
                const SizedBox(width: 20),
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
          const SizedBox(height: 30),
        ],
      ),
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
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () { if (_quantity > 1) setState(() => _quantity--); },
                      child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF344054)))),
                    ),
                    Text('$_quantity', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                    InkWell(
                      onTap: () => setState(() => _quantity++),
                      child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF344054)))),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      for (int i = 0; i < _quantity; i++) {
                        cart.addItem(
                          productId: productId ?? 'unknown',
                          title: product?['name'] ?? 'Product',
                          category: product?['category'] ?? 'General',
                          price: (product?['price'] ?? 0).toDouble(),
                          image: (product?['images'] as List?)?.first ?? AppAssets.catPhotoBags,
                        );
                      }
                      Navigator.pushNamed(context, AppRoutes.cart);
                    },
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
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2), child: LinearProgressIndicator(value: val, backgroundColor: const Color(0xFFF2F4F7), valueColor: const AlwaysStoppedAnimation(Color(0xFFFFC107)), minHeight: 4))),
          const SizedBox(width: 6),
          Text(pct, style: const TextStyle(fontSize: 9, color: Color(0xFF98A2B3))),
        ],
      ),
    );
  }
}
