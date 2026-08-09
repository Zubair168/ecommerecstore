import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';
import '../../services/product_service.dart';

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
  final List<String> _recentSearches = ['Hoodie', 'Sneakers', 'Headphones', 'Bag'];
  static const _popular = ['Men', 'Women', 'Shoes', 'Electronics', 'Bags', 'Watches'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _hasQuery = false;
        _results = [];
      });
      return;
    }

    setState(() {
      _hasQuery = true;
      _isSearching = true;
    });

    try {
      final snap = await ProductService.search(query);
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
          padding: const EdgeInsets.fromLTRB(AppSpacing.space16, 0, AppSpacing.space16, 0),
          child: CustomSearchBar(
            controller: _ctrl,
            hintText: 'Search products...',
            autofocus: true,
            onChanged: (v) => _performSearch(v),
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

  Widget _buildResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No results found for "${_ctrl.text}"', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.space16, AppSpacing.space12, AppSpacing.space16, 0),
          child: Text('${_results.length} results found', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.space16),
            itemCount: _results.length,
            separatorBuilder: (context, i) => const Divider(color: AppColors.divider, height: 16),
              final doc = _results[i];
              final data = doc.data() as Map<String, dynamic>;
              final String img = (data['images'] as List?)?.first?.toString() ?? '';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: AppSpacing.radiusMedium,
                  child: img.isNotEmpty 
                    ? (img.startsWith('http')
                        ? Image.network(img, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallbackIcon())
                        : Image.asset(img, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallbackIcon()))
                    : _fallbackIcon(),
                ),
                title: Text(data['name'] ?? '', style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(data['category'] ?? '', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                trailing: Text('\$${((data['price'] as num?) ?? 0).toStringAsFixed(2)}', style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
                onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: doc.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _fallbackIcon() {
    return Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.backgroundAlt, borderRadius: AppSpacing.radiusMedium), child: const Icon(Icons.image_outlined, color: AppColors.border, size: 28));
  }

  Widget _buildSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space16),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Recent Searches', style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            GestureDetector(onTap: () => setState(() => _recentSearches.clear()), child: Text('Clear All', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600))),
          ]),
          const SizedBox(height: AppSpacing.space12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _recentSearches.map((s) => GestureDetector(
              onTap: () { _ctrl.text = s; _performSearch(s); },
              child: Chip(
                label: Text(s),
                avatar: const Icon(Icons.history_rounded, size: 16, color: AppColors.textSecondary),
              ),
            )).toList(),
          ),
          const SizedBox(height: AppSpacing.space24),
        ],
        Text('Popular Categories', style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.space12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _popular.map((c) => GestureDetector(
            onTap: () { _ctrl.text = c; _performSearch(c); },
            child: CategoryChip(label: c, onTap: () { _ctrl.text = c; _performSearch(c); }),
          )).toList(),
        ),
      ],
    );
  }
}
