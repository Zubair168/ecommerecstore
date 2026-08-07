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
  bool _selectAll = false;

  int _qty1 = 1;
  int _qty2 = 1;
  int _qty3 = 1;
  int _qty4 = 1;
  int _qty5 = 1;

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF344054), size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          },
        ),
        title: const Text('Cart',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF344054), size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Products Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEAECF0)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search_rounded, color: Color(0xFF98A2B3), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Products...',
                        hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Layout / Filter Toggle Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => setState(() => _selectedToggle = 0),
                        child: Container(
                          height: 38,
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
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => setState(() => _selectedToggle = 1),
                        child: Container(
                          height: 38,
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
          ),
          const SizedBox(height: 12),

          // Stepper bar (Cart -> Checkout -> Payment)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
          const SizedBox(height: 12),

          // Cart Items List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _cartTile(
                  category: 'Clothing',
                  title: 'Winter zipper hoodie',
                  price: '\$9.00',
                  qty: _qty1,
                  img: AppAssets.productFashion,
                  showOrangeTrash: true,
                  onQtyMinus: () => setState(() { if (_qty1 > 1) _qty1--; }),
                  onQtyPlus: () => setState(() => _qty1++),
                ),
                const SizedBox(height: 12),

                _cartTile(
                  category: 'Watches',
                  title: 'Full titanium Rolex with silver chains outside',
                  price: '\$50.00',
                  qty: _qty2,
                  img: AppAssets.productHeadphone,
                  onQtyMinus: () => setState(() { if (_qty2 > 1) _qty2--; }),
                  onQtyPlus: () => setState(() => _qty2++),
                ),
                const SizedBox(height: 12),

                _cartTile(
                  category: 'Shoes',
                  title: 'Vans OG 1994 with double sole and lace',
                  price: '\$35.00',
                  qty: _qty3,
                  img: AppAssets.productShoe,
                  onQtyMinus: () => setState(() { if (_qty3 > 1) _qty3--; }),
                  onQtyPlus: () => setState(() => _qty3++),
                ),
                const SizedBox(height: 12),

                _cartTile(
                  category: 'Clothing',
                  title: 'Thic fur sweatshirt for winter with hand gloves',
                  price: '\$14.00',
                  qty: _qty4,
                  img: AppAssets.productFashion,
                  onQtyMinus: () => setState(() { if (_qty4 > 1) _qty4--; }),
                  onQtyPlus: () => setState(() => _qty4++),
                ),
                const SizedBox(height: 12),

                _cartTile(
                  category: 'Clothing',
                  title: 'Baggy pants for winter with cushion inside',
                  price: '\$20.00',
                  qty: _qty5,
                  img: AppAssets.productSwitchConsole1,
                  onQtyMinus: () => setState(() { if (_qty5 > 1) _qty5--; }),
                  onQtyPlus: () => setState(() => _qty5++),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Bar matching 27_cart_2.png
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEAECF0))),
            ),
            child: SafeArea(
              top: false,
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
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.checkout),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        elevation: 0,
                      ),
                      child: const Text('Checkout (0)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentTab: NavTab.cart,
        cartBadgeCount: 3,
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
    bool showOrangeTrash = false,
    required VoidCallback onQtyMinus,
    required VoidCallback onQtyPlus,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              img, width: 72, height: 72, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: const Color(0xFFF2F4F7)),
            ),
          ),
          const SizedBox(width: 12),
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
          if (showOrangeTrash)
            Container(
              width: 50, height: 72,
              color: const Color(0xFFFFB74D),
              child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}
