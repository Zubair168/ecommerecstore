import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: CustomAppBar(
        title: 'Track Order',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space16),
        children: [
          // ── Order info card ────────────────────────────────────────
          _InfoCard(
            children: [
              _InfoRow(label: 'Order ID', value: '#ORD-2026-0038'),
              const SizedBox(height: AppSpacing.space8),
              _InfoRow(label: 'Date', value: 'Aug 2, 2026'),
              const SizedBox(height: AppSpacing.space8),
              _InfoRow(label: 'Payment', value: 'Cash on Delivery'),
              const SizedBox(height: AppSpacing.space8),
              _InfoRow(label: 'Total', value: '\$299.99', valueColor: AppColors.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.space16),

          // ── Delivery address ───────────────────────────────────────
          _InfoCard(
            title: 'Delivery Address',
            children: [
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
                    child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: AppSpacing.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                        Text('123 Main Street, Apt 4B\nNew York, NY 10001, USA',
                          style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space16),

          // ── Timeline ──────────────────────────────────────────────
          _InfoCard(
            title: 'Order Status',
            children: [
              _TrackStep(
                icon: Icons.check_circle_rounded,
                title: 'Order Confirmed',
                subtitle: 'Aug 2, 2026 · 10:30 AM',
                isDone: true,
                isLast: false,
              ),
              _TrackStep(
                icon: Icons.inventory_2_rounded,
                title: 'Order Packed',
                subtitle: 'Aug 3, 2026 · 2:15 PM',
                isDone: true,
                isLast: false,
              ),
              _TrackStep(
                icon: Icons.local_shipping_rounded,
                title: 'Out for Delivery',
                subtitle: 'Aug 6, 2026 · 8:00 AM · Estimated delivery today',
                isDone: true,
                isActive: true,
                isLast: false,
              ),
              _TrackStep(
                icon: Icons.home_rounded,
                title: 'Delivered',
                subtitle: 'Estimated: Aug 6, 2026',
                isDone: false,
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space16),

          // ── Estimated delivery banner ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.space16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5722), Color(0xFFFF7043)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppSpacing.radiusLarge,
            ),
            child: Row(
              children: [
                const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 32),
                const SizedBox(width: AppSpacing.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Arriving Today!',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w800)),
                      Text('Your package is out for delivery',
                        style: AppTypography.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                    ],
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

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _InfoCard({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppSpacing.radiusLarge,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.space12),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTypography.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary)),
      ],
    );
  }
}

class _TrackStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDone;
  final bool isActive;
  final bool isLast;

  const _TrackStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.isLast,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive
        ? AppColors.primary
        : isDone
            ? AppColors.success
            : AppColors.border;

    final Color iconBg = isActive
        ? AppColors.primarySoft
        : isDone
            ? AppColors.successBg
            : AppColors.backgroundAlt;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + line
          Column(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isDone ? AppColors.success : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.space12),
          // Text
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(title,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                      color: isActive ? AppColors.primary : AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                    style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
