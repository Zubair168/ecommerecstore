import 'package:flutter/material.dart';

import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key});

  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  bool _isGridView = true;
  final Set<int> _wishlisted = {};

  static final _products = [
    {'img': AppAssets.productSwitchConsole1, 'title': 'Nintendo Switch OLED Console', 'category': 'Gaming', 'price': 299.99, 'orig': 349.99, 'rating': 4.8, 'reviews': 124, 'sold': 320, 'discount': '-15%'},
    {'img': AppAssets.productHeadphone, 'title': 'Sony WH-1000XM5 Headphones', 'category': 'Electronics', 'price': 199.99, 'orig': 349.99, 'rating': 4.9, 'reviews': 342, 'sold': 560, 'discount': '-43%'},
    {'img': AppAssets.productShoe, 'title': 'Nike Air Max 2024 Running Shoes', 'category': 'Footwear', 'price': 89.99, 'orig': 130.00, 'rating': 4.7, 'reviews': 87, 'sold': 210, 'discount': '-31%'},
    {'img': AppAssets.productFashion, 'title': 'Levi\'s Classic Denim Jacket', 'category': 'Fashion', 'price': 59.99, 'orig': 89.99, 'rating': 4.6, 'reviews': 56, 'sold': 120},
    {'img': AppAssets.productSwitchConsole2, 'title': 'JBL Charge 5 Portable Speaker', 'category': 'Audio', 'price': 149.99, 'orig': 199.99, 'rating': 4.7, 'reviews': 134, 'sold': 290},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: CustomAppBar(
        title: 'All Products',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded, color: AppColors.textPrimary),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.filter),
          ),
        ],
      ),
      body: Column(
        children: [
          // Sub-bar with count and active filters
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.space16, AppSpacing.space12, AppSpacing.space16, AppSpacing.space8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_products.length} Products Found',
                  style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.filter),
                  child: Row(
                    children: [
                      const Icon(Icons.sort_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('Sort & Filter', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isGridView ? _buildGrid() : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.space16),
      itemCount: _products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.space16,
        mainAxisSpacing: AppSpacing.space16,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, i) {
        final p = _products[i];
        return ProductCard(
          title: p['title'] as String,
          imageAsset: p['img'] as String,
          category: p['category'] as String?,
          price: p['price'] as double,
          originalPrice: p['orig'] as double?,
          rating: p['rating'] as double,
          reviewCount: p['reviews'] as int,
          soldCount: p['sold'] as int?,
          discountTag: p['discount'] as String?,
          isWishlisted: _wishlisted.contains(i),
          onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails),
          onWishlistTap: () => setState(() {
            _wishlisted.contains(i) ? _wishlisted.remove(i) : _wishlisted.add(i);
          }),
        );
      },
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.space16),
      itemCount: _products.length,
      separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.space12),
      itemBuilder: (context, i) {
        final p = _products[i];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.space12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppSpacing.radiusLarge,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppSpacing.radiusMedium,
                  child: Image.asset(p['img'] as String, width: 88, height: 88, fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(
                      width: 88, height: 88, color: AppColors.backgroundAlt,
                      child: const Icon(Icons.image_outlined, color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['title'] as String, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      RatingBar(rating: p['rating'] as double, reviewCount: p['reviews'] as int, iconSize: 13),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('\$${(p['price'] as double).toStringAsFixed(2)}',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
                          if (p['orig'] != null) ...[
                            const SizedBox(width: 6),
                            Text('\$${(p['orig'] as double).toStringAsFixed(2)}',
                              style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
