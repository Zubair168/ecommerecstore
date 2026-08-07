import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int _selectedTab = 0; // 0: Order details, 1: Track order

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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF344054), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Order',
            style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Toggle Bar matching 36_order_details.png
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? kNavy : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Order details',
                          style: TextStyle(
                            color: _selectedTab == 0 ? Colors.white : const Color(0xFF667085),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? kNavy : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Track order',
                          style: TextStyle(
                            color: _selectedTab == 1 ? Colors.white : const Color(0xFF667085),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Section: Your order
                _SectionBlock(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Your order',
                  child: Column(
                    children: [
                      _ProductRow(
                        category: 'Clothing',
                        title: 'Winter Front Zipper And Front Pocket Hoodie Warm For Men',
                        price: '\$9.00',
                        origPrice: '\$18.00',
                        img: AppAssets.productFashion,
                      ),
                      const SizedBox(height: 12),
                      _ProductRow(
                        category: 'Watches',
                        title: 'Full titanium Rolex with silver chains outside',
                        price: '\$50.00',
                        origPrice: '\$80.00',
                        img: AppAssets.productHeadphone,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Section: Delivery Address
                _SectionBlock(
                  icon: Icons.location_on_outlined,
                  title: 'Delivery Address',
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.location_on_outlined, color: Color(0xFF475467), size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Home', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF101828))),
                            SizedBox(height: 3),
                            Text('Max Tiger ( +100 123 1245 3534)', style: TextStyle(fontSize: 12, color: Color(0xFF475467))),
                            SizedBox(height: 2),
                            Text('00000, Al Garhoud, Dubai, United Arab Emirates', style: TextStyle(fontSize: 12, color: Color(0xFF667085))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Section: Delivery
                _SectionBlock(
                  icon: Icons.local_shipping_outlined,
                  title: 'Delivery',
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.local_shipping_rounded, size: 20, color: Color(0xFF344054)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Express Delivery', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF101828))),
                          SizedBox(height: 2),
                          Text('Estimated delivery Aug 24 - 26', style: TextStyle(fontSize: 12, color: Color(0xFF667085))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Section: Coupon & Voucher
                _SectionBlock(
                  icon: Icons.confirmation_number_outlined,
                  title: 'Coupon & Voucher',
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFFFFECB3), shape: BoxShape.circle),
                        child: const Icon(Icons.percent_rounded, size: 16, color: Color(0xFFFF9800)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('20% OFF on All Fashion Items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF101828))),
                          SizedBox(height: 2),
                          Text('Use Code: FASHION20   Valid till Nov 30, 2025', style: TextStyle(fontSize: 11, color: Color(0xFF667085))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Section: Payment Details
                _SectionBlock(
                  icon: Icons.credit_card_outlined,
                  title: 'Payment Details',
                  child: Column(
                    children: [
                      _DetailRow('Sub total (2 items)', '\$59.00'),
                      const SizedBox(height: 8),
                      _DetailRow('Discount applied', '\$14.00'),
                      const SizedBox(height: 8),
                      _DetailRow('Shipping Fee', '\$8.00'),
                      const SizedBox(height: 8),
                      _DetailRow('Promo', '-\$10.00'),
                      const SizedBox(height: 8),
                      _DetailRow('Estimated VAT', '\$4.00'),
                      const Divider(height: 20, color: Color(0xFFEAECF0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF101828))),
                          Text('\$52.00', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kOrange)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Section: Order Summary
                _SectionBlock(
                  icon: Icons.receipt_long_outlined,
                  title: 'Order Summary',
                  child: Column(
                    children: const [
                      _DetailRow('Order ID', '#ORD57231', isBold: true),
                      SizedBox(height: 8),
                      _DetailRow('Order date', '21 Aug, 2025'),
                      SizedBox(height: 8),
                      _DetailRow('Payment method', 'Cash on delivery'),
                      SizedBox(height: 8),
                      _DetailRow('Tracking ID:', 'SDX1023947'),
                      SizedBox(height: 8),
                      _DetailRow('Delivery Partner:', 'SwiftDrop Logistics'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Bottom Action: Cancel Order Button (Dark Navy)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.cancelRequest),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Cancel Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionBlock({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF475467)),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF101828))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final String category;
  final String title;
  final String price;
  final String origPrice;
  final String img;

  const _ProductRow({
    required this.category,
    required this.title,
    required this.price,
    required this.origPrice,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(img, width: 64, height: 64, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: const Color(0xFFF2F4F7))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category, style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
              const SizedBox(height: 2),
              Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF101828))),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(price, style: const TextStyle(color: Color(0xFFFF5722), fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(width: 6),
                  Text(origPrice, style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF98A2B3), fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _DetailRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF667085), fontSize: 13)),
        Text(value, style: TextStyle(color: const Color(0xFF101828), fontSize: 13, fontWeight: isBold ? FontWeight.w800 : FontWeight.w600)),
      ],
    );
  }
}
