import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(title: 'profile.contact_us'.tr(), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VillZone Software Solutions Pvt Ltd',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'legal.privacy.contact_desc'.tr(),
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 32),
              _buildContactCard(
                context,
                icon: Icons.email_outlined,
                title: 'profile.email'.tr(),
                value: 'astrovedham@gmail.com',
                onTap: () => _launchCustomUrl('mailto:astrovedham@gmail.com'),
              ),
              const SizedBox(height: 16),
              _buildContactCard(
                context,
                icon: Icons.phone_android_outlined,
                title: 'profile.phone'.tr(),
                value: '+91 8940997492',
                onTap: () => _launchCustomUrl('tel:+918940997492'),
              ),
              const SizedBox(height: 16),
              _buildContactCard(
                context,
                icon: Icons.language_outlined,
                title: 'legal.contact.website'.tr(),
                value: 'www.villzone.com',
                onTap: () => _launchCustomUrl('https://www.villzone.com'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.secondaryText,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchCustomUrl(String urlString) async {
    final Uri? uri = Uri.tryParse(urlString);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }
  }
}
