import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/common/custom_app_bar.dart';
import '../../../../widgets/common/contact_navigation_card.dart';
import '../../../horoscope_generator/domain/entities/horoscope_service.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/horoscope_reports.dart';

class ServiceInfoScreen extends StatelessWidget {
  final HoroscopeService service;

  const ServiceInfoScreen({super.key, required this.service});

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
                // 1. Top Hero Image
                _buildHeroImage(themeColors),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Service Introduction
                      _buildIntroduction(context, themeColors),

                      const SizedBox(height: 32),

                      // 3. What You'll Receive
                      _buildHighlightsSection(context, themeColors),

                      const SizedBox(height: 32),

                      // 4. Key Astrological Insights
                      _buildInsightsSection(context, themeColors),

                      const SizedBox(height: 32),

                      // 4.5 Required Details
                      _buildRequiredDetails(context, themeColors),

                      const SizedBox(height: 32),

                      // 5. Sample Report
                      _buildSampleReportPreview(context, themeColors),

                      const SizedBox(height: 32),

                      // 6. Price Section
                      _buildPriceSection(context, themeColors),

                      const SizedBox(height: 32),

                      // 7. Contact Us Card
                      const ContactNavigationCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Fixed bottom CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFixedCTA(context, themeColors),
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

  Widget _buildIntroduction(
    BuildContext context,
    ServiceThemeColors themeColors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                service.name.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryText,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            /*
            if (service.isPremium) ...[
              const SizedBox(width: 8),
              _buildPremiumBadge(),
            ],
            */
          ],
        ),
        const SizedBox(height: 12),
        Text(
          service.description.tr(),
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: AppColors.secondaryText, height: 1.6),
        ),
      ],
    );
  }


  Widget _buildPriceSection(
    BuildContext context,
    ServiceThemeColors themeColors,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.03 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'services.introductory_offer'.tr(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    service.currentPrice,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w900,
                      fontSize: 34,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    service.originalPrice,
                    style: const TextStyle(
                      color: AppColors.jadeTextHint,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.sacredGold,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              service.discount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsSection(
    BuildContext context,
    ServiceThemeColors themeColors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'services.service_highlights_title'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),
        ...service.highlights.map(
          (h) => Padding(
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
                    h.tr(),
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

  Widget _buildInsightsSection(
    BuildContext context,
    ServiceThemeColors themeColors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'services.insights_title'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.jadeGreen.withAlpha((0.05 * 255).toInt()),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.jadeGreen.withAlpha((0.1 * 255).toInt()),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).toInt()),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    service.methodTitle.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                service.methodDesc.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.7,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequiredDetails(
    BuildContext context,
    ServiceThemeColors themeColors,
  ) {
    final bool isMatching =
        service.type == HoroscopeServiceType.marriageMatchingLite ||
        service.type == HoroscopeServiceType.marriageMatchingPro;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'services.required_details'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMatching) ...[
                _buildDetailHeading(
                  'services.required_details_groom',
                  themeColors,
                ),
                _buildDetailItem('forms.full_name', themeColors),
                _buildDetailItem('forms.dob', themeColors),
                _buildDetailItem('forms.birth_time', themeColors),
                _buildDetailItem('forms.birth_place', themeColors),
                const SizedBox(height: 16),
                _buildDetailHeading(
                  'services.required_details_bride',
                  themeColors,
                ),
                _buildDetailItem('forms.full_name', themeColors),
                _buildDetailItem('forms.dob', themeColors),
                _buildDetailItem('forms.birth_time', themeColors),
                _buildDetailItem('forms.birth_place', themeColors),
              ] else ...[
                _buildDetailItem('forms.full_name', themeColors),
                if (service.type == HoroscopeServiceType.life ||
                    service.type == HoroscopeServiceType.superLife)
                  _buildDetailItem('forms.father_name', themeColors),
                _buildDetailItem('forms.dob', themeColors),
                _buildDetailItem('forms.birth_time', themeColors),
                _buildDetailItem('forms.birth_place', themeColors),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailHeading(String key, ServiceThemeColors themeColors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        key.tr(),
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: AppColors.primaryGreen,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String key, ServiceThemeColors themeColors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.arrow_right_rounded, color: AppColors.primaryGreen, size: 24),
          const SizedBox(width: 4),
          Text(
            key.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleReportPreview(
    BuildContext context,
    ServiceThemeColors themeColors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'services.sample_report_title'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'services.sample_report_subtitle'.tr(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.02 * 255).toInt()),
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
                  color: AppColors.offerBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.offerText,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${service.samplePages} ${'services.pages'.tr()}",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final report = HoroscopeReports.all.firstWhere(
                    (r) => r.pdfUrl == service.samplePdfUrl,
                    orElse: () => HoroscopeReport(
                      title: service.name.tr(),
                      pdfUrl: service.samplePdfUrl,
                    ),
                  );
                  Navigator.pushNamed(
                    context,
                    AppRoutes.pdfViewer,
                    arguments: report,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.jadeGreen,
                  elevation: 0,
                  minimumSize: const Size(80, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
                child: Text(
                  'common.view'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFixedCTA(BuildContext context, ServiceThemeColors themeColors) {
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
            AppRoutes.serviceForm,
            arguments: service,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withAlpha((0.1 * 255).toInt()),
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            service.ctaKey.tr(),
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
