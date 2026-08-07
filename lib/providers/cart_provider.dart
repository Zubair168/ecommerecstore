import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final String category;
  final double price;
  int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    this.quantity = 1,
    required this.image,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  int get totalQuantity {
    var total = 0;
    _items.forEach((key, item) => total += item.quantity);
    return total;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) => total += item.price * item.quantity);
    return total;
  }

  void addItem({
    required String productId,
    required String title,
    required String category,
    required double price,
    required String image,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          category: existing.category,
          price: existing.price,
          quantity: existing.quantity + 1,
          image: existing.image,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          title: title,
          category: category,
          price: price,
          image: image,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          category: existing.category,
          price: existing.price,
          quantity: existing.quantity - 1,
          image: existing.image,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
