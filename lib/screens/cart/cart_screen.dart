import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/index.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _searchQuery = '';
  bool _selectAll = true;

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);
    
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();

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
              cart.clear();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stepper Dots at the top
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

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomSearchBar(
                hintText: 'Search in Cart...',
                onChanged: (v) {
                  setState(() {
                    _searchQuery = v.trim().toLowerCase();
                  });
                },
              ),
            ),
            const SizedBox(height: 8),

            // Cart Items List
            Expanded(
              child: Builder(builder: (context) {
                final cart = Provider.of<CartProvider>(context);
                final allItems = cart.items.values.toList();
                final visibleItems = allItems.where((it) {
                  final queryMatches = _searchQuery.isEmpty || 
                      it.title.toLowerCase().contains(_searchQuery) ||
                      it.category.toLowerCase().contains(_searchQuery);
                  return queryMatches;
                }).toList();

                if (allItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text('Your cart is empty', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  );
                }

                if (visibleItems.isEmpty) {
                  return const Center(child: Text('No items match your search', style: TextStyle(color: Color(0xFF667085))));
                }

                // Vertical List View is clean and avoids any tile sizing or overflow crashes
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: visibleItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = visibleItems[index];
                    return _cartTile(
                      category: item.category,
                      title: item.title,
                      price: '\$${(item.price).toStringAsFixed(2)}',
                      qty: item.quantity,
                      img: item.image,
                      onQtyMinus: () => cart.removeSingleItem(item.id),
                      onQtyPlus: () => cart.addItem(
                        productId: item.id,
                        title: item.title,
                        category: item.category,
                        price: item.price,
                        image: item.image,
                      ),
                      onDelete: () => cart.removeItem(item.id),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 10,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cartItems.isNotEmpty)
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
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.checkout),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          elevation: 0,
                          minimumSize: const Size(0, 0),
                        ),
                        child: Text('Checkout (${cart.totalQuantity}) • \$${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            CustomBottomNavBar(
              currentTab: NavTab.cart,
              cartBadgeCount: cart.totalQuantity,
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
                errorBuilder: (context, error, stackTrace) => Container(width: 72, height: 72, color: const Color(0xFFF2F4F7)),
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
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 50, height: 88,
              color: const Color(0xFFFFB74D),
              child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
