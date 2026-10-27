import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_service.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/app_drawer.dart';
import 'package:astrovedham/core/routes/app_routes.dart';

import '../widgets/forms/universal_horoscope_form.dart';

class HoroscopeGeneratorScreen extends StatelessWidget {
  final HoroscopeService? service;

  const HoroscopeGeneratorScreen({super.key, this.service});

  @override
  Widget build(BuildContext context) {
    final effectiveService = service ?? HoroscopeService.allServices.first;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: CustomAppBar(
        title: effectiveService.name.tr(),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildServiceHeader(context, effectiveService),
            const SizedBox(height: 24),
            _buildDisclaimer(context, effectiveService.type),
            const SizedBox(height: 32),
            UniversalHoroscopeForm(
              service: effectiveService,
              onComplete: (data) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.horoscopeReview,
                  arguments: {'service': effectiveService, 'data': data},
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceHeader(BuildContext context, HoroscopeService service) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.03 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(service.iconData, size: 64, color: AppColors.primaryPurple),
          const SizedBox(height: 16),
          Text(
            service.name.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primaryPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service.description.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context, HoroscopeServiceType type) {
    String? disclaimerKey;

    if (type == HoroscopeServiceType.wealth) {
      disclaimerKey = 'disclaimers.financial';
    }

    if (disclaimerKey == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withAlpha(50)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              disclaimerKey.tr(),
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.error, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
