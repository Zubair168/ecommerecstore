import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Reusable Search Bar input with filter button icon option
class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool readOnly;
  final bool autofocus;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search category, product...',
    this.onTap,
    this.onChanged,
    this.onFilterTap,
    this.readOnly = false,
    this.autofocus = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: AppSpacing.radiusMedium,
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        autofocus: autofocus,
        onTap: onTap,
        onChanged: onChanged,
        style: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(AppSpacing.space12),
            child: SvgPicture.asset(
              AppAssets.navSearch,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: onFilterTap != null
              ? IconButton(
                  icon: SvgPicture.asset(
                    AppAssets.iconFilterConfig,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: onFilterTap,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSpacing.space14,
          ),
        ),
      ),
    );
  }
}
