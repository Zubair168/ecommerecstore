import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ecommerecstore/routes/app_routes.dart';
import 'package:ecommerecstore/theme/app_colors.dart';
import 'package:ecommerecstore/theme/app_spacing.dart';
import 'package:ecommerecstore/theme/app_typography.dart';
import 'package:ecommerecstore/widgets/index.dart';

// ── Payment Method Screen ───────────────────────────────────────────────────────

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _selectedIndex = 0;

  static const _methods = [
    _PayMethod(
      icon: Icons.local_shipping_outlined,
      label: 'Cash on Delivery',
      sub: 'Pay when you receive',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: CustomAppBar(
        title: 'Payment Methods',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space16),
        children: [
          // Saved card graphic
          _CardGraphic(),
          const SizedBox(height: AppSpacing.space24),

          // Payment options
          Text(
            'Select Payment Method',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.space12),

          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppSpacing.radiusLarge,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: _methods.asMap().entries.map((e) {
                final isLast = e.key == _methods.length - 1;
                return Column(
                  children: [
                    _PaymentTile(
                      method: e.value,
                      isSelected: _selectedIndex == e.key,
                      onTap: () => setState(() => _selectedIndex = e.key),
                    ),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        color: AppColors.divider,
                        indent: 56,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.space16),

          // Add new card
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addCard),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add New Card'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
          const SizedBox(height: AppSpacing.space80),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space16,
          AppSpacing.space12,
          AppSpacing.space16,
          AppSpacing.space24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: PrimaryButton(
          text: 'Confirm Payment Method',
          onPressed: () => Navigator.pop(context, _selectedIndex),
        ),
      ),
    );
  }
}

class _PayMethod {
  final IconData icon;
  final String label;
  final String sub;
  const _PayMethod({
    required this.icon,
    required this.label,
    required this.sub,
  });
}

class _PaymentTile extends StatelessWidget {
  final _PayMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space14,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primarySoft
                    : AppColors.backgroundAlt,
                borderRadius: AppSpacing.radiusMedium,
              ),
              child: Icon(
                method.icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.label,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    method.sub,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFFFF5722)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF5722)
                      : const Color(0xFFD0D5DD),
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardGraphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF5722), Color(0xFFFF8A65)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.radiusExtraLarge,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(20),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: 40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'VISA',
                      style: AppTypography.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const Icon(
                      Icons.contactless_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '•••• •••• •••• 4242',
                  style: AppTypography.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: AppSpacing.space8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CARD HOLDER',
                          style: AppTypography.textTheme.labelSmall?.copyWith(
                            color: Colors.white70,
                            fontSize: 9,
                          ),
                        ),
                        Text(
                          'John Doe',
                          style: AppTypography.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXPIRES',
                          style: AppTypography.textTheme.labelSmall?.copyWith(
                            color: Colors.white70,
                            fontSize: 9,
                          ),
                        ),
                        Text(
                          '12/28',
                          style: AppTypography.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add Card Screen ─────────────────────────────────────────────────────────────

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Add New Card',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card preview
              _CardPreview(
                cardNumber: _numberCtrl.text,
                cardHolder: _nameCtrl.text,
                expiry: _expiryCtrl.text,
              ),
              const SizedBox(height: AppSpacing.space32),

              // Card number
              CustomTextField(
                label: 'Card Number',
                hintText: '1234 5678 9012 3456',
                controller: _numberCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
                prefixIcon: const Icon(Icons.credit_card_rounded, size: 20),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.replaceAll(' ', '').length < 16)
                    return 'Enter valid card number';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.space16),

              // Cardholder name
              CustomTextField(
                label: 'Cardholder Name',
                hintText: 'John Doe',
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.space16),

              // Expiry + CVV row
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Expiry Date',
                      hintText: 'MM / YY',
                      controller: _expiryCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryFormatter(),
                      ],
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        if (v == null || v.length < 5) return 'Invalid date';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space12),
                  Expanded(
                    child: CustomTextField(
                      label: 'CVV',
                      hintText: '•••',
                      controller: _cvvCtrl,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (v) {
                        if (v == null || v.length < 3) return 'Invalid CVV';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space40),

              PrimaryButton(
                text: 'Add Card',
                isLoading: _loading,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  setState(() => _loading = true);
                  final nav = Navigator.of(context);
                  await Future<void>.delayed(const Duration(milliseconds: 800));
                  if (!mounted) return;
                  nav.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardPreview extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiry;

  const _CardPreview({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    final display = cardNumber.isEmpty
        ? '•••• •••• •••• ••••'
        : cardNumber.padRight(19, '•');
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D2939), Color(0xFF344054)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.radiusExtraLarge,
        boxShadow: AppSpacing.shadowMedium,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.contactless_rounded,
                  color: Colors.white54,
                  size: 24,
                ),
                Text(
                  'VISA',
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              display,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(height: AppSpacing.space8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardHolder.isEmpty ? 'CARD HOLDER' : cardHolder.toUpperCase(),
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  expiry.isEmpty ? '••/••' : expiry,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue o, TextEditingValue n) {
    final digits = n.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final s = buffer.toString();
    return n.copyWith(
      text: s,
      selection: TextSelection.collapsed(offset: s.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue o, TextEditingValue n) {
    final digits = n.text.replaceAll(' / ', '');
    String s = digits;
    if (digits.length >= 2)
      s = '${digits.substring(0, 2)} / ${digits.substring(2)}';
    return n.copyWith(
      text: s,
      selection: TextSelection.collapsed(offset: s.length),
    );
  }
}
