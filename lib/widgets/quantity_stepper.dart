import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';

/// Compact ±1 quantity stepper used in Cart and Product Detail screens.
class QuantityStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  void _decrement() {
    if (value > min) onChanged(value - 1);
  }

  void _increment() {
    if (value < max) onChanged(value + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppSpacing.radiusMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          _StepperButton(
            icon: AppAssets.iconMinus,
            onPressed: value > min ? _decrement : null,
          ),
          Container(
            width: 1,
            height: 36,
            color: AppColors.border,
          ),
          // Value label
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                '$value',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 36,
            color: AppColors.border,
          ),
          // Plus button
          _StepperButton(
            icon: AppAssets.iconPlus,
            onPressed: value < max ? _increment : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onPressed;

  const _StepperButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppSpacing.radiusMedium,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              onPressed != null ? AppColors.primary : AppColors.textDisabled,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
