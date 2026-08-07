import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _priceRange = const RangeValues(20, 500);
  int _selectedCategory = 0;
  int _selectedSort = 0;
  double _minRating = 4.0;
  final Set<String> _selectedBrands = {'Nike', 'Sony'};

  static const _categories = ['All', 'Electronics', 'Fashion', 'Beauty', 'Sports', 'Furniture'];
  static const _sortOptions = ['Popularity', 'Price: Low to High', 'Price: High to Low', 'Newest', 'Customer Rating'];
  static const _brands = ['Nike', 'Sony', 'Nintendo', 'Adidas', 'Apple', 'Levi\'s', 'JBL', 'Samsung'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Filter & Sort',
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _priceRange = const RangeValues(0, 1000);
              _selectedCategory = 0;
              _selectedSort = 0;
              _minRating = 0;
              _selectedBrands.clear();
            }),
            child: Text('Reset', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space24),
        children: [
          // ── Category ─────────────────────────────────────────────
          _FilterSectionTitle(title: 'Category'),
          const SizedBox(height: AppSpacing.space12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_categories.length, (i) => CategoryChip(
              label: _categories[i],
              isSelected: _selectedCategory == i,
              onTap: () => setState(() => _selectedCategory = i),
            )),
          ),
          const SizedBox(height: AppSpacing.space24),
          const Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.space16),

          // ── Sort By ──────────────────────────────────────────────
          _FilterSectionTitle(title: 'Sort By'),
          const SizedBox(height: AppSpacing.space12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_sortOptions.length, (i) => ChoiceChip(
              label: Text(_sortOptions[i]),
              selected: _selectedSort == i,
              selectedColor: AppColors.primarySoft,
              labelStyle: AppTypography.textTheme.bodySmall?.copyWith(
                color: _selectedSort == i ? AppColors.primary : AppColors.textSecondary,
                fontWeight: _selectedSort == i ? FontWeight.w700 : FontWeight.w500,
              ),
              side: BorderSide(color: _selectedSort == i ? AppColors.primary : AppColors.border),
              onSelected: (_) => setState(() => _selectedSort = i),
            )),
          ),
          const SizedBox(height: AppSpacing.space24),
          const Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.space16),

          // ── Price Range ───────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _FilterSectionTitle(title: 'Price Range'),
              Text('\$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
                style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 100,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.border,
            onChanged: (v) => setState(() => _priceRange = v),
          ),
          const SizedBox(height: AppSpacing.space16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.space16),

          // ── Rating ────────────────────────────────────────────────
          _FilterSectionTitle(title: 'Minimum Rating'),
          const SizedBox(height: AppSpacing.space12),
          Row(
            children: [4.5, 4.0, 3.5, 3.0].map((r) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text('$r+'),
                  ],
                ),
                selected: _minRating == r,
                selectedColor: AppColors.primarySoft,
                side: BorderSide(color: _minRating == r ? AppColors.primary : AppColors.border),
                onSelected: (_) => setState(() => _minRating = r),
              ),
            )).toList(),
          ),
          const SizedBox(height: AppSpacing.space24),
          const Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.space16),

          // ── Brand ─────────────────────────────────────────────────
          _FilterSectionTitle(title: 'Brand'),
          const SizedBox(height: AppSpacing.space12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _brands.map((b) {
              final selected = _selectedBrands.contains(b);
              return FilterChip(
                label: Text(b),
                selected: selected,
                selectedColor: AppColors.primarySoft,
                checkmarkColor: AppColors.primary,
                labelStyle: AppTypography.textTheme.bodySmall?.copyWith(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                onSelected: (val) => setState(() {
                  val ? _selectedBrands.add(b) : _selectedBrands.remove(b);
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.space40),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space16, AppSpacing.space12, AppSpacing.space16, AppSpacing.space24),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: PrimaryButton(
          text: 'Apply Filter',
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class _FilterSectionTitle extends StatelessWidget {
  final String title;

  const _FilterSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700));
  }
}
