import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      appBar: CustomAppBar(
        title: 'navigation.settings'.tr(),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader(context, 'settings.language'.tr()),
          const SizedBox(height: 12),
          _buildLanguageTile(
            context,
            title: 'settings.english'.tr(),
            locale: const Locale('en'),
          ),
          const Divider(),
          _buildLanguageTile(
            context,
            title: 'settings.tamil'.tr(),
            locale: const Locale('ta'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.primaryPurple,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String title,
    required Locale locale,
  }) {
    final isSelected = context.locale == locale;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primaryPurple : AppColors.primaryText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primaryPurple)
          : null,
      onTap: () {
        context.setLocale(locale);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
