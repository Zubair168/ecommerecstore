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
  final String id;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  bool isRead;

  _NotifItem({
    required this.id,
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: OrderService.notificationsStreamFor(user?.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final realNotifs = <_NotifItem>[];

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final docs = snapshot.data!.docs.toList();
            docs.sort((a, b) {
              final aData = a.data() as Map<String, dynamic>;
              final bData = b.data() as Map<String, dynamic>;
              final aTime = aData['createdAt'] as Timestamp?;
              final bTime = bData['createdAt'] as Timestamp?;
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

              final type = data['type']?.toString() ?? 'order';
              IconData icon = Icons.shopping_bag_outlined;
              Color iconBg = const Color(0xFFEFF8FF);
              Color iconColor = AppColors.accentBlue;

              if (type == 'order_confirmed') {
                icon = Icons.check_circle_outline_rounded;
                iconBg = const Color(0xFFECFDF3);
                iconColor = const Color(0xFF027A48);
              } else if (type == 'shipped') {
                icon = Icons.local_shipping_outlined;
                iconBg = const Color(0xFFE0F2FE);
                iconColor = const Color(0xFF0086C9);
              }

              realNotifs.add(_NotifItem(
                id: doc.id,
                icon: icon,
                iconBg: iconBg,
                iconColor: iconColor,
                title: data['title'] ?? 'Order Notification',
                body: data['body'] ?? '',
                time: timeStr,
                isRead: data['isRead'] ?? false,
              ));
            }
          }

          if (realNotifs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.border),
                  const SizedBox(height: AppSpacing.space16),
                  Text('No notifications yet', style: AppTypography.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Order confirmation & status updates will appear here',
                    style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.space16),
            itemCount: realNotifs.length,
            separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.space8),
            itemBuilder: (context, i) => _NotifCard(
              item: realNotifs[i],
              onTap: () async {
                setState(() => realNotifs[i].isRead = true);
                try {
                  await FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(realNotifs[i].id)
                      .update({'isRead': true});
                } catch (_) {}
              },
              onDismiss: () async {
                final id = realNotifs[i].id;
                setState(() => realNotifs.removeAt(i));
                try {
                  await FirebaseFirestore.instance.collection('notifications').doc(id).delete();
                } catch (_) {}
              },
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
      key: ValueKey(item.id),
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
                        color: AppColors.textDisabled,
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
