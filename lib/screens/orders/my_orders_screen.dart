import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/routes/app_routes.dart';
import 'package:ecommerecstore/services/order_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _selectedFilter = 0; // 0: All, 1: Pending, 2: Processing, 3: Completed
  static const _filters = ['All', 'Pending', 'Processing', 'Completed'];

  static double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic val) {
    if (val == null) return 1;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 1;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);

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
          'My Orders',
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
          // Filter Bar
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? kNavy : const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _filters[i],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF475467),
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Real-time Orders Stream combined with Local Persistence Fallback
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: OrderService.userOrdersFor(null),
              builder: (context, snapshot) {
                final ordersList = <Map<String, dynamic>>[];
                final seenIds = <String>{};

                // Add Firestore stream orders securely converting Map types
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  for (final doc in snapshot.data!.docs) {
                    try {
                      final rawData = doc.data();
                      if (rawData is Map) {
                        final data = Map<String, dynamic>.from(rawData);
                        data['id'] = doc.id;
                        ordersList.add(data);
                        seenIds.add(doc.id);
                      }
                    } catch (_) {}
                  }
                }

                // Merge local persistent orders so user NEVER sees blank screen
                for (final local in OrderService.localOrders) {
                  final id = local['id']?.toString() ?? '';
                  if (id.isNotEmpty && !seenIds.contains(id)) {
                    ordersList.add(local);
                    seenIds.add(id);
                  }
                }

                if (ordersList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No orders yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Your placed orders will appear here',
                          style: TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter by selected tab
                final targetStatus = _filters[_selectedFilter].toLowerCase();
                final filteredOrders = _selectedFilter == 0
                    ? ordersList
                    : ordersList.where((o) {
                        final st = (o['status'] ?? '').toString().toLowerCase();
                        return st == targetStatus;
                      }).toList();

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No ${_filters[_selectedFilter]} orders',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    try {
                      final order = filteredOrders[index];

                      // Safely extract items list without Map<dynamic, dynamic> cast crash
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
                        dateStr = DateFormat(
                          'MMM d, yyyy • hh:mm a',
                        ).format(timestamp.toDate());
                      } else if (timestamp != null) {
                        dateStr = timestamp.toString();
                      }

                      final orderId = (order['id'] ?? 'ZU0PZZLU').toString();
                      final shortId = orderId.length >= 8
                          ? orderId.substring(0, 8).toUpperCase()
                          : orderId;
                      final totalNum = _parseDouble(order['total']);
                      final statusStr =
                          order['status']?.toString() ?? 'Processing';
                      final payMethod =
                          order['paymentMethod']?.toString() ??
                          'Cash on Delivery';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #$shortId',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF344054),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  dateStr,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF98A2B3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (items.isEmpty)
                            _OrderItemCard(
                              title: 'Online Shop Order',
                              price: '\$${totalNum.toStringAsFixed(2)}',
                              qty: 1,
                              totalPrice: '\$${totalNum.toStringAsFixed(2)}',
                              img: AppAssets.productFashion,
                              status: statusStr,
                              paymentMethod: payMethod,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.orderDetails,
                                arguments: order,
                              ),
                            )
                          else
                            ...items.map((itemData) {
                              final titleStr =
                                  itemData['title']?.toString() ?? 'Product';
                              final priceNum = _parseDouble(itemData['price']);
                              final qtyNum = _parseInt(itemData['quantity']);
                              final imgSrc =
                                  itemData['image']?.toString() ??
                                  AppAssets.productFashion;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _OrderItemCard(
                                  title: titleStr,
                                  price: '\$${priceNum.toStringAsFixed(2)}',
                                  qty: qtyNum,
                                  totalPrice:
                                      '\$${totalNum.toStringAsFixed(2)}',
                                  img: imgSrc,
                                  status: statusStr,
                                  paymentMethod: payMethod,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.orderDetails,
                                    arguments: order,
                                  ),
                                ),
                              );
                            }).toList(),
                        ],
                      );
                    } catch (e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFEAECF0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.shopping_bag_outlined,
                                color: kNavy,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #${(filteredOrders[index]['id'] ?? '').toString().substring(0, 8).toUpperCase()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Tap to view details',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
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
  final String status;
  final String paymentMethod;
  final VoidCallback onTap;

  const _OrderItemCard({
    required this.title,
    required this.price,
    required this.qty,
    required this.totalPrice,
    required this.img,
    required this.status,
    required this.paymentMethod,
    required this.onTap,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF027A48);
      case 'processing':
        return const Color(0xFF0086C9);
      case 'pending':
        return const Color(0xFF93370D);
      case 'cancelled':
        return const Color(0xFFB42318);
      default:
        return const Color(0xFF344054);
    }
  }

  Color get _statusBg {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFFECFDF3);
      case 'processing':
        return const Color(0xFFE0F2FE);
      case 'pending':
        return const Color(0xFFFEF6EE);
      case 'cancelled':
        return const Color(0xFFFEF3F2);
      default:
        return const Color(0xFFF2F4F7);
    }
  }

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);
    const kOrange = Color(0xFFFF5722);

    return GestureDetector(
      onTap: onTap,
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
                  child: Builder(
                    builder: (context) {
                      if (img.startsWith('http')) {
                        return Image.network(
                          img,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 72,
                            height: 72,
                            color: const Color(0xFFF2F4F7),
                          ),
                        );
                      }
                      return Image.asset(
                        img,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 72,
                          height: 72,
                          color: const Color(0xFFF2F4F7),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF101828),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: _statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xFF344054),
                            ),
                          ),
                          Text(
                            'Qty: $qty',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.payment_outlined,
                                size: 12,
                                color: Color(0xFF98A2B3),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                paymentMethod,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF98A2B3),
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF667085),
                              ),
                              children: [
                                const TextSpan(text: 'Total: '),
                                TextSpan(
                                  text: totalPrice,
                                  style: const TextStyle(
                                    color: kOrange,
                                    fontWeight: FontWeight.w800,
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
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.returnRequest),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD0D5DD)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Cancel/Refund',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.productDetails),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: kNavy,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Buy again',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
