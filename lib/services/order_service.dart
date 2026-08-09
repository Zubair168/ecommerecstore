import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/cart_provider.dart';

class OrderService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Place a new order in Firestore
  static Future<String> placeOrder({
    required List<CartItem> items,
    required double total,
    double deliveryFee = 0.0,
    required String address,
    String? notes,
    String? paymentMethod,
  }) async {
    final user = _auth.currentUser;
    // Allow guest checkout in demo mode when no Firebase user is signed in.
    final uid = user?.uid ?? 'guest';

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
      'total': (total + deliveryFee),
      'address': address,
      'notes': notes ?? '',
      'paymentMethod': paymentMethod ?? 'Unknown',
      'status': 'Processing',
      'createdAt': FieldValue.serverTimestamp(),
    };

    final docRef = await _db.collection('orders').add(orderData);
    return docRef.id;
  }

  /// Stream of user orders
  static Stream<QuerySnapshot> userOrdersFor(String? uid) {
    final col = _db.collection('orders');
    final queryUid = uid ?? 'guest';
    return col.where('userId', isEqualTo: queryUid).snapshots();
  }
}
