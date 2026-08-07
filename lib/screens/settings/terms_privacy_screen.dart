import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Terms & Privacy Policy',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              'Last updated: August 2026',
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            const _SectionContent(
              title: '1. Introduction',
              body:
                  'Welcome to OnlineShop! By accessing or using our application, you agree to be bound by these terms and conditions. Please read them carefully before making any purchase.',
            ),
            const _SectionContent(
              title: '2. User Accounts',
              body:
                  'You are responsible for maintaining the confidentiality of your account credentials and for restricting access to your computer or device.',
            ),
            const _SectionContent(
              title: '3. Orders & Payment',
              body:
                  'All orders are subject to availability and confirmation of order price. Payments are securely processed through encrypted channels.',
            ),
            const SizedBox(height: AppSpacing.space24),
            const Divider(color: AppColors.divider),
            const SizedBox(height: AppSpacing.space24),
            Text(
              'Privacy Policy',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            const _SectionContent(
              title: '1. Data Collection',
              body:
                  'We collect personal information that you provide to us directly, such as name, shipping address, email address, and payment information.',
            ),
            const _SectionContent(
              title: '2. How We Use Data',
              body:
                  'Your data is strictly used to fulfill orders, process payments, provide customer support, and improve our services.',
            ),
            const _SectionContent(
              title: '3. Security',
              body:
                  'We implement state-of-the-art encryption standards to ensure all personal and transaction details remain confidential and safe.',
            ),
            const SizedBox(height: AppSpacing.space32),
          ],
        ),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String title;
  final String body;

  const _SectionContent({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.space6),
          Text(
            body,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
