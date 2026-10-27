import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import 'package:astrovedham/widgets/buttons/secondary_button.dart';
import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_service.dart';

class HoroscopeResultScreen extends StatelessWidget {
  final HoroscopeService service;

  const HoroscopeResultScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: service.name.tr(),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.root),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 80,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'horoscope.generating_title'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'horoscope.generating_desc'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 48),
              SecondaryButton(
                text: 'common.back_to_home'.tr(),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.root),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
