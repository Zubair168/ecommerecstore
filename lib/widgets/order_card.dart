import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Order status badge labels matching Figma.
enum OrderStatus { pending, processing, inDelivery, completed, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.inDelivery:
        return 'In Delivery';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get badgeColor {
    switch (this) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.processing:
        return AppColors.accentBlue;
      case OrderStatus.inDelivery:
        return AppColors.accentBlue;
      case OrderStatus.completed:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  Color get badgeBgColor {
    switch (this) {
      case OrderStatus.pending:
        return AppColors.warningBg;
      case OrderStatus.processing:
      case OrderStatus.inDelivery:
        return const Color(0xFFEFF8FF);
      case OrderStatus.completed:
        return AppColors.successBg;
      case OrderStatus.cancelled:
        return AppColors.errorBg;
    }
  }
}

/// Order summary card for the My Orders screen.
class OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final OrderStatus status;
  final double totalPrice;
  final int itemCount;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionLabel;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.status,
    required this.totalPrice,
    required this.itemCount,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    this.onSecondaryAction,
    this.secondaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.radiusLarge,
        border: Border.all(color: AppColors.border),
        boxShadow: AppSpacing.shadowLow,
      ),
      child: Column(
        children: [
          // Header strip
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #$orderId',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space12,
                    vertical: AppSpacing.space4,
                  ),
                  decoration: BoxDecoration(
                    color: status.badgeBgColor,
                    borderRadius: AppSpacing.radiusPill,
                  ),
                  child: Text(
                    status.label,
                    style: AppTypography.textTheme.labelSmall?.copyWith(
                      color: status.badgeColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider),
          // Summary row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
              vertical: AppSpacing.space12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$itemCount item${itemCount > 1 ? 's' : ''}',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Total: \$${totalPrice.toStringAsFixed(2)}',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space12),
            child: Row(
              children: [
                if (secondaryActionLabel != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSecondaryAction,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppSpacing.radiusMedium,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        secondaryActionLabel!,
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space8),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPrimaryAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.radiusMedium,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      primaryActionLabel,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
