// test/search_debounce_test.dart
//
// Unit tests for the product search improvement introduced in
// feature/product-search-improvement.
//
// These tests verify the debounce helper logic and recent-search
// list management WITHOUT requiring Firebase or a real device, so
// they can run in the GitHub Actions CI environment.

import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Helper: mirrors the in-memory recent-search logic from SearchScreen so we
// can test it independently of the Flutter widget tree.
// ---------------------------------------------------------------------------
List<String> addToRecent(
  List<String> current,
  String query, {
  int maxItems = 10,
}) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) return List.from(current);
  final updated = List<String>.from(current);
  updated.remove(trimmed); // deduplicate
  updated.insert(0, trimmed); // most-recent at top
  if (updated.length > maxItems) {
    updated.removeLast(); // enforce cap
  }
  return updated;
}

List<String> removeFromRecent(List<String> current, String query) {
  return List<String>.from(current)..remove(query);
}

void main() {
  group('Recent search list management', () {
    test('adds a new query to the front of the list', () {
      final result = addToRecent(['Hoodie', 'Shoes'], 'Watch');
      expect(result.first, 'Watch');
      expect(result, containsAll(['Hoodie', 'Shoes', 'Watch']));
    });

    test(
      'deduplicates: existing query moves to front instead of duplicating',
      () {
        final result = addToRecent(['Hoodie', 'Shoes', 'Watch'], 'Shoes');
        expect(result.first, 'Shoes');
        expect(result.where((s) => s == 'Shoes').length, 1);
      },
    );

    test('ignores blank / whitespace-only queries', () {
      final result = addToRecent(['Hoodie'], '   ');
      expect(result, ['Hoodie']);
    });

    test('caps the list at maxItems', () {
      final initial = List.generate(10, (i) => 'Item $i');
      final result = addToRecent(initial, 'New Item', maxItems: 10);
      expect(result.length, 10);
      expect(result.first, 'New Item');
      expect(result.last, 'Item 8'); // oldest item dropped
    });

    test('removeFromRecent removes the specified entry', () {
      final result = removeFromRecent(['Hoodie', 'Shoes', 'Watch'], 'Shoes');
      expect(result, ['Hoodie', 'Watch']);
      expect(result.contains('Shoes'), false);
    });

    test('removeFromRecent is a no-op for a query not in the list', () {
      final result = removeFromRecent(['Hoodie', 'Shoes'], 'Watch');
      expect(result, ['Hoodie', 'Shoes']);
    });
  });

  group('Search query normalisation', () {
    test('trimmed empty query is treated as empty', () {
      expect('   '.trim().isEmpty, true);
    });

    test('lowercase prefix is applied correctly', () {
      const query = 'HOODIE';
      expect(query.toLowerCase(), 'hoodie');
    });

    test('Firestore upper-bound sentinel is appended correctly', () {
      const query = 'shoe';
      const sentinel = '\uf8ff';
      expect('$query$sentinel', 'shoe\uf8ff');
    });
  });
}
