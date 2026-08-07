import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

enum NavTab { home, category, cart, settings }

class CustomBottomNavBar extends StatelessWidget {
  final NavTab currentTab;
  final ValueChanged<NavTab> onTabSelected;
  final int cartBadgeCount;

  const CustomBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    this.cartBadgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: AppAssets.userHomeIcon,
              fallbackIcon: AppAssets.navHome,
              iconData: Icons.home_rounded,
              label: 'Home',
              isActive: currentTab == NavTab.home,
              onTap: () => onTabSelected(NavTab.home),
            ),
            _NavItem(
              icon: AppAssets.iconGrid,
              fallbackIcon: AppAssets.iconGrid,
              iconData: Icons.grid_view_rounded,
              label: 'Category',
              isActive: currentTab == NavTab.category,
              onTap: () => onTabSelected(NavTab.category),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _NavItem(
                  icon: AppAssets.userBagIcon,
                  fallbackIcon: AppAssets.navCart,
                  iconData: Icons.shopping_bag_outlined,
                  label: 'Cart',
                  isActive: currentTab == NavTab.cart,
                  onTap: () => onTabSelected(NavTab.cart),
                ),
                if (cartBadgeCount > 0)
                  Positioned(
                    top: -2,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cartBadgeCount > 9 ? '9+' : '$cartBadgeCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            _NavItem(
              icon: AppAssets.userSettingIcon,
              fallbackIcon: AppAssets.iconSettings,
              iconData: Icons.settings_outlined,
              label: 'Settings',
              isActive: currentTab == NavTab.settings,
              onTap: () => onTabSelected(NavTab.settings),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String fallbackIcon;
  final IconData iconData;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.fallbackIcon,
    required this.iconData,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Dark navy color matching Figma original bottom bar
    const kDarkNavy = Color(0xFF1D2939);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 20 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? kDarkNavy : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 22,
              color: isActive ? Colors.white : const Color(0xFF475467),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
