import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/index.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLang = 'English (US)';

  static const _languages = [
    {'name': 'English (US)', 'flag': '🇺🇸', 'native': 'English'},
    {'name': 'English (UK)', 'flag': '🇬🇧', 'native': 'English'},
    {'name': 'Spanish', 'flag': '🇪🇸', 'native': 'Español'},
    {'name': 'French', 'flag': '🇫🇷', 'native': 'Français'},
    {'name': 'German', 'flag': '🇩🇪', 'native': 'Deutsch'},
    {'name': 'Italian', 'flag': '🇮🇹', 'native': 'Italiano'},
    {'name': 'Arabic', 'flag': '🇸🇦', 'native': 'العربية'},
    {'name': 'Chinese', 'flag': '🇨🇳', 'native': '中文'},
    {'name': 'Japanese', 'flag': '🇯🇵', 'native': '日本語'},
    {'name': 'Hindi', 'flag': '🇮🇳', 'native': 'हिन्दी'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      appBar: CustomAppBar(
        title: 'Select Language',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.space16),
              itemCount: _languages.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.space8),
              itemBuilder: (context, i) {
                final lang = _languages[i];
                final isSelected = _selectedLang == lang['name'];

                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppSpacing.radiusMedium,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    onTap: () => setState(() => _selectedLang = lang['name']!),
                    leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                    title: Text(
                      lang['name']!,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      lang['native']!,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : null,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space16),
            child: PrimaryButton(
              text: 'Save Language',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
