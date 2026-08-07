import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedToggle = 0; // 0: Layout, 1: Filter
  bool _selectAll = true;

  // Mock data for cart items
  final List<Map<String, dynamic>> _cartItems = [
    {
      'category': 'Clothing',
      'title': 'Winter zipper hoodie',
      'price': 9.00,
      'qty': 1,
      'img': AppAssets.catPhotoMen,
      'showDelete': true,
    },
    {
      'category': 'Shoes',
      'title': 'Classic White Sneakers',
      'price': 12.00,
      'qty': 1,
      'img': AppAssets.catPhotoShoes,
    },
    {
      'category': 'Electronics',
      'title': 'Pro Wireless Headphones',
      'price': 18.00,
      'qty': 1,
      'img': AppAssets.catPhotoElec,
    },
    {
      'category': 'Women',
      'title': 'Floral Wrap Summer Dress',
      'price': 14.00,
      'qty': 1,
      'img': AppAssets.catPhotoWomen,
    },
    {
      'category': 'Bags',
      'title': 'Brown Leather Crossbody Bag',
      'price': 20.00,
      'qty': 1,
      'img': AppAssets.catPhotoBags,
    },
  ];

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);
    const kOrange = Color(0xFFFF5722);

    int totalItems = 0;
    double totalPrice = 0;
    for (var item in _cartItems) {
      totalItems += item['qty'] as int;
      totalPrice += (item['price'] as double) * (item['qty'] as int);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF101828), size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          },
        ),
        title: const Text(
          'Cart',
          style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF344054), size: 22),
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEAECF0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Color(0xFF98A2B3), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Products...',
                          hintStyle: TextStyle(color: const Color(0xFF98A2B3), fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Toggle Bar (Layout / Filter)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedToggle = 0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _selectedToggle == 0 ? kNavy : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.grid_view_rounded, size: 16,
                                  color: _selectedToggle == 0 ? Colors.white : const Color(0xFF667085)),
                              const SizedBox(width: 6),
                              Text('Layout', style: TextStyle(
                                  color: _selectedToggle == 0 ? Colors.white : const Color(0xFF667085),
                                  fontWeight: FontWeight.w700, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedToggle = 1),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _selectedToggle == 1 ? kNavy : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.tune_rounded, size: 16,
                                  color: _selectedToggle == 1 ? Colors.white : const Color(0xFF667085)),
                              const SizedBox(width: 6),
                              Text('Filter', style: TextStyle(
                                  color: _selectedToggle == 1 ? Colors.white : const Color(0xFF667085),
                                  fontWeight: FontWeight.w700, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stepper (Cart -> Checkout -> Payment)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Row(
                children: [
                  _stepDot('Cart', isDone: true, isActive: true),
                  Expanded(child: Container(height: 2, color: const Color(0xFFEAECF0))),
                  _stepDot('Checkout', isDone: false, isActive: false),
                  Expanded(child: Container(height: 2, color: const Color(0xFFEAECF0))),
                  _stepDot('Payment', isDone: false, isActive: false),
                ],
              ),
            ),

            // Cart Items List
            Expanded(
              child: _cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          const Text('Your cart is empty', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _cartItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return _cartTile(
                          category: item['category'],
                          title: item['title'],
                          price: '\$${(item['price'] as double).toStringAsFixed(2)}',
                          qty: item['qty'],
                          img: item['img'],
                          showDelete: item['showDelete'] ?? false,
                          onQtyMinus: () {
                            if (item['qty'] > 1) {
                              setState(() => item['qty']--);
                            }
                          },
                          onQtyPlus: () {
                            setState(() => item['qty']++);
                          },
                          onDelete: () {
                            setState(() => _cartItems.removeAt(index));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checkout Action Bar
          if (_cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEAECF0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _selectAll,
                        activeColor: kNavy,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) => setState(() => _selectAll = val!),
                      ),
                      const Text('All', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF344054))),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.checkout),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      elevation: 0,
                    ),
                    child: Text('Checkout ($totalItems) • \$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),

          // Main Bottom Nav Bar
          CustomBottomNavBar(
            currentTab: NavTab.cart,
            cartBadgeCount: totalItems,
            onTabSelected: (tab) {
              switch (tab) {
                case NavTab.home:
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                case NavTab.category:
                  Navigator.pushReplacementNamed(context, AppRoutes.categories);
                case NavTab.settings:
                  Navigator.pushReplacementNamed(context, AppRoutes.settings);
                default:
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _stepDot(String label, {required bool isDone, required bool isActive}) {
    return Column(
      children: [
        Container(
          width: 14, height: 14,
          decoration: BoxDecoration(
            color: isDone ? const Color(0xFFFF9800) : const Color(0xFFEAECF0),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFF101828) : const Color(0xFF98A2B3), fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }

  Widget _cartTile({
    required String category,
    required String title,
    required String price,
    required int qty,
    required String img,
    bool showDelete = false,
    required VoidCallback onQtyMinus,
    required VoidCallback onQtyPlus,
    required VoidCallback onDelete,
  }) {
    const kOrange = Color(0xFFFF5722);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                img, width: 72, height: 72, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: const Color(0xFFF2F4F7)),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
                const SizedBox(height: 2),
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(color: kOrange, fontWeight: FontWeight.w800, fontSize: 13)),
                    Container(
                      height: 28,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFEAECF0)),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: onQtyMinus,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('-', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF667085))),
                            ),
                          ),
                          Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF101828))),
                          InkWell(
                            onTap: onQtyPlus,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('+', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF667085))),
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
          if (showDelete)
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 50, height: 88,
                color: const Color(0xFFFFB74D),
                child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
              ),
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    );
  }
}
