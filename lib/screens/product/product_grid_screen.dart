import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';
import '../../services/product_service.dart';

class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key});

  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  bool _isGridView = true;
  final Set<String> _wishlisted = {};

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
      body: StreamBuilder<QuerySnapshot>(
        stream: ProductService.productsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.space16, AppSpacing.space12, AppSpacing.space16, AppSpacing.space8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${docs.length} Products Found',
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
                child: _isGridView ? _buildGrid(docs) : _buildList(docs),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildGrid(List<DocumentSnapshot> docs) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.space16),
      itemCount: docs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.space16,
        mainAxisSpacing: AppSpacing.space16,
        childAspectRatio: 0.6,
      ),
        itemBuilder: (context, i) {
        final data = docs[i].data() as Map<String, dynamic>;
        final id = docs[i].id;
        return ProductCard(
          title: data['name'] ?? '',
          imageAsset: (data['images'] as List?)?.first ?? AppAssets.productFashion,
          category: data['category'],
          price: (data['price'] ?? 0).toDouble(),
          originalPrice: (data['originalPrice'] ?? 0).toDouble(),
          rating: (data['rating'] ?? 0).toDouble(),
          reviewCount: data['reviewCount'] ?? 0,
          discountTag: data['badge'],
          isWishlisted: _wishlisted.contains(id),
          onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: id),
          onWishlistTap: () => setState(() {
            _wishlisted.contains(id) ? _wishlisted.remove(id) : _wishlisted.add(id);
          }),
        );
      },
    );
  }

  Widget _buildList(List<DocumentSnapshot> docs) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.space16),
      itemCount: docs.length,
      separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.space12),
      itemBuilder: (context, i) {
        final data = docs[i].data() as Map<String, dynamic>;
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.space12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: AppSpacing.radiusLarge, border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppSpacing.radiusMedium,
                  child: Image.asset((data['images'] as List?)?.first ?? '', width: 88, height: 88, fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(width: 88, height: 88, color: AppColors.backgroundAlt, child: const Icon(Icons.image_outlined, color: AppColors.border)),
                  ),
                ),
                const SizedBox(width: AppSpacing.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      RatingBar(rating: (data['rating'] ?? 0).toDouble(), reviewCount: data['reviewCount'] ?? 0, iconSize: 13),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('\$${(data['price'] ?? 0).toStringAsFixed(2)}', style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
                          if (data['originalPrice'] != null) ...[
                            const SizedBox(width: 6),
                            Text('\$${(data['originalPrice']).toStringAsFixed(2)}', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
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
