import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Cart item tile for the shopping cart screen.
/// Shows product image, title, attributes, price, stepper, and delete button.
class CartItemTile extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String attributes; // e.g., "Color: Black · Size: L"
  final double price;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete;

  const CartItemTile({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.attributes,
    required this.price,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.radiusLarge,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product thumbnail
          ClipRRect(
            borderRadius: AppSpacing.radiusMedium,
            child: Image.asset(
              imageAsset,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (ctx, e, st) => Container(
                width: 80,
                height: 80,
                color: AppColors.backgroundAlt,
                child: const Icon(Icons.image_not_supported_outlined,
                    color: AppColors.border, size: 28),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),

          // Info + controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppTypography.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    // Delete
                    GestureDetector(
                      onTap: onDelete,
                      child: SvgPicture.asset(
                        AppAssets.iconDelete,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.error,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  attributes,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.space8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '\$${(price * quantity).toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space8),
                    // Inline quantity stepper
                    _InlineQuantityStepper(
                      value: quantity,
                      onChanged: onQuantityChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineQuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _InlineQuantityStepper({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppSpacing.radiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PillBtn(
            icon: AppAssets.iconMinus,
            enabled: value > 1,
            onPressed: () => onChanged(value - 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space8),
            child: Text(
              '$value',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _PillBtn(
            icon: AppAssets.iconPlus,
            enabled: true,
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _PillBtn extends StatelessWidget {
  final String icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _PillBtn({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SvgPicture.asset(
          icon,
          width: 14,
          height: 14,
          colorFilter: ColorFilter.mode(
            enabled ? AppColors.primary : AppColors.textDisabled,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
