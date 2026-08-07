import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms & Privacy Policy')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.space32),

                // Logo
                Center(
                  child: Image.asset(
                    AppAssets.appLogoPng,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppSpacing.space32),

                Text('Create Account 🎉', style: AppTypography.textTheme.headlineLarge),
                const SizedBox(height: AppSpacing.space8),
                Text(
                  'Fill in the details below to get started.',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.space24),

                // Full Name
                CustomTextField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: _nameCtrl,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(AppSpacing.space12),
                    child: Icon(Icons.person_outline_rounded, color: AppColors.textSecondary, size: 20),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: AppSpacing.space16),

                // Email
                CustomTextField(
                  label: 'Email Address',
                  hintText: 'Enter your email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(AppSpacing.space12),
                    child: SvgPicture.asset(AppAssets.iconMail, width: 20, height: 20,
                      colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.space16),

                // Password
                CustomTextField(
                  label: 'Password',
                  hintText: 'Create a password',
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(AppSpacing.space12),
                    child: SvgPicture.asset(AppAssets.iconPassword, width: 20, height: 20,
                      colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary, size: 20),
                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter a password';
                    if (v.length < 6) return 'At least 6 characters required';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.space16),

                // Confirm Password
                CustomTextField(
                  label: 'Confirm Password',
                  hintText: 'Confirm your password',
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(AppSpacing.space12),
                    child: SvgPicture.asset(AppAssets.iconPassword, width: 20, height: 20,
                      colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary, size: 20),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please confirm your password';
                    if (v != _passCtrl.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.space16),

                // Terms checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _agreeTerms,
                      onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space24),

                // Sign Up button
                PrimaryButton(text: 'Sign Up', onPressed: _register, isLoading: _loading),
                const SizedBox(height: AppSpacing.space24),

                // OR divider
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space12),
                    child: Text('OR', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: AppSpacing.space16),

                // Social buttons
                _SocialButton(icon: AppAssets.googleLogo, label: 'Continue with Google', onPressed: () {}),
                const SizedBox(height: AppSpacing.space12),
                _SocialButton(icon: AppAssets.appleLogo, label: 'Continue with Apple', onPressed: () {}),
                const SizedBox(height: AppSpacing.space24),

                // Login link
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                            child: Text('Sign In',
                              style: AppTypography.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppSpacing.radiusMedium,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.backgroundAlt,
          borderRadius: AppSpacing.radiusMedium,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 22, height: 22),
            const SizedBox(width: AppSpacing.space12),
            Text(label, style: AppTypography.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
