import 'package:flutter/material.dart';

/// Product card matching design.
/// Optimized to prevent vertical overflows.
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
            // Image block
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    imageAsset,
                    width: double.infinity,
                    height: 140, // Fixed height to prevent overflow
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, e, st) => Container(
                      width: double.infinity,
                      height: 140,
                      color: const Color(0xFFF0F0F0),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFFBDBDBD),
                        size: 30,
                      ),
                    ),
                  ),
                ),
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
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        discountTag!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlistTap,
                    child: Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 20,
                      color: isWishlisted
                          ? const Color(0xFFFF3B30)
                          : Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black38, blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Info block
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (category != null)
                          Text(
                            category!,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 10,
                            ),
                          ),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF101828),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFF6B35),
                            fontSize: 13,
                          ),
                        ),
                        if (originalPrice != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '\$${originalPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Color(0xFF98A2B3),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFC107),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${rating.toStringAsFixed(1)} ($reviewCount)',
                          style: const TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (soldCount != null) ...[
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '| $soldCount Sold',
                              maxLines: 1,
                              style: const TextStyle(
                                color: Color(0xFF98A2B3),
                                fontSize: 10,
                              ),
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
