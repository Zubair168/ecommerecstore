import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  static final _db = FirebaseFirestore.instance;

  /// Stream of all products (real-time)
  static Stream<QuerySnapshot> get productsStream => _db
      .collection('products')
      .orderBy('createdAt', descending: true)
      .snapshots();

  /// Get products by category
  static Stream<QuerySnapshot> byCategory(String category) => _db
      .collection('products')
      .where('category', isEqualTo: category)
      .snapshots();

  /// Get a single product by ID
  static Future<DocumentSnapshot> getById(String id) =>
      _db.collection('products').doc(id).get();

  /// Search products by name (case-insensitive prefix)
  static Future<QuerySnapshot> search(String query) => _db
      .collection('products')
      .where('nameLower', isGreaterThanOrEqualTo: query.toLowerCase())
      .where('nameLower', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
      .get();

  /// Seed Firestore with initial product records
  static Future<void> seedProducts() async {
    final col = _db.collection('products');
    final snap = await col.limit(1).get();
    if (snap.docs.isNotEmpty) return; // already seeded

    final products = [
      // ── Men's Fashion ─────────────────────────────────────────────────
      {
        'name': 'Slim Fit Navy Hoodie',
        'nameLower': 'slim fit navy hoodie',
        'category': 'Men',
        'price': 29.99,
        'originalPrice': 45.00,
        'rating': 4.8,
        'reviewCount': 124,
        'badge': '-33%',
        'inStock': true,
        'images': ['assets/raw/products/cat_fashion_men.png'],
        'description':
            'Premium slim-fit hoodie in deep navy. Made from 100% organic cotton blend for maximum comfort and durability.',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Classic Chino Pants',
        'nameLower': 'classic chino pants',
        'category': 'Men',
        'price': 34.99,
        'originalPrice': 55.00,
        'rating': 4.6,
        'reviewCount': 87,
        'badge': '-36%',
        'inStock': true,
        'images': ['assets/raw/products/cat_fashion_men.png'],
        'description':
            'Tailored chino pants with a modern fit. Available in beige, khaki, and olive.',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'White Oxford Shirt',
        'nameLower': 'white oxford shirt',
        'category': 'Men',
        'price': 19.99,
        'originalPrice': 35.00,
        'rating': 4.5,
        'reviewCount': 203,
        'badge': '-43%',
        'inStock': true,
        'images': ['assets/raw/products/cat_fashion_men.png'],
        'description':
            'Crisp white Oxford-weave shirt. Wrinkle-resistant finish, perfect for work or casual wear.',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // ── Women's Fashion ────────────────────────────────────────────────
      {
        'name': 'Floral Wrap Dress',
        'nameLower': 'floral wrap dress',
        'category': 'Women',
        'price': 39.99,
        'originalPrice': 65.00,
        'rating': 4.9,
        'reviewCount': 312,
        'badge': '-38%',
        'inStock': true,
        'images': ['assets/raw/products/cat_fashion_women.png'],
        'description':
            'Elegant wrap dress with a vibrant floral print. Flattering A-line cut for all body types.',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Leather Tote Bag',
        'nameLower': 'leather tote bag',
        'category': 'Women',
        'price': 59.99,
        'originalPrice': 95.00,
        'rating': 4.7,
        'reviewCount': 156,
        'badge': '-37%',
        'inStock': true,
        'images': ['assets/raw/products/cat_fashion_women.png'],
        'description':
            'Premium genuine leather tote bag. Spacious interior with multiple pockets. Perfect for work and weekend.',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // ── Shoes ─────────────────────────────────────────────────────────
      {
        'name': 'Classic White Sneakers',
        'nameLower': 'classic white sneakers',
        'category': 'Shoes',
        'price': 49.99,
        'originalPrice': 80.00,
        'rating': 4.9,
        'reviewCount': 521,
        'badge': '-38%',
        'inStock': true,
        'images': ['assets/raw/products/cat_shoes.png'],
        'description':
            'Iconic clean-cut white sneakers with a chunky sole. Pairs with everything from jeans to dresses.',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Oxford Leather Shoes',
        'nameLower': 'oxford leather shoes',
        'category': 'Shoes',
        'price': 79.99,
        'originalPrice': 130.00,
        'rating': 4.6,
        'reviewCount': 98,
        'badge': '-38%',
        'inStock': true,
        'images': ['assets/raw/products/cat_shoes.png'],
        'description':
            'Handcrafted Oxford shoes in genuine dark brown leather. Brogue detailing for a distinguished look.',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // ── Electronics ───────────────────────────────────────────────────
      {
        'name': 'Pro Wireless Headphones',
        'nameLower': 'pro wireless headphones',
        'category': 'Electronics',
        'price': 89.99,
        'originalPrice': 149.00,
        'rating': 4.8,
        'reviewCount': 744,
        'badge': '-40%',
        'inStock': true,
        'images': ['assets/raw/products/cat_electronics.png'],
        'description':
            'Over-ear wireless headphones with active noise cancellation. 30-hour battery life. Premium sound quality.',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'True Wireless Earbuds',
        'nameLower': 'true wireless earbuds',
        'category': 'Electronics',
        'price': 39.99,
        'originalPrice': 70.00,
        'rating': 4.5,
        'reviewCount': 389,
        'badge': '-43%',
        'inStock': true,
        'images': ['assets/raw/products/cat_electronics.png'],
        'description':
            'Compact true wireless earbuds with 6-hour playtime + charging case. IPX5 water resistant.',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // ── Bags ──────────────────────────────────────────────────────────
      {
        'name': 'Brown Leather Crossbody',
        'nameLower': 'brown leather crossbody',
        'category': 'Bags',
        'price': 44.99,
        'originalPrice': 75.00,
        'rating': 4.7,
        'reviewCount': 211,
        'badge': '-40%',
        'inStock': true,
        'images': ['assets/raw/products/cat_bags.png'],
        'description':
            'Compact crossbody bag in genuine tan leather. Adjustable shoulder strap, gold-tone hardware.',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Canvas Weekend Backpack',
        'nameLower': 'canvas weekend backpack',
        'category': 'Bags',
        'price': 34.99,
        'originalPrice': 60.00,
        'rating': 4.4,
        'reviewCount': 167,
        'badge': '-42%',
        'inStock': true,
        'images': ['assets/raw/products/cat_bags.png'],
        'description':
            'Durable waxed canvas backpack. 30L capacity, laptop compartment, multiple organization pockets.',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // ── Watches ───────────────────────────────────────────────────────
      {
        'name': 'Steel Chronograph Watch',
        'nameLower': 'steel chronograph watch',
        'category': 'Watches',
        'price': 129.99,
        'originalPrice': 220.00,
        'rating': 4.9,
        'reviewCount': 88,
        'badge': '-41%',
        'inStock': true,
        'images': ['assets/raw/products/cat_watches.png'],
        'description':
            'Stainless steel chronograph with sapphire crystal glass. Water-resistant to 50m. Swiss movement.',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Gold Dress Watch',
        'nameLower': 'gold dress watch',
        'category': 'Watches',
        'price': 99.99,
        'originalPrice': 175.00,
        'rating': 4.7,
        'reviewCount': 62,
        'badge': '-43%',
        'inStock': true,
        'images': ['assets/raw/products/cat_watches.png'],
        'description':
            'Elegant gold-tone dress watch with minimalist white dial. Japanese quartz movement, genuine leather strap.',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    final batch = _db.batch();
    for (final product in products) {
      batch.set(col.doc(), product);
    }
    await batch.commit();
  }
}
