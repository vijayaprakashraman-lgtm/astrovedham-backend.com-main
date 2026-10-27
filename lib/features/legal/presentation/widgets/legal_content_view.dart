import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:astrovedham/core/theme/app_colors.dart';

class LegalContentView extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final String company;
  final List<LegalSection> sections;

  const LegalContentView({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.company,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryGreen.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              company,
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            lastUpdated,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 28),
          const Divider(color: AppColors.lightBorder, height: 1),
          const SizedBox(height: 28),
          ...sections.map((section) => _buildSection(context, section)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, LegalSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null) ...[
            Text(
              section.title!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
            ),
            const SizedBox(height: 12),
          ],
          if (section.content != null) ...[
            Text(
              section.content!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryText,
                    height: 1.6,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 12),
          ],
          if (section.subsections != null) ...[
            ...section.subsections!.map((sub) => _buildSubsection(context, sub)),
          ],
          if (section.bulletPoints != null) ...[
            ...section.bulletPoints!.map((bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bullet.replaceFirst(RegExp(r'^[•\-\s]+'), ''),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryText,
                                height: 1.5,
                                fontSize: 14,
                              ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
          ],
          if (section.disclaimer != null) ...[
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.orangeLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.sacredGold.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                section.disclaimer!,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  height: 1.5,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (section.contactInfo != null)
            _buildContactCard(context, section.contactInfo!),
        ],
      ),
    );
  }

  Widget _buildSubsection(BuildContext context, LegalSubsection sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sub.title != null) ...[
              Text(
                sub.title!,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 6),
            ],
            if (sub.content != null)
              Text(
                sub.content!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryText,
                      height: 1.5,
                      fontSize: 13,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, LegalContactInfo info) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info.company,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 14),
          ...info.emails.map((email) => _buildContactRow(
                icon: Icons.email_outlined,
                label: email,
                onTap: () => _launchCustomUrl('mailto:$email'),
              )),
          _buildContactRow(
            icon: Icons.phone_outlined,
            label: info.phone,
            onTap: () => _launchCustomUrl('tel:${info.phone.replaceAll(' ', '')}'),
          ),
          _buildContactRow(
            icon: Icons.language_outlined,
            label: info.website,
            onTap: () => _launchCustomUrl(
              info.website.startsWith('http')
                  ? info.website
                  : 'https://${info.website}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primaryGreen),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: AppColors.secondaryText,
              ),
            ],
          ),
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

class LegalSection {
  final String? title;
  final String? content;
  final List<LegalSubsection>? subsections;
  final List<String>? bulletPoints;
  final String? disclaimer;
  final LegalContactInfo? contactInfo;

  const LegalSection({
    this.title,
    this.content,
    this.subsections,
    this.bulletPoints,
    this.disclaimer,
    this.contactInfo,
  });
}

class LegalSubsection {
  final String? title;
  final String? content;

  const LegalSubsection({
    this.title,
    this.content,
  });
}

class LegalContactInfo {
  final String company;
  final List<String> emails;
  final String phone;
  final String website;

  const LegalContactInfo({
    required this.company,
    required this.emails,
    required this.phone,
    required this.website,
  });
}
