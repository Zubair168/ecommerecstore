import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  bool _hasQuery = false;
  final List<String> _recentSearches = ['Nike Shoes', 'Gaming Console', 'Headphones', 'Levi\'s Jacket'];
  static const _popular = ['Electronics', 'Fashion', 'Beauty', 'Sports', 'Furniture', 'Home', 'Toys', 'Books'];

  // Fake results shown when user has a query
  static const _results = [
    (title: 'Nintendo Switch OLED', price: 299.99, category: 'Gaming'),
    (title: 'Sony WH-1000XM5 Headphones', price: 199.99, category: 'Electronics'),
    (title: 'Nike Air Max 2024', price: 89.99, category: 'Footwear'),
    (title: 'Apple AirPods Pro (2nd Gen)', price: 219.00, category: 'Electronics'),
    (title: 'Levi\'s Classic Denim Jacket', price: 59.99, category: 'Fashion'),
    (title: 'JBL Charge 5 Speaker', price: 149.99, category: 'Electronics'),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
            AppSpacing.space16, 0, AppSpacing.space16, 0),
          child: CustomSearchBar(
            controller: _ctrl,
            hintText: 'Search products...',
            autofocus: true,
            onChanged: (v) => setState(() => _hasQuery = v.trim().isNotEmpty),
            onFilterTap: () => Navigator.pushNamed(context, AppRoutes.filter),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _hasQuery ? _buildResults() : _buildSuggestions(),
    );
  }

  // ── Results grid ────────────────────────────────────────────────────────────
  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space16, AppSpacing.space12, AppSpacing.space16, 0),
          child: Text('${_results.length} results for "${_ctrl.text}"',
            style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.space16),
            itemCount: _results.length,
            separatorBuilder: (context, i) => const Divider(color: AppColors.divider, height: 16),
            itemBuilder: (context, i) {
              final r = _results[i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: AppColors.backgroundAlt, borderRadius: AppSpacing.radiusMedium),
                  child: const Icon(Icons.image_outlined, color: AppColors.border, size: 28),
                ),
                title: Text(r.title, style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(r.category, style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                trailing: Text('\$${r.price.toStringAsFixed(2)}',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
                onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Suggestions ─────────────────────────────────────────────────────────────
  Widget _buildSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space16),
      children: [
        // Recent
        if (_recentSearches.isNotEmpty) ...[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Recent Searches',
              style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            GestureDetector(
              onTap: () => setState(() => _recentSearches.clear()),
              child: Text('Clear All',
                style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: AppSpacing.space12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((s) => GestureDetector(
              onTap: () {
                _ctrl.text = s;
                setState(() => _hasQuery = true);
              },
              child: Chip(
                label: Text(s),
                avatar: const Icon(Icons.history_rounded, size: 16, color: AppColors.textSecondary),
                deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.textSecondary),
                onDeleted: () => setState(() => _recentSearches.remove(s)),
              ),
            )).toList(),
          ),
          const SizedBox(height: AppSpacing.space24),
        ],

        // Popular categories
        Text('Popular Categories',
          style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.space12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popular.map((c) => GestureDetector(
            onTap: () {
              _ctrl.text = c;
              setState(() => _hasQuery = true);
            },
            child: CategoryChip(label: c, onTap: () {
              _ctrl.text = c;
              setState(() => _hasQuery = true);
            }),
          )).toList(),
        ),
      ],
    );
  }
}
