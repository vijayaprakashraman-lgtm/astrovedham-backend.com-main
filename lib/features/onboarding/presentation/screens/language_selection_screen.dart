import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/core/services/local_storage_service.dart';
import 'package:astrovedham/widgets/buttons/primary_button.dart';

import '../widgets/language_option_card.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale? _selectedLocale;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.softLavender,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.translate_rounded,
                    color: AppColors.primaryPurple,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'onboarding.choose_language'.tr(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'onboarding.select_preferred'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 48),
                LanguageOptionCard(
                  title: 'தமிழ்',
                  subtitle: 'தமிழில் தொடரவும்',
                  isSelected: _selectedLocale?.languageCode == 'ta',
                  onTap: () =>
                      setState(() => _selectedLocale = const Locale('ta')),
                ),
                const SizedBox(height: 16),
                LanguageOptionCard(
                  title: 'English',
                  subtitle: 'Continue in English',
                  isSelected: _selectedLocale?.languageCode == 'en',
                  onTap: () =>
                      setState(() => _selectedLocale = const Locale('en')),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'onboarding.continue'.tr().toUpperCase(),
                  onTap: _selectedLocale == null ? null : _onContinue,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    if (_selectedLocale == null) return;

    // 1. Save onboarding completion status
    await LocalStorageService.instance.setOnboardingCompleted(true);

    // 2. Update and persist the app locale
    if (!mounted) return;
    await context.setLocale(_selectedLocale!);

    // 3. Navigate to Home
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.root);
  }
}
