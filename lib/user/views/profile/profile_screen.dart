import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppee_world/user/views/orders/order_screen.dart';
import 'package:shoppee_world/user/views/auth/login/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color backgroundColor = Color(0xff080C0D);
  static const Color cardColor = Color(0xff191D1E);

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // CURRENT USER
    // ============================================================

    final user = Supabase.instance.client.auth.currentUser;

    final userName =
        user?.userMetadata?['name']?.toString() ?? 'User';

    final userPhone =
        user?.userMetadata?['phone']?.toString() ?? 'No phone number';

    final userEmail =
        user?.email ?? 'No email';

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =====================================================
              // HEADER
              // =====================================================

              Row(
                children: [
                  Text(
                    "Profile",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const Spacer(),

                  _iconButton(
                    icon: Icons.settings_outlined,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // =====================================================
              // PROFILE CARD
              // =====================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(.06),
                  ),
                ),

                child: Row(
                  children: [

                    // =================================================
                    // PROFILE IMAGE
                    // =================================================

                    Container(
                      height: 68,
                      width: 68,

                      decoration: BoxDecoration(
                        color: const Color(0xff080C0D),
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white.withOpacity(.10),
                        ),
                      ),

                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white70,
                        size: 34,
                      ),
                    ),

                    const SizedBox(width: 15),

                    // =================================================
                    // USER DETAILS
                    // =================================================

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // NAME
                          Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // EMAIL
                          Text(
                            userEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: GoogleFonts.outfit(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 3),

                          // PHONE
                          Text(
                            userPhone,

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: GoogleFonts.outfit(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =================================================
                    // EDIT
                    // =================================================

                    GestureDetector(
                      onTap: () {},

                      child: Container(
                        height: 36,
                        width: 36,

                        decoration: BoxDecoration(
                          color: const Color(0xff080C0D),
                          shape: BoxShape.circle,

                          border: Border.all(
                            color: Colors.white.withOpacity(.07),
                          ),
                        ),

                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =====================================================
              // QUICK ACTIONS
              // =====================================================

              Text(
                "Quick Access",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [

                  Expanded(
                    child: _quickAction(
                      icon: Icons.receipt_long_outlined,
                      title: "Orders",

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const OrdersScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _quickAction(
                      icon: Icons.favorite_border_rounded,
                      title: "Wishlist",
                      onTap: () {},
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _quickAction(
                      icon: Icons.shopping_bag_outlined,
                      title: "Cart",
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // =====================================================
              // ACCOUNT
              // =====================================================

              Text(
                "Account",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              _menuItem(
                icon: Icons.person_outline_rounded,
                title: "Personal Information",
                subtitle: "Manage your account details",
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _menuItem(
                icon: Icons.location_on_outlined,
                title: "Delivery Addresses",
                subtitle: "Manage your saved addresses",
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _menuItem(
                icon: Icons.notifications_none_rounded,
                title: "Notifications",
                subtitle: "Manage notification preferences",
                onTap: () {},
              ),

              const SizedBox(height: 28),

              // =====================================================
              // SUPPORT
              // =====================================================

              Text(
                "Support",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              _menuItem(
                icon: Icons.help_outline_rounded,
                title: "Help & Support",
                subtitle: "Get help with your orders",
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _menuItem(
                icon: Icons.info_outline_rounded,
                title: "About Shoppee World",
                subtitle: "Learn more about our app",
                onTap: () {},
              ),

              const SizedBox(height: 28),

              // =====================================================
              // LOGOUT
              // =====================================================

              GestureDetector(
                onTap: () {
                  _showLogoutDialog(context);
                },

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xff191D1E),
                    borderRadius: BorderRadius.circular(15),

                    border: Border.all(
                      color: Colors.redAccent.withOpacity(.12),
                    ),
                  ),

                  child: Row(
                    children: [

                      Container(
                        height: 38,
                        width: 38,

                        decoration: BoxDecoration(
                          color:
                              Colors.redAccent.withOpacity(.08),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        "Logout",
                        style: GoogleFonts.outfit(
                          color: Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white30,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // =====================================================
              // VERSION
              // =====================================================

              Center(
                child: Text(
                  "Shoppee World • Version 1.0.0",

                  style: GoogleFonts.outfit(
                    color: Colors.white24,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // ICON BUTTON
  // ==============================================================

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 42,
        width: 42,

        decoration: BoxDecoration(
          color: cardColor,
          shape: BoxShape.circle,

          border: Border.all(
            color: Colors.white.withOpacity(.06),
          ),
        ),

        child: Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),
      ),
    );
  }

  // ==============================================================
  // QUICK ACTION
  // ==============================================================

  Widget _quickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 88,

        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: Colors.white.withOpacity(.06),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              color: Colors.white70,
              size: 23,
            ),

            const SizedBox(height: 8),

            Text(
              title,

              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // MENU ITEM
  // ==============================================================

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),

        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),

          border: Border.all(
            color: Colors.white.withOpacity(.06),
          ),
        ),

        child: Row(
          children: [

            Container(
              height: 40,
              width: 40,

              decoration: BoxDecoration(
                color: const Color(0xff080C0D),
                borderRadius: BorderRadius.circular(11),
              ),

              child: Icon(
                icon,
                color: Colors.white70,
                size: 19,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,

                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,

                    style: GoogleFonts.outfit(
                      color: Colors.white30,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white30,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // LOGOUT DIALOG
  // ==============================================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: Text(
            "Logout?",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          content: Text(
            "Are you sure you want to logout from your account?",

            style: GoogleFonts.outfit(
              color: Colors.white54,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: Text(
                "Cancel",

                style: GoogleFonts.outfit(
                  color: Colors.white54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            TextButton(
              onPressed: () async {
                try {
                  await Supabase.instance.client.auth.signOut();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,

                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),

                    (route) => false,
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Logout failed. Please try again.',
                      ),
                    ),
                  );
                }
              },

              child: Text(
                "Logout",

                style: GoogleFonts.outfit(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}