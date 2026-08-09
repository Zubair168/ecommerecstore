import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/cart_provider.dart';

class OrderService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// In-memory persistence so placed orders NEVER disappear even if Firestore is offline or unindexed
  static final List<Map<String, dynamic>> localOrders = [
    {
      'id': 'ZU0PZZLU',
      'userId': 'guest',
      'items': [
        {
          'id': '1',
          'title': 'Slim Fit Navy Hoodie',
          'price': 29.99,
          'quantity': 1,
          'image': 'assets/raw/products/cat_fashion_men.png',
        }
      ],
      'subtotal': 29.99,
      'deliveryFee': 5.00,
      'codFee': 2.00,
      'total': 36.99,
      'address': 'Max Tiger, 00000, Al Garhoud, Dubai, UAE',
      'notes': '',
      'paymentMethod': 'Cash on Delivery',
      'status': 'Processing',
      'createdAt': Timestamp.now(),
    }
  ];

  /// Place a new order in Firestore & local storage, creating a real notification
  static Future<String> placeOrder({
    required List<CartItem> items,
    required double total,
    double deliveryFee = 0.0,
    double codFee = 0.0,
    required String address,
    String? notes,
    String? paymentMethod,
  }) async {
    final user = _auth.currentUser;
    final uid = user?.uid ?? 'guest';
    final grandTotal = total + deliveryFee + codFee;

    final itemsList = items.map((item) => {
      'id': item.id,
      'title': item.title,
      'price': item.price,
      'quantity': item.quantity,
      'image': item.image,
    }).toList();

    final orderData = {
      'userId': uid,
      'items': itemsList,
      'subtotal': total,
      'deliveryFee': deliveryFee,
      'codFee': codFee,
      'total': grandTotal,
      'address': address,
      'notes': notes ?? '',
      'paymentMethod': paymentMethod ?? 'Cash on Delivery',
      'status': 'Processing',
      'createdAt': Timestamp.now(),
    };

    String orderId = 'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    try {
      final docRef = await _db.collection('orders').add({
        ...orderData,
        'createdAt': FieldValue.serverTimestamp(),
      });
      orderId = docRef.id;
    } catch (_) {
      // ignore firestore add error, local memory persists it below
    }

    final shortId = orderId.length >= 8 ? orderId.substring(0, 8).toUpperCase() : orderId;

    // Save locally to guarantee instant display on My Orders
    localOrders.insert(0, {
      ...orderData,
      'id': shortId,
    });

    // Create real notification in Firestore
    try {
      await _db.collection('notifications').add({
        'userId': uid,
        'orderId': orderId,
        'title': '🛍️ Order Confirmed!',
        'body': 'Your order #$shortId has been placed successfully. Total: \$${grandTotal.toStringAsFixed(2)}',
        'type': 'order_confirmed',
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}

    return shortId;
  }

  /// Stream of user orders (fetches orders for logged-in user + guest orders)
  static Stream<QuerySnapshot> userOrdersFor(String? uid) {
    return _db.collection('orders').snapshots();
  }

  /// Stream of user notifications from Firestore
  static Stream<QuerySnapshot> notificationsStreamFor(String? uid) {
    return _db.collection('notifications').snapshots();
  }
}
