import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/index.dart';
import '../../providers/cart_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLightTheme = true;

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF344054), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Setting',
          style: TextStyle(color: Color(0xFF101828), fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFEAECF0),
                  backgroundImage: AuthService.currentUser?.photoURL != null
                      ? NetworkImage(AuthService.currentUser!.photoURL!) as ImageProvider
                      : const AssetImage(AppAssets.avatarUserDefault),
                  child: AuthService.currentUser?.photoURL == null ? const Icon(Icons.person, color: Color(0xFF667085), size: 30) : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthService.currentUser?.displayName ?? 'Guest User',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF101828)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AuthService.currentUser?.email ?? 'Not signed in',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                  child: Container(
                    width: 38, height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F4F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF344054)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section: Information
            const Text(
              'Information',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF101828)),
            ),
            const SizedBox(height: 12),
            _SettingTile(
              icon: Icons.favorite_border_rounded,
              title: 'My Wishlist',
              onTap: () => Navigator.pushNamed(context, AppRoutes.wishlist),
            ),
            _SettingTile(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              onTap: () => Navigator.pushNamed(context, AppRoutes.myOrders),
            ),
            _SettingTile(
              icon: Icons.file_download_outlined,
              title: 'Downloads',
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.location_on_outlined,
              title: 'Address Book',
              onTap: () => Navigator.pushNamed(context, AppRoutes.shippingAddress),
            ),

            const SizedBox(height: 20),

            // Section: Account Settings
            const Text(
              'Account Settings',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF101828)),
            ),
            const SizedBox(height: 12),
            _SettingTile(
              icon: Icons.language_rounded,
              title: 'Language',
              onTap: () => Navigator.pushNamed(context, AppRoutes.language),
            ),

            // Light Theme Switch
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined, size: 20, color: Color(0xFF475467)),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Light Theme',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF344054)),
                    ),
                  ),
                  Switch(
                    value: _isLightTheme,
                    activeColor: kNavy,
                    onChanged: (v) => setState(() => _isLightTheme = v),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEAECF0)),

            _SettingTile(
              icon: Icons.file_download_outlined,
              title: 'Rate the app',
              onTap: () => Navigator.pushNamed(context, AppRoutes.feedback),
            ),
            _SettingTile(
              icon: Icons.group_add_outlined,
              title: 'Invite friends',
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.shield_outlined,
              title: 'Privacy and Policy',
              onTap: () => Navigator.pushNamed(context, AppRoutes.termsPrivacy),
            ),
            _SettingTile(
              icon: Icons.info_outline_rounded,
              title: 'About Us',
              onTap: () => Navigator.pushNamed(context, AppRoutes.termsPrivacy),
            ),
            _SettingTile(
              icon: Icons.logout_rounded,
              title: 'Log out',
              showChevron: false,
              onTap: () async {
                await AuthService.signOut();
                if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
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
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showChevron;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: onTap,
          leading: Icon(icon, size: 20, color: const Color(0xFF475467)),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF344054)),
          ),
          trailing: showChevron
              ? const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF98A2B3))
              : null,
        ),
        const Divider(height: 1, color: Color(0xFFEAECF0)),
      ],
    );
  }
}
