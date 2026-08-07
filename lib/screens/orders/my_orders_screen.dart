import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _selectedFilter = 0; // 0: All, 1: Pending, 2: Processing, 3: On hold

  static const _filters = ['All', 'Pending', 'Processing', 'On hold'];

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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Orders',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Horizontal Filter Chips matching 38_my_orders_1.png
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final isSelected = _selectedFilter == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? kNavy : const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _filters[i],
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF475467),
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Orders List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Group 1: Orders from oct 7 ,2025
                const Text('Orders from oct 7 ,2025',
                    style: TextStyle(fontSize: 13, color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                _OrderItemCard(
                  title: 'Winter Front Zipper hoodie',
                  price: '\$9.00',
                  qty: 2,
                  totalPrice: '\$18.00',
                  img: AppAssets.productFashion,
                  showBuyAgain: true,
                ),
                const SizedBox(height: 12),
                _OrderItemCard(
                  title: 'Full titanium Rolex watch',
                  price: '\$24.00',
                  qty: 1,
                  totalPrice: '\$24.00',
                  img: AppAssets.productHeadphone,
                  showBuyAgain: true,
                ),
                const SizedBox(height: 20),

                // Group 2: Orders from oct 6 ,2025
                const Text('Orders from oct 6 ,2025',
                    style: TextStyle(fontSize: 13, color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                _OrderItemCard(
                  title: 'Perfect shoes for trekking',
                  price: '\$20.00',
                  qty: 3,
                  totalPrice: '\$60.00',
                  img: AppAssets.productShoe,
                  showBuyAgain: true,
                ),
                const SizedBox(height: 12),
                _OrderItemCard(
                  title: 'Sleeveless t-shirt with fur inside',
                  price: '\$15.00',
                  qty: 2,
                  totalPrice: '\$30.00',
                  img: AppAssets.productFashion,
                  showBuyAgain: true,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final String title;
  final String price;
  final int qty;
  final String totalPrice;
  final String img;
  final bool showBuyAgain;

  const _OrderItemCard({
    required this.title,
    required this.price,
    required this.qty,
    required this.totalPrice,
    required this.img,
    this.showBuyAgain = false,
  });

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);
    const kOrange = Color(0xFFFF5722);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetails),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEAECF0)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(img, width: 72, height: 72, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: const Color(0xFFF2F4F7))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(price, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF344054))),
                          Text('Qty: $qty', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                            children: [
                              TextSpan(text: 'Total($qty items): '),
                              TextSpan(text: totalPrice, style: const TextStyle(color: kOrange, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.returnRequest),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Cancel/Refund', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF344054))),
                ),
                if (showBuyAgain) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Buy again', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
