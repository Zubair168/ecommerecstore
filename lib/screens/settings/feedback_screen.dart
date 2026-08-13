import 'package:flutter/material.dart';

import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';
import 'package:ecommerecstore/widgets/index.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 5;
  final _commentCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: CustomAppBar(
        title: 'App Feedback',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.space20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppSpacing.radiusLarge,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF4E5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.rate_review_rounded,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space16),
                  Text(
                    'We\'d love your feedback!',
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space8),
                  Text(
                    'How is your experience using OnlineShop? Let us know how we can improve.',
                    textAlign: TextAlign.center,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starVal = index + 1;
                      return IconButton(
                        iconSize: 36,
                        icon: Icon(
                          starVal <= _rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFFFC107),
                        ),
                        onPressed: () => setState(() => _rating = starVal),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.space20),
                  CustomTextField(
                    label: 'Feedback & Suggestions',
                    hintText: 'Write your thoughts here...',
                    controller: _commentCtrl,
                    maxLines: 4,
                  ),
                  const SizedBox(height: AppSpacing.space24),
                  PrimaryButton(
                    text: 'Submit Feedback',
                    isLoading: _isSubmitting,
                    onPressed: () async {
                      setState(() => _isSubmitting = true);
                      await Future<void>.delayed(
                        const Duration(milliseconds: 600),
                      );
                      if (!mounted) return;
                      setState(() => _isSubmitting = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Thank you for your valuable feedback!',
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
