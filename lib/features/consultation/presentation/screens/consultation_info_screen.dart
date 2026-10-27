import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import 'package:astrovedham/widgets/common/contact_navigation_card.dart';
import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_service.dart';

class ConsultationInfoScreen extends StatelessWidget {
  final HoroscopeService service;

  const ConsultationInfoScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final themeColors = service.theme;

    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      appBar: CustomAppBar(
        title: service.name.tr(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(themeColors),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainTitle(context),
                      const SizedBox(height: 32),
                      _buildWhatYouGetSection(context, themeColors),
                      const SizedBox(height: 32),
                      _buildTopicsSection(context),
                      const SizedBox(height: 40),
                      _buildHowItWorksSection(context),
                      const SizedBox(height: 40),
                      _buildNoteCard(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomCTA(context, themeColors),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(ServiceThemeColors themeColors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              Image.asset(
                service.imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withAlpha((0.6 * 255).toInt()),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'services.consultation_title'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.primaryText,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'services.consultation_subtitle'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.secondaryText,
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildWhatYouGetSection(
    BuildContext context,
    ServiceThemeColors themeColors,
  ) {
    final benefits = [
      'services.benefit_1',
      'services.benefit_2',
      'services.benefit_3',
      'services.benefit_4',
      'services.benefit_5',
      'services.benefit_6',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'services.what_you_get'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.primaryText,
              ),
        ),
        const SizedBox(height: 20),
        ...benefits.map(
          (b) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withAlpha((0.1 * 255).toInt()),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.primaryGreen,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    b.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopicsSection(BuildContext context) {
    final topics = [
      'options.interests.marriage',
      'options.interests.career',
      'options.interests.business',
      'options.interests.finance',
      'options.interests.family',
      'options.interests.education',
      'options.interests.property',
      'options.interests.travel',
      'services.life_subtitle',
      'options.interests.other',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'services.choose_topic'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.primaryText,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: topics
              .map(
                (t) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Text(
                    t.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'services.how_it_works'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.primaryText,
              ),
        ),
        const SizedBox(height: 24),
        _buildStepItem(
          '1',
          'services.step_1_title'.tr(),
          'services.step_1_desc'.tr(),
        ),
        const SizedBox(height: 20),
        _buildStepItem(
          '2',
          'services.step_2_title'.tr(),
          'services.step_2_desc'.tr(),
        ),
        const SizedBox(height: 20),
        _buildStepItem(
          '3',
          'services.step_3_title'.tr(),
          'services.step_3_desc'.tr(),
        ),
      ],
    );
  }

  Widget _buildStepItem(String number, String title, String sub) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withAlpha(50),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(BuildContext context) {
    return const ContactNavigationCard();
  }

  Widget _buildBottomCTA(BuildContext context, ServiceThemeColors themeColors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.consultationForm,
            arguments: service,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          'services.get_started'.tr().toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
