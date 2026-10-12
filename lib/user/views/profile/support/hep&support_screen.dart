import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shoppee_world/user/core/theme/app_tokens.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const String supportPhone = '7592088952';
  static const String supportEmail = 'support@shoppeeworld.example';

  Future<void> _openWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/917592088952');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMessage(context, 'Could not open WhatsApp.');
    }
  }

  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {
        'subject': 'Shoppee World - Support Request',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showMessage(context, 'Could not open an email application.');
    }
  }

  Future<void> _callSupport(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: supportPhone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showMessage(context, 'Could not open the phone application.');
    }
  }

  void _copyContact(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    _showMessage(context, 'Copied to clipboard');
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTokens.surface,
        content: Text(
          message,
          style: AppTokens.body.copyWith(
            color: AppTokens.textPrimary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

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
        centerTitle: true,
        title: Text(
          'Help & Support',
          style: AppTokens.pageTitle.copyWith(
            color: AppTokens.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppTokens.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: AppTokens.s24),

            _sectionTitle('Contact Us'),
            const SizedBox(height: AppTokens.s12),

            _contactCard(
              icon: Icons.phone_outlined,
              title: 'Phone Support',
              subtitle: '+91 $supportPhone',
              actionLabel: 'Call',
              onTap: () => _callSupport(context),
              onCopy: () => _copyContact(
                context,
                '+91 $supportPhone',
              ),
            ),

            _contactCard(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: supportEmail,
              actionLabel: 'Email',
              onTap: () => _openEmail(context),
              onCopy: () => _copyContact(
                context,
                supportEmail,
              ),
            ),

            const SizedBox(height: AppTokens.s8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openWhatsApp(context),
                icon: const Icon(Icons.chat_outlined, size: 22),
                label: const Text('Chat with us on WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.accent,
                  foregroundColor: AppTokens.onAccent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.s16,
                    vertical: AppTokens.s16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppTokens.radiusButton,
                    ),
                  ),
                  textStyle: AppTokens.button.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            _sectionTitle('How Can We Help?'),
            const SizedBox(height: AppTokens.s12),

            _supportTopic(
              icon: Icons.shopping_bag_outlined,
              title: 'Products and Orders',
              description:
                  'Questions about product details, placing an order, '
                  'or checking your order status.',
            ),

            _supportTopic(
              icon: Icons.local_shipping_outlined,
              title: 'Delivery Assistance',
              description:
                  'Need help with your delivery address, delivery status, '
                  'or a delayed order? Contact our support team.',
            ),

            _supportTopic(
              icon: Icons.payments_outlined,
              title: 'Payments and Refunds',
              description:
                  'For payment questions, order cancellations, or refund '
                  'requests, contact us with your order details.',
            ),

            _supportTopic(
              icon: Icons.assignment_return_outlined,
              title: 'Returns and Damaged Products',
              description:
                  'If you receive a damaged or incorrect product, '
                  'contact support and explain the issue.',
            ),

            const SizedBox(height: AppTokens.s24),

            _sectionTitle('Frequently Asked Questions'),
            const SizedBox(height: AppTokens.s12),

            _faqItem(
              question: 'How do I place an order?',
              answer:
                  'Select a product, choose the available options, '
                  'add it to your cart, and continue to checkout. '
                  'Enter your delivery details and follow the WhatsApp '
                  'order instructions.',
            ),

            _faqItem(
              question: 'How can I check my order?',
              answer:
                  'Open the Orders section in your app to view your '
                  'saved orders and available status information. '
                  'Contact support if you need further assistance.',
            ),

            _faqItem(
              question: 'How do I cancel an order?',
              answer:
                  'Contact support as soon as possible with your order '
                  'details. Cancellation depends on the order status '
                  'and the applicable store policy.',
            ),

            _faqItem(
              question: 'What if I receive a damaged product?',
              answer:
                  'Contact support and explain the problem. Include your '
                  'order details and photos of the product if requested.',
            ),

            const SizedBox(height: AppTokens.s24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTokens.s16),
              decoration: BoxDecoration(
                color: AppTokens.surface,
                borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                border: Border.all(color: AppTokens.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: AppTokens.accent,
                    size: 26,
                  ),
                  const SizedBox(width: AppTokens.s12),
                  Expanded(
                    child: Text(
                      'For your security, never share your password, '
                      'OTP, banking PIN, or other confidential '
                      'authentication details with anyone.',
                      style: AppTokens.body.copyWith(
                        color: AppTokens.textSecondary,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.shopping_bag_rounded,
                    color: AppTokens.accent,
                    size: 30,
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
                    'We are here to help you.',
                    style: AppTokens.body.copyWith(
                      color: AppTokens.textSecondary,
                      fontSize: 14,
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
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: AppTokens.accent.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppTokens.accent,
              size: 38,
            ),
          ),
          const SizedBox(height: AppTokens.s16),
          Text(
            'How can we help you?',
            textAlign: TextAlign.center,
            style: AppTokens.headline.copyWith(
              color: AppTokens.textPrimary,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTokens.s8),
          Text(
            'Have a question about a product or order? '
            'Get in touch with our support team.',
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTokens.sectionTitle.copyWith(
        color: AppTokens.textPrimary,
        fontSize: 21,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onTap,
    required VoidCallback onCopy,
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
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppTokens.accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            ),
            child: Icon(
              icon,
              color: AppTokens.accent,
              size: 24,
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
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppTokens.s4),
                Text(
                  subtitle,
                  style: AppTokens.body.copyWith(
                    color: AppTokens.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Copy contact',
            onPressed: onCopy,
            icon: const Icon(
              Icons.copy_rounded,
              color: AppTokens.textSecondary,
              size: 19,
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              actionLabel,
              style: AppTokens.bodyStrong.copyWith(
                color: AppTokens.accent,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportTopic({
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
          Icon(
            icon,
            color: AppTokens.accent,
            size: 25,
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
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppTokens.s8),
                Text(
                  description,
                  style: AppTokens.body.copyWith(
                    color: AppTokens.textSecondary,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.s12),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: AppTokens.border),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          colorScheme: const ColorScheme.dark(
            primary: AppTokens.accent,
            surface: AppTokens.surface,
          ),
        ),
        child: ExpansionTile(
          iconColor: AppTokens.accent,
          collapsedIconColor: AppTokens.textSecondary,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s16,
            vertical: AppTokens.s4,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppTokens.s16,
            0,
            AppTokens.s16,
            AppTokens.s16,
          ),
          title: Text(
            question,
            style: AppTokens.bodyStrong.copyWith(
              color: AppTokens.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: AppTokens.body.copyWith(
                  color: AppTokens.textSecondary,
                  fontSize: 15,
                  height: 1.65,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

