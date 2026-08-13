import 'package:flutter/material.dart';

import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';

/// Category icon card used in the horizontal list and category grid.
class CategoryCard extends StatelessWidget {
  final String title;
  final String iconAsset;
  final IconData iconData;
  final Color backgroundColor;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.iconAsset,
    required this.onTap,
    this.iconData = Icons.category_outlined,
    this.backgroundColor = const Color(0xFFF2F4F7),
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primarySoft : backgroundColor,
              borderRadius: AppSpacing.radiusLarge,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                iconData,
                size: 30,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact horizontal category chip (pill-shaped) for filter bars.
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.backgroundAlt,
          borderRadius: AppSpacing.radiusPill,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
