import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';
import '../../services/order_service.dart';

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
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotifItem> _promoItems = [
    _NotifItem(
      icon: Icons.local_offer_outlined,
      iconBg: AppColors.warningBg,
      iconColor: AppColors.warning,
      title: 'Flash Sale is Live 🔥',
      body: 'Up to 50% OFF on electronics today only. Don\'t miss out!',
      time: '1 hr ago',
    ),
    _NotifItem(
      icon: Icons.card_giftcard_outlined,
      iconBg: AppColors.primarySoft,
      iconColor: AppColors.primary,
      title: 'You have a voucher!',
      body: 'Use code SAVE20 for \$20 OFF your next order over \$100.',
      time: '2 days ago',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
            onPressed: () {
              setState(() {
                for (final n in _promoItems) {
                  n.isRead = true;
                }
              });
            },
            child: Text(
              'Mark all read',
              style: AppTypography.textTheme.bodySmall
                  ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: OrderService.notificationsStreamFor(user?.uid),
        builder: (context, snapshot) {
          final realNotifs = <_NotifItem>[];

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final docs = snapshot.data!.docs.toList();
            docs.sort((a, b) {
              final aTime = (a.data() as Map)['createdAt'] as Timestamp?;
              final bTime = (b.data() as Map)['createdAt'] as Timestamp?;
              if (aTime == null) return 1;
              if (bTime == null) return -1;
              return bTime.compareTo(aTime);
            });

            for (final doc in docs) {
              final data = doc.data() as Map<String, dynamic>;
              final timestamp = data['createdAt'] as Timestamp?;
              final timeStr = timestamp != null
                  ? DateFormat('MMM d • hh:mm a').format(timestamp.toDate())
                  : 'Just now';

              realNotifs.add(_NotifItem(
                icon: Icons.check_circle_outline_rounded,
                iconBg: const Color(0xFFECFDF3),
                iconColor: const Color(0xFF027A48),
                title: data['title'] ?? 'Order Update',
                body: data['body'] ?? '',
                time: timeStr,
                isRead: data['isRead'] ?? false,
              ));
            }
          }

          final allItems = [...realNotifs, ..._promoItems];

          if (allItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.border),
                  const SizedBox(height: AppSpacing.space16),
                  Text('No notifications', style: AppTypography.textTheme.headlineSmall),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.space16),
            itemCount: allItems.length,
            separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.space8),
            itemBuilder: (context, i) => _NotifCard(
              item: allItems[i],
              onTap: () => setState(() => allItems[i].isRead = true),
              onDismiss: () => setState(() => allItems.removeAt(i)),
            ),
          );
        },
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
        padding: const EdgeInsets.only(right: AppSpacing.space20),
        decoration: BoxDecoration(
          color: AppColors.errorBg,
          borderRadius: AppSpacing.radiusMedium,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.space16),
          decoration: BoxDecoration(
            color: item.isRead ? AppColors.background : const Color(0xFFFFFAFB),
            borderRadius: AppSpacing.radiusMedium,
            border: Border.all(
              color: item.isRead ? AppColors.border : AppColors.primarySoft,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: AppSpacing.radiusMedium,
                ),
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
                          child: Text(
                            item.title,
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.time,
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
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
