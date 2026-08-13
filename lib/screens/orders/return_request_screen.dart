import 'package:flutter/material.dart';

import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';
import 'package:ecommerecstore/widgets/index.dart';

class ReturnRequestScreen extends StatefulWidget {
  const ReturnRequestScreen({super.key});

  @override
  State<ReturnRequestScreen> createState() => _ReturnRequestScreenState();
}

class _ReturnRequestScreenState extends State<ReturnRequestScreen> {
  int _selectedReason = 0;
  int _selectedRefundMethod = 0;
  final _noteCtrl = TextEditingController();
  bool _loading = false;
  final Set<int> _selectedItems = {0};

  static const _reasons = [
    'Item arrived damaged',
    'Item is defective / not working',
    'Wrong item received',
    'Item does not match description',
    'Missing parts / accessories',
    'Changed my mind',
  ];

  static const _items = [
    ('Nintendo Switch OLED', '\$299.99', 'Black · 64GB'),
    ('Sony WH-1000XM5', '\$199.99', 'Midnight Blue'),
  ];

  static const _refundMethods = [
    'Original Payment Method',
    'Store Credit',
    'Bank Transfer',
  ];

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: CustomAppBar(
        title: 'Return Request',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.space16),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: AppSpacing.radiusLarge,
                border: Border.all(color: AppColors.success.withAlpha(80)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.space12),
                  Expanded(
                    child: Text(
                      'Returns accepted within 30 days of delivery. Items must be in original condition with packaging.',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space24),

            // Select items
            Text(
              'Select Items to Return',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.space12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppSpacing.radiusLarge,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _items.asMap().entries.map((e) {
                  final isLast = e.key == _items.length - 1;
                  final isSelected = _selectedItems.contains(e.key);
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() {
                          isSelected
                              ? _selectedItems.remove(e.key)
                              : _selectedItems.add(e.key);
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.space16),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  borderRadius: AppSpacing.radiusSmall,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: AppSpacing.space12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.value.$1,
                                      style: AppTypography.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      e.value.$3,
                                      style: AppTypography.textTheme.bodySmall
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                e.value.$2,
                                style: AppTypography.textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast)
                        const Divider(height: 1, color: AppColors.divider),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.space24),

            // Reason
            Text(
              'Reason for Return',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.space12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppSpacing.radiusLarge,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _reasons.asMap().entries.map((e) {
                  final isLast = e.key == _reasons.length - 1;
                  return Column(
                    children: [
                      RadioListTile<int>(
                        value: e.key,
                        groupValue: _selectedReason,
                        onChanged: (v) => setState(() => _selectedReason = v!),
                        fillColor: WidgetStateProperty.all(AppColors.primary),
                        title: Text(
                          e.value,
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.space16,
                          vertical: 2,
                        ),
                      ),
                      if (!isLast)
                        const Divider(
                          height: 1,
                          color: AppColors.divider,
                          indent: 16,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.space24),

            // Refund method
            Text(
              'Refund Method',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.space12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppSpacing.radiusLarge,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _refundMethods.asMap().entries.map((e) {
                  final isLast = e.key == _refundMethods.length - 1;
                  return Column(
                    children: [
                      RadioListTile<int>(
                        value: e.key,
                        groupValue: _selectedRefundMethod,
                        onChanged: (v) =>
                            setState(() => _selectedRefundMethod = v!),
                        fillColor: WidgetStateProperty.all(AppColors.primary),
                        title: Text(
                          e.value,
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.space16,
                          vertical: 2,
                        ),
                      ),
                      if (!isLast)
                        const Divider(
                          height: 1,
                          color: AppColors.divider,
                          indent: 16,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.space16),

            // Upload photos section
            Text(
              'Upload Photos (Optional)',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.space8),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppSpacing.radiusLarge,
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.textSecondary,
                        size: 32,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap to upload photos',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space16),

            // Notes
            Text(
              'Additional Notes (Optional)',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.space8),
            TextField(
              controller: _noteCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe the issue in detail...',
                hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space32),

            PrimaryButton(
              text: 'Submit Return Request',
              isLoading: _loading,
              onPressed: _selectedItems.isEmpty
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      final nav = Navigator.of(context);
                      await Future<void>.delayed(const Duration(milliseconds: 800));
                      if (!mounted) return;
                      nav.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Return request submitted successfully.',
                          ),
                        ),
                      );
                    },
            ),
            const SizedBox(height: AppSpacing.space40),
          ],
        ),
      ),
    );
  }
}
