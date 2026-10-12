import 'package:flutter/material.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';

class AboutShoppeeWorldScreen extends StatelessWidget {
  const AboutShoppeeWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.background,
      appBar: AppBar(
        backgroundColor: AppTokens.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTokens.textPrimary,
            size: 21,
          ),
        ),
        title: Text(
          'About Shoppee World',
          style: AppTokens.pageTitle.copyWith(
            color: AppTokens.textPrimary,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppTokens.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: AppTokens.s24),

            _buildSectionHeading('Getting Started'),
            const SizedBox(height: AppTokens.s12),

            _buildInfoCard(
              icon: Icons.shopping_bag_outlined,
              title: 'How to Order a Product',
              description:
                  '1. Browse products and explore the available categories.\n'
                  '2. Select a product to view its details, price, size, and colour options.\n'
                  '3. Choose your preferred options and add the product to your cart.\n'
                  '4. Open your cart and review the selected products and quantities.\n'
                  '5. Continue to checkout and enter your delivery details.\n'
                  '6. Review the order summary and place your order through WhatsApp.\n'
                  '7. Follow the instructions provided to confirm your order.',
            ),

            _buildInfoCard(
              icon: Icons.receipt_long_outlined,
              title: 'Order Details and Tracking',
              description:
                  'Visit the Orders section in your profile to check your saved orders and their available status information. '
                  'For confirmation or updates, use the contact method provided by Shoppee World.',
            ),

            _buildInfoCard(
              icon: Icons.local_shipping_outlined,
              title: 'Delivery Information',
              description:
                  'Enter your name, phone number, complete address, place, landmark, district, state, and PIN code carefully at checkout. '
                  'Accurate information helps avoid delivery problems. Delivery availability and timelines may depend on your location.',
            ),

            const SizedBox(height: AppTokens.s24),

            _buildSectionHeading('Payments and Orders'),
            const SizedBox(height: AppTokens.s12),

            _buildInfoCard(
              icon: Icons.payments_outlined,
              title: 'Pricing and Payment',
              description:
                  'Review the product prices, quantities, delivery charge, and total amount before placing your order. '
                  'Follow the payment instructions communicated during order confirmation. Do not assume an order is confirmed until you receive confirmation.',
            ),

            _buildInfoCard(
              icon: Icons.cancel_outlined,
              title: 'Order Changes and Cancellation',
              description:
                  'If you need to change or cancel an order, contact Shoppee World as soon as possible. '
                  'Changes may depend on the order status and whether processing or dispatch has started.',
            ),

            _buildInfoCard(
              icon: Icons.assignment_return_outlined,
              title: 'Returns and Refunds',
              description:
                  'For a damaged, incorrect, or unsuitable product, contact Shoppee World and explain the issue. '
                  'Return eligibility, refund options, and applicable timelines depend on the store’s return policy.',
            ),

            const SizedBox(height: AppTokens.s24),

            _buildSectionHeading('Security and Privacy'),
            const SizedBox(height: AppTokens.s12),

            _buildInfoCard(
              icon: Icons.shield_outlined,
              title: 'Your Account Security',
              description:
                  'Keep your login credentials private and use a strong password. '
                  'Never share passwords or verification codes with anyone. Sign out when using a shared device.',
            ),

            _buildInfoCard(
              icon: Icons.lock_outline_rounded,
              title: 'Personal Information',
              description:
                  'Your name, phone number, and delivery address are used to process and fulfil orders. '
                  'Only provide accurate information needed for your purchase. Contact Shoppee World if you have questions about your personal data.',
            ),

            _buildInfoCard(
              icon: Icons.verified_user_outlined,
              title: 'Safe Shopping Tips',
              description:
                  'Check product details, prices, sizes, and colours before ordering. '
                  'Verify payment requests and communicate through trusted contact channels. '
                  'Never share banking PINs, OTPs, or passwords to confirm a purchase.',
            ),

            const SizedBox(height: AppTokens.s24),

            _buildSectionHeading('Need Help?'),
            const SizedBox(height: AppTokens.s12),

            _buildInfoCard(
              icon: Icons.support_agent_rounded,
              title: 'Customer Support',
              description:
                  'If you have questions about a product, an order, delivery, or payment, contact Shoppee World through the available support or WhatsApp contact option.',
            ),

            _buildInfoCard(
              icon: Icons.info_outline_rounded,
              title: 'About This App',
              description:
                  'Shoppee World is an e-commerce application designed to help you discover products, manage your cart, and submit orders conveniently.',
            ),

            const SizedBox(height: AppTokens.s24),

            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_bag_rounded,
                    size: 32,
                    color: AppTokens.accent,
                  ),
                  const SizedBox(height: AppTokens.s8),
                  Text(
                    'Shoppee World',
                    style: AppTokens.bodyStrong.copyWith(
                      color: AppTokens.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s4),
                  Text(
                    'Thank you for shopping with us.',
                    textAlign: TextAlign.center,
                    style: AppTokens.body.copyWith(
                      color: AppTokens.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s8),
                  Text(
                    'Version 1.0.0',
                    style: AppTokens.caption.copyWith(
                      color: AppTokens.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTokens.s24),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTokens.s20),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusSheet),
        border: Border.all(color: AppTokens.border),
      ),
      child: Column(
        children: [
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(
              color: AppTokens.accent.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: AppTokens.accent,
              size: 38,
            ),
          ),
          const SizedBox(height: AppTokens.s16),
          Text(
            'Welcome to Shoppee World',
            textAlign: TextAlign.center,
            style: AppTokens.headline.copyWith(
              color: AppTokens.textPrimary,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTokens.s8),
          Text(
            'Your guide to shopping, placing orders, '
            'managing deliveries, and staying safe.',
            textAlign: TextAlign.center,
            style: AppTokens.body.copyWith(
              color: AppTokens.textSecondary,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Text(
      title,
      style: AppTokens.sectionTitle.copyWith(
        color: AppTokens.textPrimary,
        fontSize: 21,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppTokens.s12),
      padding: const EdgeInsets.all(AppTokens.s16),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: AppTokens.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppTokens.accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            ),
            child: Icon(
              icon,
              color: AppTokens.accent,
              size: 23,
            ),
          ),
          const SizedBox(width: AppTokens.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTokens.bodyStrong.copyWith(
                    color: AppTokens.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppTokens.s8),
                Text(
                  description,
                  style: AppTokens.body.copyWith(
                    color: AppTokens.textSecondary,
                    fontSize: 15,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

