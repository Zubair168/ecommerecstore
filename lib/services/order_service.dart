import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class OrderService {
  static final _db = FirebaseFirestore.instance;

  /// Stream of current user's orders (real-time)
  static Stream<QuerySnapshot> get ordersStream {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _db
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get a single order by ID
  static Future<DocumentSnapshot> getById(String id) =>
      _db.collection('orders').doc(id).get();

  /// Place a new order
  static Future<String> placeOrder({
    required List<Map<String, dynamic>> items,
    required double total,
    required Map<String, dynamic> shippingAddress,
    String paymentMethod = 'Credit Card',
  }) async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) throw Exception('Not authenticated');

    final docRef = _db.collection('orders').doc();
    await docRef.set({
      'id': docRef.id,
      'userId': uid,
      'items': items,
      'total': total,
      'status': 'Processing',
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
      'trackingNumber': 'TRK${DateTime.now().millisecondsSinceEpoch}',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  /// Update order status (admin / backend would normally do this)
  static Future<void> updateStatus(String orderId, String status) =>
      _db.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  /// Seed sample orders for the current user (demo purposes)
  static Future<void> seedOrders() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return;

    final snap =
        await _db.collection('orders').where('userId', isEqualTo: uid).limit(1).get();
    if (snap.docs.isNotEmpty) return; // already seeded

    final sampleOrders = [
      {
        'userId': uid,
        'items': [
          {'name': 'Slim Fit Navy Hoodie', 'qty': 1, 'price': 29.99, 'img': 'assets/raw/products/cat_fashion_men.png'},
          {'name': 'Classic Chino Pants', 'qty': 2, 'price': 34.99, 'img': 'assets/raw/products/cat_fashion_men.png'},
        ],
        'total': 99.97,
        'status': 'Delivered',
        'paymentMethod': 'Credit Card',
        'shippingAddress': {'street': '123 Main St', 'city': 'New York', 'state': 'NY', 'zip': '10001'},
        'trackingNumber': 'TRK1001234567',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 10))),
        'updatedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7))),
      },
      {
        'userId': uid,
        'items': [
          {'name': 'Pro Wireless Headphones', 'qty': 1, 'price': 89.99, 'img': 'assets/raw/products/cat_electronics.png'},
        ],
        'total': 89.99,
        'status': 'Shipped',
        'paymentMethod': 'PayPal',
        'shippingAddress': {'street': '456 Oak Ave', 'city': 'Los Angeles', 'state': 'CA', 'zip': '90001'},
        'trackingNumber': 'TRK9987654321',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3))),
        'updatedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      },
      {
        'userId': uid,
        'items': [
          {'name': 'Classic White Sneakers', 'qty': 1, 'price': 49.99, 'img': 'assets/raw/products/cat_shoes.png'},
          {'name': 'Brown Leather Crossbody', 'qty': 1, 'price': 44.99, 'img': 'assets/raw/products/cat_bags.png'},
        ],
        'total': 94.98,
        'status': 'Processing',
        'paymentMethod': 'Credit Card',
        'shippingAddress': {'street': '789 Pine Rd', 'city': 'Chicago', 'state': 'IL', 'zip': '60601'},
        'trackingNumber': 'TRK5544332211',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 6))),
        'updatedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 6))),
      },
    ];

    final batch = _db.batch();
    for (final order in sampleOrders) {
      batch.set(_db.collection('orders').doc(), order);
    }
    await batch.commit();
  }
}
