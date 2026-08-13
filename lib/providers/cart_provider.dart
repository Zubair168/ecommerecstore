import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'price': price,
    'quantity': quantity,
    'image': image,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
    price: (json['price'] as num).toDouble(),
    quantity: (json['quantity'] as num).toInt(),
    image: json['image'] as String,
  );
}

class CartProvider with ChangeNotifier {
  static const _prefsKey = 'cart_items_v1';

  final Map<String, CartItem> _items = {};

  CartProvider();

  static Future<CartProvider> load() async {
    final provider = CartProvider();
    await provider._loadFromPrefs();
    return provider;
  }

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
        (existing) {
          existing.quantity += 1;
          return existing;
        },
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
    _saveToPrefs();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveToPrefs();
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    final existing = _items[productId]!;
    if (existing.quantity > 1) {
      existing.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    _saveToPrefs();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return;
      final Map<String, dynamic> data =
          json.decode(raw) as Map<String, dynamic>;
      data.forEach((key, value) {
        _items[key] = CartItem.fromJson(
          Map<String, dynamic>.from(value as Map),
        );
      });
    } catch (_) {
      // ignore errors and start with empty cart
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> data = {};
      _items.forEach((key, item) => data[key] = item.toJson());
      await prefs.setString(_prefsKey, json.encode(data));
    } catch (_) {
      // ignore save errors
    }
  }
}
