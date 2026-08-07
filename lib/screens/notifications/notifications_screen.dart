import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotifItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  bool isRead;

  _NotifItem({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.title, required this.body, required this.time, this.isRead = false,
  });
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotifItem> _items = [
    _NotifItem(icon: Icons.local_shipping_outlined, iconBg: const Color(0xFFEFF8FF), iconColor: AppColors.accentBlue,
      title: 'Order Shipped!', body: 'Your order #ORD-2026-0038 is on its way. Track it now.', time: '2 min ago'),
    _NotifItem(icon: Icons.local_offer_outlined, iconBg: AppColors.warningBg, iconColor: AppColors.warning,
      title: 'Flash Sale is Live 🔥', body: 'Up to 50% OFF on electronics today only. Don\'t miss out!', time: '1 hr ago'),
    _NotifItem(icon: Icons.check_circle_outline_rounded, iconBg: AppColors.successBg, iconColor: AppColors.success,
      title: 'Order Delivered', body: 'Your order #ORD-2026-0031 has been delivered. Enjoy!', time: '2 days ago', isRead: true),
    _NotifItem(icon: Icons.star_outline_rounded, iconBg: AppColors.warningBg, iconColor: AppColors.warning,
      title: 'Rate your order', body: 'How was your Nintendo Switch OLED? Leave a review!', time: '2 days ago', isRead: true),
    _NotifItem(icon: Icons.card_giftcard_outlined, iconBg: AppColors.primarySoft, iconColor: AppColors.primary,
      title: 'You have a voucher!', body: 'Use code SAVE20 for \$20 OFF your next order over \$100.', time: '5 days ago', isRead: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: CustomAppBar(
        title: 'Notifications',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() { for (final n in _items) { n.isRead = true; } }),
            child: Text('Mark all read',
              style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: _items.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.border),
                const SizedBox(height: AppSpacing.space16),
                Text('No notifications', style: AppTypography.textTheme.headlineSmall),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.space16),
            itemCount: _items.length,
            separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.space8),
            itemBuilder: (context, i) => _NotifCard(
              item: _items[i],
              onTap: () => setState(() => _items[i].isRead = true),
              onDismiss: () => setState(() => _items.removeAt(i)),
            ),
          ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final _NotifItem item;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotifCard({required this.item, required this.onTap, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.title + item.time),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.space24),
        decoration: BoxDecoration(color: AppColors.error, borderRadius: AppSpacing.radiusLarge),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
      ),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.space16),
          decoration: BoxDecoration(
            color: item.isRead ? AppColors.background : AppColors.primarySoft.withAlpha(60),
            borderRadius: AppSpacing.radiusLarge,
            border: Border.all(color: item.isRead ? AppColors.border : AppColors.primary.withAlpha(60)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: item.iconBg, shape: BoxShape.circle),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(item.title,
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: item.isRead ? AppColors.textPrimary : AppColors.primary)),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(item.body,
                      style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, height: 1.4)),
                    const SizedBox(height: 6),
                    Text(item.time,
                      style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textDisabled, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
