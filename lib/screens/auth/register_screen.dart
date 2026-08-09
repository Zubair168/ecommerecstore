import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_assets.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
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
    try {
      final name = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final pass = _passCtrl.text;

      await AuthService.signUp(email, pass, name);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created')));
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const kNavy = Color(0xFF1D2939);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF344054), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Logo matching sign-in screen
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5722),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, fontFamily: 'Outfit'),
                          children: [
                            TextSpan(text: 'Online', style: TextStyle(color: Color(0xFFFF5722))),
                            TextSpan(text: 'Shop', style: TextStyle(color: Color(0xFF1D2939))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                const Center(
                  child: Text(
                    'Create Account 🎉',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF101828),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Fill in the details below to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Full Name
                const Text(
                  'Full Name',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF344054)),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF667085), size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: kNavy, width: 1.5),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: 20),

                // Email
                const Text(
                  'Email Address',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF344054)),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
                    prefixIcon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF667085), size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: kNavy, width: 1.5),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                const Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF344054)),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF667085), size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: kNavy, width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF667085),
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter a password';
                    if (v.length < 6) return 'At least 6 characters required';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password
                const Text(
                  'Confirm Password',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF344054)),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF667085), size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: kNavy, width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF667085),
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please confirm your password';
                    if (v != _passCtrl.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Terms checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _agreeTerms,
                      onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                      activeColor: kNavy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(color: kNavy, fontWeight: FontWeight.w600),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(color: kNavy, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Black Sign Up button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 24, height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                        : const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // OR divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xFFEAECF0))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Or', style: TextStyle(color: Color(0xFF98A2B3), fontSize: 13)),
                    ),
                    Expanded(child: Divider(color: Color(0xFFEAECF0))),
                  ],
                ),
                const SizedBox(height: 24),

                // Continue with Google
                _SocialButton(
                  icon: AppAssets.googleLogo,
                  label: 'Continue with Google',
                  onPressed: () async {
                    setState(() => _loading = true);
                    try {
                      final cred = await AuthService.signInWithGoogle();
                      if (cred != null && mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                    } catch (e) {
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
                    } finally {
                      if (mounted) setState(() => _loading = false);
                    }
                  },
                ),
                const SizedBox(height: 12),
                _SocialButton(
                  icon: AppAssets.appleLogo,
                  label: 'Continue with Apple',
                  onPressed: () {},
                ),
                const SizedBox(height: 24),

                // Sign In link
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: kNavy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
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
