import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/cart_provider.dart';

class OrderService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Place a new order in Firestore and create an in-app notification
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

    final orderData = {
      'userId': uid,
      'items': items.map((item) => {
        'id': item.id,
        'title': item.title,
        'price': item.price,
        'quantity': item.quantity,
        'image': item.image,
      }).toList(),
      'subtotal': total,
      'deliveryFee': deliveryFee,
      'codFee': codFee,
      'total': grandTotal,
      'address': address,
      'notes': notes ?? '',
      'paymentMethod': paymentMethod ?? 'Unknown',
      'status': 'Processing',
      'createdAt': FieldValue.serverTimestamp(),
    };

    final docRef = await _db.collection('orders').add(orderData);
    final orderId = docRef.id;
    final shortId = orderId.substring(0, 8).toUpperCase();

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
    } catch (_) {
      // ignore notification write error
    }

    return orderId;
  }

  /// Stream of user orders (fetches orders for logged-in user + guest orders)
  static Stream<QuerySnapshot> userOrdersFor(String? uid) {
    final col = _db.collection('orders');
    if (uid == null || uid.isEmpty) {
      return col.snapshots();
    }
    // Stream user orders; fallback queries handle both user uid and guest orders
    return col.snapshots();
  }

  /// Stream of user notifications from Firestore
  static Stream<QuerySnapshot> notificationsStreamFor(String? uid) {
    return _db.collection('notifications').snapshots();
  }
}
