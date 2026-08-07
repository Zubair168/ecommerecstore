import 'package:flutter/material.dart';

import '../../constants/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class CompareProductsScreen extends StatelessWidget {
  const CompareProductsScreen({super.key});

  static const _specs = [
    _Spec('Price', '\$299.99', '\$199.99'),
    _Spec('Brand', 'Nintendo', 'Sony'),
    _Spec('Rating', '4.8 ★', '4.6 ★'),
    _Spec('Connectivity', 'Wi-Fi / Bluetooth', 'Bluetooth 5.2'),
    _Spec('Battery', '4.5 hours', 'Up to 30 hours'),
    _Spec('Warranty', '1 Year', '1 Year'),
    _Spec('Weight', '297g', '254g'),
    _Spec('Availability', 'In Stock', 'In Stock'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: CustomAppBar(
        title: 'Compare Products',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Column(
          children: [
            // Product headers
            Row(
              children: [
                const SizedBox(width: 100),
                Expanded(child: _ProductHeader(
                  imageAsset: AppAssets.productSwitchConsole1,
                  name: 'Nintendo Switch OLED',
                  price: '\$299.99',
                )),
                const SizedBox(width: AppSpacing.space8),
                Expanded(child: _ProductHeader(
                  imageAsset: AppAssets.productHeadphone,
                  name: 'Sony WH-1000XM5',
                  price: '\$199.99',
                )),
              ],
            ),
            const SizedBox(height: AppSpacing.space16),

            // Spec rows
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppSpacing.radiusLarge,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _specs.asMap().entries.map((e) {
                  final isLast = e.key == _specs.length - 1;
                  return Column(
                    children: [
                      _SpecRow(spec: e.value),
                      if (!isLast) const Divider(height: 1, color: AppColors.divider),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.space24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Add to Cart',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: AppSpacing.space12),
                Expanded(
                  child: SecondaryButton(
                    text: 'Buy Now',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Spec {
  final String label;
  final String valueA;
  final String valueB;
  const _Spec(this.label, this.valueA, this.valueB);
}

class _ProductHeader extends StatelessWidget {
  final String imageAsset;
  final String name;
  final String price;

  const _ProductHeader({
    required this.imageAsset,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppSpacing.radiusLarge,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: AppSpacing.radiusMedium,
            child: Image.asset(
              imageAsset,
              width: double.infinity,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 90,
                color: AppColors.backgroundAlt,
                child: const Icon(Icons.image_outlined, color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTypography.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.space4),
          Text(price,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final _Spec spec;
  const _SpecRow({required this.spec});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16, vertical: AppSpacing.space12),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(spec.label,
                style: AppTypography.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(spec.valueA,
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: AppSpacing.space8),
          Expanded(
            child: Text(spec.valueB,
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
