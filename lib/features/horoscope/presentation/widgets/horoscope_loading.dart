import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';

class HoroscopeLoading extends StatelessWidget {
  const HoroscopeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withAlpha(
                        (0.1 * 255).toInt(),
                      ),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  color: AppColors.primaryPurple,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'horoscope.preparing_title'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'horoscope.preparing_subtitle'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 48),
              _buildProgressTip(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressTip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softLavender,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: AppColors.primaryPurple,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'horoscope.loading_tip'.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primaryText,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
