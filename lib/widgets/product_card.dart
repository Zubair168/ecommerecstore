import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Product card matching Figma design exactly.
/// Layout: image (with discount badge + bare heart) → category → title → price row → rating row
class ProductCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final int? soldCount;
  final bool isWishlisted;
  final String? discountTag;
  final String? category;
  final VoidCallback onTap;
  final VoidCallback onWishlistTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.onTap,
    required this.onWishlistTap,
    this.originalPrice,
    this.isWishlisted = false,
    this.discountTag,
    this.category,
    this.soldCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image block ──────────────────────────────────────────
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      imageAsset,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, e, st) => Container(
                        color: const Color(0xFFF0F0F0),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Color(0xFFBDBDBD),
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Discount badge — top-left, salmon/orange pill
                  if (discountTag != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35), // salmon-orange
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          discountTag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),

                  // Wishlist heart — bare icon, no circle background
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onWishlistTap,
                      child: Icon(
                        isWishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 22,
                        color: isWishlisted
                            ? const Color(0xFFFF3B30)
                            : Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 6,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info block ────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category label
                    if (category != null)
                      Text(
                        category!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                    // Product title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),

                    // Price row: $20.00  $25.00̶
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF6B35), // matches Figma orange
                            fontSize: 13,
                          ),
                        ),
                        if (originalPrice != null) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '\$${originalPrice!.toStringAsFixed(2)}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Rating row: ★ 4.5 (2) 10 Sold
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFC107),
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${rating.toStringAsFixed(1)} ($reviewCount)',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (soldCount != null) ...[
                          Text(
                            ' $soldCount Sold',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
