import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';

class AboutAstroVedhamScreen extends StatelessWidget {
  const AboutAstroVedhamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(title: 'profile.about_app'.tr(), centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 110,
                height: 110,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'app_name'.tr(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'profile.premium_astrology'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            _buildAboutCard(
              context,
              title: 'profile.about_app'.tr(),
              content: 'profile.about_desc'.tr(),
            ),
            const SizedBox(height: 24),
            _buildProvideSection(context),
            const SizedBox(height: 60),
            Text(
              '${'common.version'.tr()} 1.0.0',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.hintText),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryPurple,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(color: AppColors.primaryText, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildProvideSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'profile.what_we_provide'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildServiceItem(context, 'profile.service_1'.tr()),
              _buildDivider(),
              _buildServiceItem(context, 'profile.service_2'.tr()),
              _buildDivider(),
              _buildServiceItem(context, 'profile.service_3'.tr()),
              _buildDivider(),
              _buildServiceItem(context, 'profile.service_4'.tr()),
              _buildDivider(),
              _buildServiceItem(context, 'profile.service_5'.tr()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(BuildContext context, String text) {
    return ListTile(
      leading: const Icon(
        Icons.check_circle_outline,
        color: AppColors.primaryPurple,
        size: 20,
      ),
      title: Text(
        text,
        style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: AppColors.divider,
    );
  }
}
