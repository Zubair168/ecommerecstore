import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/routes/app_routes.dart';
import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';
import 'package:ecommerecstore/widgets/index.dart';

/// 4-step Forgot Password flow managed as a single screen with page state.
enum _FpStep { enterEmail, verifyOtp, newPassword, success }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _FpStep _step = _FpStep.enterEmail;

  // Controllers
  final _emailCtrl = TextEditingController();
  final _otpCtrls = List.generate(4, (_) => TextEditingController());
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  int _resendSeconds = 60;

  @override
  void dispose() {
    _emailCtrl.dispose();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _step = _FpStep.values[_step.index + 1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            if (_step == _FpStep.enterEmail) {
              Navigator.pop(context);
            } else {
              setState(() => _step = _FpStep.values[_step.index - 1]);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case _FpStep.enterEmail:
        return _EnterEmailStep(
          key: const ValueKey('email'),
          controller: _emailCtrl,
          loading: _loading,
          onNext: _next,
        );
      case _FpStep.verifyOtp:
        return _VerifyOtpStep(
          key: const ValueKey('otp'),
          email: _emailCtrl.text,
          controllers: _otpCtrls,
          resendSeconds: _resendSeconds,
          loading: _loading,
          onNext: _next,
          onResend: () => setState(() => _resendSeconds = 60),
        );
      case _FpStep.newPassword:
        return _NewPasswordStep(
          key: const ValueKey('newpass'),
          controller: _newPassCtrl,
          confirmController: _confirmPassCtrl,
          obscureNew: _obscureNew,
          obscureConfirm: _obscureConfirm,
          onToggleNew: () => setState(() => _obscureNew = !_obscureNew),
          onToggleConfirm: () =>
              setState(() => _obscureConfirm = !_obscureConfirm),
          loading: _loading,
          onNext: _next,
        );
      case _FpStep.success:
        return _SuccessStep(
          key: const ValueKey('success'),
          onGoToLogin: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.login),
        );
    }
  }
}

// ── Step 1: Enter Email ──────────────────────────────────────────────────────
class _EnterEmailStep extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final VoidCallback onNext;

  const _EnterEmailStep({
    super.key,
    required this.controller,
    required this.loading,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.space16),
        Text('Forgot Password?', style: AppTypography.textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.space8),
        Text(
          "Enter your registered email and we'll send you a reset code.",
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.space32),
        CustomTextField(
          label: 'Email Address',
          hintText: 'Enter your email',
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(AppSpacing.space12),
            child: SvgPicture.asset(
              AppAssets.iconMail,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space32),
        PrimaryButton(
          text: 'Send OTP Code',
          onPressed: onNext,
          isLoading: loading,
        ),
      ],
    );
  }
}

// ── Step 2: OTP Verification ─────────────────────────────────────────────────
class _VerifyOtpStep extends StatelessWidget {
  final String email;
  final List<TextEditingController> controllers;
  final int resendSeconds;
  final bool loading;
  final VoidCallback onNext;
  final VoidCallback onResend;

  const _VerifyOtpStep({
    super.key,
    required this.email,
    required this.controllers,
    required this.resendSeconds,
    required this.loading,
    required this.onNext,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.space16),
        Text('Check Your Email', style: AppTypography.textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.space8),
        RichText(
          text: TextSpan(
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            children: [
              const TextSpan(text: 'We sent a 4-digit code to\n'),
              TextSpan(
                text: email,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space32),

        // 4-box OTP
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (i) => _OtpBox(controller: controllers[i], index: i),
          ),
        ),
        const SizedBox(height: AppSpacing.space24),

        // Resend timer
        Center(
          child: Text(
            resendSeconds > 0
                ? 'Resend code in ${resendSeconds}s'
                : 'Didn\'t receive a code?',
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        if (resendSeconds == 0) ...[
          const SizedBox(height: AppSpacing.space4),
          Center(
            child: TextButton(
              onPressed: onResend,
              child: Text(
                'Resend OTP',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.space32),
        PrimaryButton(
          text: 'Verify & Continue',
          onPressed: onNext,
          isLoading: loading,
        ),
      ],
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final int index;

  const _OtpBox({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTypography.textTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.backgroundAlt,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: AppSpacing.radiusMedium,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.radiusMedium,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSpacing.radiusMedium,
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (v) {
          if (v.length == 1 && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}

// ── Step 3: New Password ──────────────────────────────────────────────────────
class _NewPasswordStep extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController confirmController;
  final bool obscureNew;
  final bool obscureConfirm;
  final VoidCallback onToggleNew;
  final VoidCallback onToggleConfirm;
  final bool loading;
  final VoidCallback onNext;

  const _NewPasswordStep({
    super.key,
    required this.controller,
    required this.confirmController,
    required this.obscureNew,
    required this.obscureConfirm,
    required this.onToggleNew,
    required this.onToggleConfirm,
    required this.loading,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.space16),
        Text('Set New Password', style: AppTypography.textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.space8),
        Text(
          'Your new password must be different from your previous one.',
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.space32),
        CustomTextField(
          label: 'New Password',
          hintText: 'Enter new password',
          controller: controller,
          obscureText: obscureNew,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(AppSpacing.space12),
            child: SvgPicture.asset(
              AppAssets.iconPassword,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureNew ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: onToggleNew,
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        CustomTextField(
          label: 'Confirm New Password',
          hintText: 'Confirm new password',
          controller: confirmController,
          obscureText: obscureConfirm,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(AppSpacing.space12),
            child: SvgPicture.asset(
              AppAssets.iconPassword,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureConfirm ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: onToggleConfirm,
          ),
        ),
        const SizedBox(height: AppSpacing.space32),
        PrimaryButton(
          text: 'Reset Password',
          onPressed: onNext,
          isLoading: loading,
        ),
      ],
    );
  }
}

// ── Step 4: Success ───────────────────────────────────────────────────────────
class _SuccessStep extends StatelessWidget {
  final VoidCallback onGoToLogin;

  const _SuccessStep({super.key, required this.onGoToLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.space40),
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.successBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 52,
          ),
        ),
        const SizedBox(height: AppSpacing.space32),
        Text(
          'Password Reset!',
          style: AppTypography.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space12),
        Text(
          'Your password has been reset successfully.\nYou can now log in with your new password.',
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space40),
        PrimaryButton(text: 'Back to Login', onPressed: onGoToLogin),
      ],
    );
  }
}
