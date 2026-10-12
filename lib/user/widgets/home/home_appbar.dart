import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/views/cart/cart_screen.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _titleController;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<Offset> _titleSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Title animation controller
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _titleFadeAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _titleController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Animate the title when the app bar appears
    _titleController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SW Logo
        SizedBox(
          height: 68,
          width: 88,
          child: Image.asset(
            'assets/images/sw_logo.png',
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(width: AppTokens.s8),

        
        Expanded(
          child: FadeTransition(
            opacity: _titleFadeAnimation,
            child: SlideTransition(
              position: _titleSlideAnimation,
              child: Text(
                'Shoppee World',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lora(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                  color: AppTokens.textPrimary,
                ),
              ),
            ),
          ),
        ),

        IconButton(
          onPressed: _openCart,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 35,
            minHeight: 35,
          ),
          icon: const Icon(
            Icons.shop,
            color: Color.fromARGB(255, 233, 241, 237),
            size: 22,
          ),
        ),
      ],
    );
  }
}

