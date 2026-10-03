import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Best Products\nJust for You',
      'description':
          'Discover amazing products,\nhandpicked for your lifestyle.',
      'image': 'assets/images/onb_1.png',
    },
    {
      'title': 'Fast & Secure\nShopping',
      'description':
          'Enjoy a smooth and secure\nshopping experience with\nmultiple payment options.',
      'image': 'assets/images/onb_2.jpeg',
    },
    {
      'title': 'Your Style\nOur Priority',
      'description':
          'From fashion to electronics,\nfind everything you need\nin one place.',
      'image': 'assets/images/onb_3.jpeg',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      goToLogin();
    }
  }

 Future<void> goToLogin() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('onboardingCompleted', true);

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final item = onboardingData[index];

          return Stack(
            fit: StackFit.expand,
            children: [
              // ==========================================
              // 1. FULLSCREEN BACKGROUND IMAGE
              // ==========================================
              Image.asset(
                item['image']!,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),

              // Dynamic dark gradient overlay to make top text pop
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                      Colors.black54,
                      Colors.black,
                    ],
                    stops: [0.0, 0.35, 0.7, 1.0],
                  ),
                ),
              ),

              // ==========================================
              // 2. UI OVERLAY CONTENT
              // ==========================================
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // TITLE
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // DESCRIPTION
                      Text(
                        item['description']!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14.5,
                          height: 1.35,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.1,
                        ),
                      ),

                      const Spacer(),

                      // PAGE INDICATOR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                          (dotIndex) {
                            final isActive = currentPage == dotIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3.5),
                              width: isActive ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // GET STARTED BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE5E5E5),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // LOGIN TEXT
                      Center(
                        child: GestureDetector(
                          onTap: goToLogin,
                          child: Text.rich(
                            TextSpan(
                              text: 'Already have an account?  ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}