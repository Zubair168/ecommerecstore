import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/routes/app_routes.dart';

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

    final rawArg = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? order = rawArg is Map
        ? Map<String, dynamic>.from(rawArg)
        : null;

    if (order == null) {
      return const Scaffold(body: Center(child: Text('No order data found')));
    }

    final rawItems = order['items'];
    final List<Map<String, dynamic>> items = [];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map) {
          items.add(Map<String, dynamic>.from(item));
        }
      }
    }

    final timestamp = order['createdAt'];
    String dateStr = 'Recent';
    if (timestamp is Timestamp) {
      dateStr = DateFormat('MMM d, yyyy').format(timestamp.toDate());
    } else if (timestamp != null) {
      dateStr = timestamp.toString();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF344054),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order',
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Toggle Bar
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
                            color: _selectedTab == 0
                                ? Colors.white
                                : const Color(0xFF667085),
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
                            color: _selectedTab == 1
                                ? Colors.white
                                : const Color(0xFF667085),
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
            child: _selectedTab == 1
                ? _buildTrackOrderView(order, dateStr, kNavy, kOrange)
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Section: Your order
                      _SectionBlock(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Your order',
                        child: Column(
                          children: items.map((item) {
                            final itemData =
                                Map<String, dynamic>.from(item);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ProductRow(
                                category: 'Product',
                                title:
                                    itemData['title']?.toString() ?? 'Product',
                                price:
                                    '\$${((itemData['price'] as num?) ?? 0).toStringAsFixed(2)}',
                                qty:
                                    (itemData['quantity'] as num?)?.toInt() ??
                                    1,
                                img:
                                    itemData['image']?.toString() ??
                                    AppAssets.productFashion,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Section: Delivery Address
                      _SectionBlock(
                        icon: Icons.location_on_outlined,
                        title: 'Delivery Address',
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF475467),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Default Address',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: Color(0xFF101828),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    (order['address'] as String?) ?? 'No address provided',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF667085),
                                    ),
                                  ),
                                ],
                              ),
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
                            _DetailRow(
                              'Sub total',
                              '\$${((order['subtotal'] as num?) ?? order['total'] as num? ?? 0).toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: 8),
                            _DetailRow(
                              'Delivery Fee',
                              '\$${((order['deliveryFee'] as num?) ?? 5.0).toStringAsFixed(2)}',
                            ),
                            if (order['codFee'] != null &&
                                (order['codFee'] as num) > 0) ...[
                              const SizedBox(height: 8),
                              _DetailRow(
                                'COD Fee',
                                '\$${((order['codFee'] as num)).toStringAsFixed(2)}',
                              ),
                            ],
                            const Divider(height: 20, color: Color(0xFFEAECF0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Color(0xFF101828),
                                  ),
                                ),
                                Text(
                                  '\$${((order['total'] as num?) ?? 0).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: kOrange,
                                  ),
                                ),
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
                          children: [
                            _DetailRow(
                              'Order ID',
                              '#${(order['id'] ?? 'N/A').toString().substring(0, 8).toUpperCase()}',
                              isBold: true,
                            ),
                            const SizedBox(height: 8),
                            _DetailRow('Order date', dateStr),
                            const SizedBox(height: 8),
                             _DetailRow(
                               'Payment method',
                               (order['paymentMethod'] as String?) ?? 'Cash on delivery',
                             ),
                             const SizedBox(height: 8),
                             _DetailRow(
                               'Status',
                               (order['status'] as String?) ?? 'Processing',
                             ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Bottom Action: Cancel Order Button (Dark Navy)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.cancelRequest,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kNavy,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Cancel Order',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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

  Widget _buildTrackOrderView(
    Map<String, dynamic> order,
    String dateStr,
    Color kNavy,
    Color kOrange,
  ) {
    final status = (order['status'] ?? 'Processing').toString().toLowerCase();
    final steps = [
      {
        'title': 'Order Placed',
        'desc': 'Order has been placed on $dateStr',
        'isDone': true,
      },
      {
        'title': 'Processing',
        'desc': 'Seller is preparing your item(s)',
        'isDone': status != 'pending',
      },
      {
        'title': 'Shipped',
        'desc': 'Courier has picked up your package',
        'isDone': status == 'shipped' || status == 'completed',
      },
      {
        'title': 'Out for Delivery',
        'desc': 'Package is on its way to your address',
        'isDone': status == 'completed',
      },
      {
        'title': 'Delivered',
        'desc': 'Package handed over successfully',
        'isDone': status == 'completed',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEAECF0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Estimated Delivery',
                    style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      (order['status'] as String?) ?? 'Processing',
                      style: const TextStyle(
                        color: Color(0xFF027A48),
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                '3-5 Business Days',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101828),
                ),
              ),
              const Divider(height: 24, color: Color(0xFFEAECF0)),
              ...List.generate(steps.length, (idx) {
                final step = steps[idx];
                final isDone = step['isDone'] as bool;
                final isLast = idx == steps.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isDone ? kNavy : const Color(0xFFF2F4F7),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDone ? kNavy : const Color(0xFFD0D5DD),
                              width: 2,
                            ),
                          ),
                          child: isDone
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 14,
                                )
                              : null,
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 38,
                            color: isDone ? kNavy : const Color(0xFFEAECF0),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isDone
                                    ? const Color(0xFF101828)
                                    : const Color(0xFF98A2B3),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              step['desc'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF667085),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionBlock({
    required this.icon,
    required this.title,
    required this.child,
  });

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
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF101828),
                  ),
                ),
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
  final int qty;
  final String img;

  const _ProductRow({
    required this.category,
    required this.title,
    required this.price,
    required this.qty,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            img,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 64,
              height: 64,
              color: const Color(0xFFF2F4F7),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3)),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFFFF5722),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Qty: $qty',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF667085),
                    ),
                  ),
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
        Text(
          label,
          style: const TextStyle(color: Color(0xFF667085), fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF101828),
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
