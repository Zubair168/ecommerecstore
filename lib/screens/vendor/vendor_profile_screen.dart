import 'package:flutter/material.dart';

import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/routes/app_routes.dart';
import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';
import 'package:ecommerecstore/widgets/index.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  bool _isFollowing = false;

  static final _vendorProducts = [
    {
      'img': AppAssets.productSwitchConsole1,
      'title': 'Nintendo Switch OLED',
      'category': 'Gaming',
      'price': 299.99,
      'orig': 349.99,
      'rating': 4.8,
      'reviews': 124,
      'sold': 320,
    },
    {
      'img': AppAssets.productSwitchConsole2,
      'title': 'JBL Charge 5 Speaker',
      'category': 'Audio',
      'price': 149.99,
      'orig': 199.99,
      'rating': 4.7,
      'reviews': 134,
      'sold': 290,
    },
    {
      'img': AppAssets.productHeadphone,
      'title': 'Sony WH-1000XM5',
      'category': 'Electronics',
      'price': 199.99,
      'orig': 349.99,
      'rating': 4.9,
      'reviews': 342,
      'sold': 560,
    },
    {
      'img': AppAssets.productShoe,
      'title': 'Nike Air Max 2024',
      'category': 'Footwear',
      'price': 89.99,
      'orig': 130.00,
      'rating': 4.7,
      'reviews': 87,
      'sold': 210,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: CustomScrollView(
        slivers: [
          // ── Cover Banner + Header ─────────────────────────────────
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Cover image
                Container(
                  height: 140,
                  width: double.infinity,
                  color: AppColors.primary,
                  child: const Center(
                    child: Icon(
                      Icons.storefront_rounded,
                      size: 64,
                      color: Colors.white24,
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Vendor Avatar
                Positioned(
                  bottom: -36,
                  left: AppSpacing.space20,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primarySoft,
                      child: Icon(
                        Icons.store_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),

          // ── Vendor Info ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'TechWorld Official Store',
                                style: AppTypography.textTheme.headlineSmall,
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                color: AppColors.accentBlue,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Official Authorized Reseller · New York, USA',
                            style: AppTypography.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => _isFollowing = !_isFollowing),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFollowing
                              ? AppColors.backgroundAlt
                              : AppColors.primary,
                          foregroundColor: _isFollowing
                              ? AppColors.textPrimary
                              : Colors.white,
                          minimumSize: const Size(90, 38),
                          side: BorderSide(
                            color: _isFollowing
                                ? AppColors.border
                                : AppColors.primary,
                          ),
                        ),
                        child: Text(_isFollowing ? 'Following' : '+ Follow'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space16),

                  // Stats card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.space12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: AppSpacing.radiusLarge,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(value: '4.9 ⭐', label: 'Rating (2.4k)'),
                        _VertDivider(),
                        _StatItem(value: '98%', label: 'Positive Feedback'),
                        _VertDivider(),
                        _StatItem(value: '14.2k', label: 'Followers'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space20),

                  Text(
                    'Store Products (48)',
                    style: AppTypography.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.space12),
                ],
              ),
            ),
          ),

          // ── Product Grid ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final p = _vendorProducts[i];
                  return ProductCard(
                    title: p['title'] as String,
                    imageAsset: p['img'] as String,
                    category: p['category'] as String?,
                    price: p['price'] as double,
                    originalPrice: p['orig'] as double?,
                    rating: p['rating'] as double,
                    reviewCount: p['reviews'] as int,
                    soldCount: p['sold'] as int?,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.productDetails),
                    onWishlistTap: () {},
                  );
                },
                childCount: _vendorProducts.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.space16,
                mainAxisSpacing: AppSpacing.space16,
                childAspectRatio: 0.62,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.space40)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: AppColors.divider);
  }
}
