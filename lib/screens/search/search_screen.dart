import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerecstore/routes/app_routes.dart';
import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';
import 'package:ecommerecstore/widgets/index.dart';
import 'package:ecommerecstore/services/product_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  bool _hasQuery = false;
  List<DocumentSnapshot> _results = [];
  bool _isSearching = false;

  // Debounce timer — prevents a Firestore call on every single keystroke.
  // Search fires 300 ms after the user stops typing, reducing read costs
  // and avoiding flickering results during fast typing.
  Timer? _debounce;
  static const _kDebounceMs = 300;

  // Maximum number of recent searches to persist in memory
  static const _kMaxRecent = 10;

  final List<String> _recentSearches = [
    'Hoodie',
    'Sneakers',
    'Headphones',
    'Bag',
  ];

  static const _popular = [
    'Men',
    'Women',
    'Shoes',
    'Electronics',
    'Bags',
    'Watches',
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  /// Debounced search: only fires 300 ms after the user stops typing.
  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _hasQuery = false;
        _results = [];
        _isSearching = false;
      });
      return;
    }
    // Show loading immediately so the user knows input was registered.
    setState(() {
      _hasQuery = true;
      _isSearching = true;
    });
    _debounce = Timer(const Duration(milliseconds: _kDebounceMs), () {
      _performSearch(value);
    });
  }

  /// Executes a Firestore prefix search and updates results.
  Future<void> _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    try {
      final snap = await ProductService.search(trimmed);
      if (mounted) {
        setState(() {
          _results = snap.docs;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  /// Saves a query to the recent searches list (deduplicates, caps at max).
  void _saveRecentSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _recentSearches.remove(trimmed);
      _recentSearches.insert(0, trimmed);
      if (_recentSearches.length > _kMaxRecent) {
        _recentSearches.removeLast();
      }
    });
  }

  /// Removes a single entry from recent searches.
  void _removeRecentSearch(String query) {
    setState(() => _recentSearches.remove(query));
  }

  /// Triggers a search from a chip tap and records it as recent.
  void _searchFromChip(String query) {
    _ctrl.text = query;
    _debounce?.cancel();
    setState(() {
      _hasQuery = true;
      _isSearching = true;
    });
    _saveRecentSearch(query);
    _performSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space16,
            0,
            AppSpacing.space16,
            0,
          ),
          child: CustomSearchBar(
            controller: _ctrl,
            hintText: 'Search products...',
            autofocus: true,
            onChanged: _onSearchChanged,
            onFilterTap: () => Navigator.pushNamed(context, AppRoutes.filter),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _hasQuery ? _buildResults() : _buildSuggestions(),
    );
  }

  Widget _buildResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No results found for "${_ctrl.text}"',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try a different keyword',
              style: TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space16,
            AppSpacing.space12,
            AppSpacing.space16,
            0,
          ),
          child: Text(
            '${_results.length} result${_results.length == 1 ? '' : 's'} found',
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.space16),
            itemCount: _results.length,
            separatorBuilder: (context, i) =>
                const Divider(color: AppColors.divider, height: 16),
            itemBuilder: (context, i) {
              final doc = _results[i];
              final data = doc.data() as Map<String, dynamic>;
              final String img =
                  (data['images'] as List?)?.first?.toString() ?? '';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: AppSpacing.radiusMedium,
                  child: img.isNotEmpty
                      ? (img.startsWith('http')
                            ? Image.network(
                                img,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _fallbackIcon(),
                              )
                            : Image.asset(
                                img,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _fallbackIcon(),
                              ))
                      : _fallbackIcon(),
                ),
                title: Text(
                  (data['name'] as String?) ?? '',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  (data['category'] as String?) ?? '',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: Text(
                  '\$${((data['price'] as num?) ?? 0).toStringAsFixed(2)}',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                onTap: () {
                  _saveRecentSearch(_ctrl.text);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.productDetails,
                    arguments: doc.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _fallbackIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: AppSpacing.radiusMedium,
      ),
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.border,
        size: 28,
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space16),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _recentSearches.clear()),
                child: Text(
                  'Clear All',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),
          // Each recent search chip now includes an × dismiss button so users
          // can remove individual entries without clearing the entire history.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches
                .map(
                  (s) => InputChip(
                    label: Text(s),
                    avatar: const Icon(
                      Icons.history_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    deleteIcon: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    onDeleted: () => _removeRecentSearch(s),
                    onPressed: () => _searchFromChip(s),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.space24),
        ],
        Text(
          'Popular Categories',
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.space12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popular
              .map(
                (c) => GestureDetector(
                  onTap: () => _searchFromChip(c),
                  child: CategoryChip(
                    label: c,
                    onTap: () => _searchFromChip(c),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
