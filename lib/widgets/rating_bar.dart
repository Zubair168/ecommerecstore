import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';

/// Rating Star Widget displaying score and star icon
class RatingBar extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double iconSize;
  final bool showScoreText;

  const RatingBar({
    super.key,
    required this.rating,
    this.reviewCount,
    this.iconSize = 16.0,
    this.showScoreText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          AppAssets.iconStarFilled,
          width: iconSize,
          height: iconSize,
          colorFilter: const ColorFilter.mode(
            AppColors.starRating,
            BlendMode.srcIn,
          ),
        ),
        if (showScoreText) ...[
          const SizedBox(width: AppSpacing.space4),
          Text(
            rating.toStringAsFixed(1),
            style: AppTypography.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
        if (reviewCount != null) ...[
          const SizedBox(width: AppSpacing.space4),
          Text(
            '($reviewCount)',
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
