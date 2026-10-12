import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/admin/viewmodel/product_provider.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/views/orders/order_screen.dart';
import 'package:shoppee_world/user/views/auth/login/login_screen.dart';
import 'package:shoppee_world/user/views/profile/address/address_screen.dart';
import 'package:shoppee_world/user/views/profile/edit_profile_screen.dart';
import 'package:shoppee_world/user/views/profile/my_review_screen.dart';
import 'package:shoppee_world/user/views/profile/support/about_shoppeworld_screen.dart';
import 'package:shoppee_world/user/views/profile/support/hep&support_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // OPEN EDIT PROFILE

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    if (updated == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // CURRENT USER

    final user = Supabase.instance.client.auth.currentUser;

    final userName = user?.userMetadata?['name']?.toString() ?? 'User';

    final userPhone =
        user?.userMetadata?['phone']?.toString() ?? 'No phone number';

    final userEmail = user?.email ?? 'No email';

    final userAvatar = user?.userMetadata?['avatar_url']?.toString() ?? '';

    return Scaffold(
      backgroundColor: AppTokens.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppTokens.gutter,
            AppTokens.s20,
            AppTokens.gutter,
            AppTokens.s32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Text('Profile', style: AppTokens.headline),
                  const Spacer(),
                  _iconButton(icon: Icons.settings_outlined, onTap: () {}),
                ],
              ),

              const SizedBox(height: AppTokens.s24),

              // PROFILE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTokens.s16),
                decoration: BoxDecoration(
                  color: AppTokens.surface,
                  borderRadius: BorderRadius.circular(AppTokens.radiusSheet),
                  border: Border.all(color: AppTokens.border),
                ),
                child: Row(
                  children: [
                    // PROFILE IMAGE
                    GestureDetector(
                      onTap: _openEditProfile,
                      child: _avatar(userAvatar),
                    ),

                    const SizedBox(width: AppTokens.s16),

                    // USER DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTokens.bodyStrong.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: AppTokens.s4),
                          Text(
                            userEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTokens.caption.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userPhone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTokens.caption.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: AppTokens.s8),

                    // EDIT PROFILE
                    _iconButton(
                      icon: Icons.edit_outlined,
                      onTap: _openEditProfile,
                      size: 40,
                      circular: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTokens.s24),

              // QUICK ACCESS
              _sectionTitle('Quick access'),

              const SizedBox(height: AppTokens.s12),

              Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      icon: Icons.receipt_long_outlined,
                      title: 'Orders',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrdersScreen(
                              onBack: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppTokens.s12),
                  Expanded(
                    child: _quickAction(
                      icon: Icons.favorite_border_rounded,
                      title: 'Wishlist',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: AppTokens.s12),
                  Expanded(
                    child: _quickAction(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Cart',
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTokens.s32),

              // ACCOUNT
              _sectionTitle('Account'),

              const SizedBox(height: AppTokens.s12),

              _menuItem(
                icon: Icons.person_outline_rounded,
                title: 'Personal information',
                subtitle: 'Manage your account details',
                onTap: _openEditProfile,
              ),

              const SizedBox(height: AppTokens.s12),

              _menuItem(
                icon: Icons.location_on_outlined,
                title: 'Delivery addresses',
                subtitle: 'Manage your saved addresses',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddressesScreen()),
                  );
                },
              ),

              const SizedBox(height: AppTokens.s12),

              _menuItem(
                icon: Icons.notifications_none_rounded,
                title: 'My Reviews & Ratings',
                subtitle: 'Write and manage your product reviews',
                onTap: () async {
                  try {
                    final products = await ref.read(productsProvider.future);

                    if (!mounted) return;

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyReviewsScreen(
                          products: products,
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not load products. Please try again.',
                        ),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: AppTokens.s32),

              // SUPPORT
              _sectionTitle('Support'),

               SizedBox(height: AppTokens.s12),

              _menuItem(
                icon: Icons.help_outline_rounded,
                title: 'Help & support',
                subtitle: 'Get help with your orders',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HelpSupportScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppTokens.s12),

              _menuItem(
                icon: Icons.info_outline_rounded,
                title: 'About Shoppee World',
                subtitle: 'Learn more about our app',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AboutShoppeeWorldScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppTokens.s32),

              // LOGOUT
              GestureDetector(
                onTap: () => _showLogoutDialog(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.s16,
                    vertical: AppTokens.s12,
                  ),
                  decoration: BoxDecoration(
                    color: AppTokens.surface,
                    borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                    border: Border.all(
                      color: AppTokens.danger.withOpacity(0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: AppTokens.danger.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: AppTokens.danger,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppTokens.s12),
                      Text(
                        'Logout',
                        style: AppTokens.bodyStrong.copyWith(
                          fontSize: 16,
                          color: AppTokens.danger,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppTokens.textTertiary,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTokens.s20),

              // VERSION
              Center(
                child: Text(
                  'Shoppee World • Version 1.0.0',
                  style: AppTokens.caption.copyWith(
                    fontSize: 13,
                    color: AppTokens.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AVATAR

  Widget _avatarPlaceholder(double size) {
    return Center(
      child: Icon(
        Icons.person_outline_rounded,
        color: AppTokens.textSecondary,
        size: size * 0.5,
      ),
    );
  }

  Widget _avatar(String url, {double size = 76}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: AppTokens.background,
        shape: BoxShape.circle,
        border: Border.all(color: AppTokens.borderStrong),
      ),
      child: ClipOval(
        child: url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (context, error, stackTrace) {
                  return _avatarPlaceholder(size);
                },
              )
            : _avatarPlaceholder(size),
      ),
    );
  }

  // SECTION TITLE

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTokens.sectionTitle.copyWith(
        fontSize: 18,
        color: AppTokens.textPrimary,
      ),
    );
  }

  // ICON BUTTON

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 44,
    bool circular = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          circular ? size / 2 : AppTokens.radiusButton,
        ),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: AppTokens.surface,
            shape: circular ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: circular
                ? null
                : BorderRadius.circular(AppTokens.radiusButton),
            border: Border.all(color: AppTokens.border),
          ),
          child: Icon(icon, color: AppTokens.textSecondary, size: 22),
        ),
      ),
    );
  }

  // QUICK ACTION

  Widget _quickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            color: AppTokens.surface,
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
            border: Border.all(color: AppTokens.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTokens.accent, size: 26),
              const SizedBox(height: AppTokens.s8),
              Text(title, style: AppTokens.bodyStrong.copyWith(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  // MENU ITEM

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s12,
            vertical: AppTokens.s12,
          ),
          decoration: BoxDecoration(
            color: AppTokens.surface,
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
            border: Border.all(color: AppTokens.border),
          ),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppTokens.background,
                  borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                  border: Border.all(color: AppTokens.border),
                ),
                child: Icon(icon, color: AppTokens.accent, size: 22),
              ),
              const SizedBox(width: AppTokens.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTokens.bodyStrong.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTokens.caption.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTokens.s8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTokens.textTertiary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // LOGOUT DIALOG

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTokens.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusSheet),
            side: const BorderSide(color: AppTokens.border),
          ),
          title: Text(
            'Logout?',
            style: AppTokens.headline.copyWith(
              fontSize: 22,
              color: AppTokens.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: AppTokens.body.copyWith(
              fontSize: 15,
              color: AppTokens.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: AppTokens.button.copyWith(
                  fontSize: 15,
                  color: AppTokens.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.auth.signOut();

                  if (!dialogContext.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    dialogContext,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                } catch (e) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Logout failed. Please try again.'),
                    ),
                  );
                }
              },
              child: Text(
                'Logout',
                style: AppTokens.button.copyWith(
                  fontSize: 15,
                  color: AppTokens.danger,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
