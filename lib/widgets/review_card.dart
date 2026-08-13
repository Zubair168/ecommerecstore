import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';
import 'package:ecommerecstore/widgets/rating_bar.dart';

/// Review card displayed in product details and review list screens.
class ReviewCard extends StatelessWidget {
  final String userName;
  final String avatarAsset;
  final double rating;
  final String date;
  final String comment;
  final List<String>? reviewImageAssets;
  final int likesCount;
  final bool hasLiked;
  final VoidCallback onLikeTap;

  const ReviewCard({
    super.key,
    required this.userName,
    required this.avatarAsset,
    required this.rating,
    required this.date,
    required this.comment,
    required this.likesCount,
    required this.onLikeTap,
    this.reviewImageAssets,
    this.hasLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: AppSpacing.radiusLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar, name, date, rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.border,
                child: SvgPicture.asset(
                  avatarAsset,
                  width: 32,
                  height: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      date,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              RatingBar(
                rating: rating,
                iconSize: 13,
                showScoreText: false,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),

          // Comment text
          Text(
            comment,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),

          // Review images
          if (reviewImageAssets != null && reviewImageAssets!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space12),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: reviewImageAssets!.length,
                separatorBuilder: (context, idx) =>
                    const SizedBox(width: AppSpacing.space8),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: AppSpacing.radiusSmall,
                  child: SvgPicture.asset(
                    reviewImageAssets![i],
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.space12),
          // Helpful like row
          Row(
            children: [
              Text(
                'Helpful?',
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.space8),
              GestureDetector(
                onTap: onLikeTap,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconLike,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        hasLiked ? AppColors.primary : AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space4),
                    Text(
                      '$likesCount',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: hasLiked
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
