import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_service.dart';

class HoroscopeServiceCard extends StatelessWidget {
  final HoroscopeService service;
  final VoidCallback onTap;

  const HoroscopeServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = service.theme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.lightBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Premium Image/Icon Container
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.secondary.withAlpha((0.3 * 255).toInt()),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      service.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          service.iconData,
                          color: AppColors.primaryGreen,
                          size: 32,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              service.name.tr(),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.primaryText,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                              maxLines: 2,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.subtitle.tr(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                        maxLines: 3,
                        softWrap: true,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            service.currentPrice,
                            style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            service.originalPrice,
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.sheetBackground,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.lightBorder, width: 1),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
