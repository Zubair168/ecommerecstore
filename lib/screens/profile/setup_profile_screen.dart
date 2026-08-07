import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  String _selectedGender = 'Male';
  bool _loading = false;

  static const _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.space24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.space24),

                // Title
                Text('Set Up Profile',
                    style: AppTypography.textTheme.displaySmall?.copyWith(
                        color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.space8),
                Text(
                  'Complete your profile to get a personalised experience.',
                  style: AppTypography.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.space32),

                // Avatar picker
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primarySoft,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: const Icon(Icons.person_rounded,
                            size: 54, color: AppColors.primary),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: const Border.fromBorderSide(
                                  BorderSide(color: Colors.white, width: 2)),
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.space8),
                Center(
                  child: Text('Upload Photo',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: AppSpacing.space32),

                // Phone
                CustomTextField(
                  label: 'Phone Number',
                  hintText: '+1 (555) 000-0000',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.space16),

                // Date of birth
                CustomTextField(
                  label: 'Date of Birth',
                  hintText: 'DD / MM / YYYY',
                  controller: _dobCtrl,
                  prefixIcon: const Icon(Icons.cake_outlined, size: 20),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(1995),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                      builder: (ctx, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: Theme.of(ctx)
                              .colorScheme
                              .copyWith(primary: AppColors.primary),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setState(() {
                        _dobCtrl.text =
                            '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
                      });
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.space16),

                // Gender
                Text('Gender',
                    style: AppTypography.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: AppSpacing.space8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _genders
                      .map((g) => GestureDetector(
                            onTap: () => setState(() => _selectedGender = g),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedGender == g
                                    ? AppColors.primarySoft
                                    : AppColors.backgroundAlt,
                                borderRadius: AppSpacing.radiusPill,
                                border: Border.all(
                                  color: _selectedGender == g
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(g,
                                  style: AppTypography.textTheme.bodySmall?.copyWith(
                                    color: _selectedGender == g
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: _selectedGender == g
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  )),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.space40),

                PrimaryButton(
                  text: 'Complete Profile',
                  isLoading: _loading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    setState(() => _loading = true);
                    final nav = Navigator.of(context);
                    await Future.delayed(const Duration(milliseconds: 800));
                    if (!mounted) return;
                    nav.pushReplacementNamed(AppRoutes.home);
                  },
                ),
                const SizedBox(height: AppSpacing.space16),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, AppRoutes.home),
                    child: Text('Skip for now',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
