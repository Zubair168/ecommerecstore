import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/routes/app_routes.dart';
import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';
import 'package:ecommerecstore/widgets/index.dart';
import 'package:ecommerecstore/providers/cart_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: const CustomAppBar(
        title: 'My Profile',
        leading: SizedBox.shrink(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.space16),
            child: Icon(
              Icons.settings_outlined,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // ── Header banner ──────────────────────────────────────────
          _buildProfileHeader(context),
          const SizedBox(height: AppSpacing.space16),

          // ── Quick Stats ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
            child: _buildQuickStats(),
          ),
          const SizedBox(height: AppSpacing.space16),

          // ── Menu Items ────────────────────────────────────────────
          _buildMenuSection('Shopping', [
            _MenuItem(
              icon: Icons.receipt_long_outlined,
              label: 'My Orders',
              badge: '2',
              onTap: () => Navigator.pushNamed(context, AppRoutes.myOrders),
            ),
            _MenuItem(
              icon: Icons.favorite_border_rounded,
              label: 'My Wishlist',
              onTap: () => Navigator.pushNamed(context, AppRoutes.wishlist),
            ),
            _MenuItem(
              icon: Icons.location_on_outlined,
              label: 'Shipping Addresses',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.shippingAddress),
            ),
            _MenuItem(
              icon: Icons.credit_card_outlined,
              label: 'Payment Methods',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.paymentMethod),
            ),
            _MenuItem(
              icon: Icons.local_offer_outlined,
              label: 'My Vouchers',
              onTap: () => Navigator.pushNamed(context, AppRoutes.voucher),
            ),
          ]),
          const SizedBox(height: AppSpacing.space12),

          _buildMenuSection('Account', [
            _MenuItem(
              icon: Icons.person_outline_rounded,
              label: 'Edit Profile',
              onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            ),
            _MenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.notifications),
            ),
            _MenuItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Chat Support',
              onTap: () => Navigator.pushNamed(context, AppRoutes.chat),
            ),
            _MenuItem(
              icon: Icons.language_outlined,
              label: 'Language & Region',
              onTap: () => Navigator.pushNamed(context, AppRoutes.language),
            ),
          ]),
          const SizedBox(height: AppSpacing.space12),

          _buildMenuSection('General', [
            _MenuItem(
              icon: Icons.star_outline_rounded,
              label: 'Rate the App',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.help_outline_rounded,
              label: 'Help & Support',
              onTap: () => Navigator.pushNamed(context, AppRoutes.feedback),
            ),
            _MenuItem(
              icon: Icons.shield_outlined,
              label: 'Terms & Privacy Policy',
              onTap: () => Navigator.pushNamed(context, AppRoutes.termsPrivacy),
            ),
          ]),
          const SizedBox(height: AppSpacing.space12),

          // Sign out
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
            child: SecondaryButton(
              text: 'Sign Out',
              onPressed: () => _showSignOutDialog(context),
            ),
          ),
          const SizedBox(height: AppSpacing.space40),
        ],
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) => CustomBottomNavBar(
          currentTab: NavTab.settings,
          cartBadgeCount: cart.totalQuantity,
          onTabSelected: (tab) {
            switch (tab) {
              case NavTab.home:
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              case NavTab.category:
                Navigator.pushReplacementNamed(context, AppRoutes.categories);
              case NavTab.cart:
                Navigator.pushReplacementNamed(context, AppRoutes.cart);
              default:
                break;
            }
          },
        ),
      ),
    );
  }

  // ── Profile Header ─────────────────────────────────────────────────────────
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space24),
      color: AppColors.background,
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.border,
                child: SvgPicture.asset(
                  AppAssets.avatarUserDefault,
                  width: 56,
                  height: 56,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: const Border.fromBorderSide(
                      BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Doe', style: AppTypography.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'john.doe@email.com',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.editProfile),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: AppSpacing.radiusPill,
                    ),
                    child: Text(
                      'Edit Profile',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
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

  // ── Quick Stats ────────────────────────────────────────────────────────────
  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppSpacing.radiusLarge,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _StatItem(value: '12', label: 'Orders'),
          _VertDivider(),
          _StatItem(value: '4', label: 'Wishlist'),
          _VertDivider(),
          _StatItem(value: '8', label: 'Reviews'),
          _VertDivider(),
          _StatItem(value: '\$1.2k', label: 'Spent'),
        ],
      ),
    );
  }

  // ── Section builder ────────────────────────────────────────────────────────
  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppSpacing.radiusLarge,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space16,
              AppSpacing.space12,
              AppSpacing.space16,
              4,
            ),
            child: Text(
              title,
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...items.asMap().entries.map(
            (e) => Column(
              children: [
                if (e.key > 0)
                  const Divider(
                    height: 1,
                    color: AppColors.divider,
                    indent: 52,
                  ),
                e.value,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.radiusLarge),
        title: Text('Sign Out', style: AppTypography.textTheme.headlineSmall),
        content: Text(
          'Are you sure you want to sign out?',
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

// ── Small sub-widgets ──────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.divider);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space14,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: AppSpacing.space16),
            Expanded(
              child: Text(
                label,
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: AppSpacing.radiusPill,
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(width: AppSpacing.space8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
