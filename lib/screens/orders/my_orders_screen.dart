import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../services/order_service.dart';
import '../../services/auth_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _selectedFilter = 0; // 0: All, 1: Pending, 2: Processing, 3: Completed
  static const _filters = ['All', 'Pending', 'Processing', 'Completed'];

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
      body: StreamBuilder<User?>(
        stream: AuthService.authStateChanges,
        builder: (context, authSnap) {
          final user = authSnap.data;

          if (authSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle_outlined, size: 64, color: Color(0xFFD0D5DD)),
                  const SizedBox(height: 16),
                  const Text('Please sign in to view your orders',
                      style: TextStyle(fontSize: 16, color: Color(0xFF667085))),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            );
          }

          return Column(
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

              // Real-time Orders from Firestore
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: OrderService.userOrdersFor(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 12),
                            Text('Error loading orders: ${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    }

                    // Filter orders matching current user UID or guest orders
                    final userDocs = snapshot.data!.docs.where((doc) {
                      final d = doc.data() as Map<String, dynamic>;
                      final u = d['userId']?.toString();
                      return u == user.uid || u == 'guest' || u == null;
                    }).toList();

                    if (userDocs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text('No orders yet', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            const Text('Your completed orders will appear here', style: TextStyle(color: Color(0xFF98A2B3), fontSize: 13)),
                          ],
                        ),
                      );
                    }

                    final allOrders = List<QueryDocumentSnapshot>.from(userDocs);
                    allOrders.sort((a, b) {
                      final aData = a.data() as Map<String, dynamic>;
                      final bData = b.data() as Map<String, dynamic>;
                      final aTime = aData['createdAt'] as Timestamp?;
                      final bTime = bData['createdAt'] as Timestamp?;
                      if (aTime == null) return 1;
                      if (bTime == null) return -1;
                      return bTime.compareTo(aTime);
                    });

                    final filteredOrders = _selectedFilter == 0
                        ? allOrders
                        : allOrders.where((doc) =>
                            (doc.data() as Map)['status'] == _filters[_selectedFilter]).toList();

                    if (filteredOrders.isEmpty) {
                      return Center(
                        child: Text(
                          'No ${_filters[_selectedFilter]} orders',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final doc = filteredOrders[index];
                        final order = doc.data() as Map<String, dynamic>;
                        final items = (order['items'] as List?) ?? [];
                        final timestamp = order['createdAt'] as Timestamp?;
                        final dateStr = timestamp != null
                            ? DateFormat('MMM d, yyyy • hh:mm a').format(timestamp.toDate())
                            : 'Recent';
                        final orderId = doc.id;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order #${orderId.substring(0, 8).toUpperCase()}',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF344054), fontWeight: FontWeight.w700),
                                  ),
                                  Text(dateStr, style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3))),
                                ],
                              ),
                            ),
                            ...items.map((item) {
                              final itemData = item as Map<String, dynamic>;
                              final imgSrc = itemData['image']?.toString() ?? AppAssets.productFashion;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _OrderItemCard(
                                  title: itemData['title']?.toString() ?? 'Product',
                                  price: '\$${((itemData['price'] as num?) ?? 0).toStringAsFixed(2)}',
                                  qty: (itemData['quantity'] as int?) ?? 1,
                                  totalPrice: '\$${((order['total'] as num?) ?? 0).toStringAsFixed(2)}',
                                  img: imgSrc,
                                  status: order['status']?.toString() ?? 'Processing',
                                  paymentMethod: order['paymentMethod']?.toString() ?? 'COD',
                                  onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetails, arguments: order),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
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
      case 'completed': return const Color(0xFF027A48);
      case 'processing': return const Color(0xFF0086C9);
      case 'pending': return const Color(0xFF93370D);
      case 'cancelled': return const Color(0xFFB42318);
      default: return const Color(0xFF344054);
    }
  }

  Color get _statusBg {
    switch (status.toLowerCase()) {
      case 'completed': return const Color(0xFFECFDF3);
      case 'processing': return const Color(0xFFE0F2FE);
      case 'pending': return const Color(0xFFFEF6EE);
      case 'cancelled': return const Color(0xFFFEF3F2);
      default: return const Color(0xFFF2F4F7);
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
                  child: Builder(builder: (context) {
                    if (img.startsWith('http')) {
                      return Image.network(img, width: 72, height: 72, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: const Color(0xFFF2F4F7)));
                    }
                    return Image.asset(img, width: 72, height: 72, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: const Color(0xFFF2F4F7)));
                  }),
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
                            child: Text(title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF101828))),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: _statusBg, borderRadius: BorderRadius.circular(6)),
                            child: Text(status, style: TextStyle(color: _statusColor, fontSize: 10, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(price, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF344054))),
                          Text('Qty: $qty', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.payment_outlined, size: 12, color: Color(0xFF98A2B3)),
                              const SizedBox(width: 4),
                              Text(paymentMethod, style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3))),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                              children: [
                                const TextSpan(text: 'Total: '),
                                TextSpan(text: totalPrice,
                                    style: const TextStyle(color: kOrange, fontWeight: FontWeight.w800)),
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
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.returnRequest),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Cancel/Refund',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF344054))),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.productDetails),
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
            ),
          ],
        ),
      ),
    );
  }
}
