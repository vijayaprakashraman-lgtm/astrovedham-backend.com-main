import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';

class ZodiacCard extends StatelessWidget {
  final String signKey;
  final bool isSelected;
  final bool isUserSign;
  final VoidCallback onTap;

  const ZodiacCard({
    super.key,
    required this.signKey,
    required this.isSelected,
    required this.onTap,
    this.isUserSign = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withAlpha(
                      (0.12 * 255).toInt(),
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.03 * 255).toInt()),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                right: -8,
                top: -8,
                child: Icon(
                  Icons.auto_awesome,
                  color: AppColors.sacredGold.withAlpha((0.2 * 255).toInt()),
                  size: 44,
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.sheetBackground
                            : AppColors.sheetBackground.withAlpha((0.5 * 255).toInt()),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _getZodiacIcon(signKey),
                        color: isSelected ? AppColors.primaryGreen : AppColors.secondaryText,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'horoscope.zodiac.$signKey'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.primaryText,
                        fontSize: 14,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (context.locale.languageCode != 'ta') ...[
                      const SizedBox(height: 4),
                      Text(
                        _getTamilName(signKey),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primaryGreen.withAlpha(
                                  (0.7 * 255).toInt(),
                                )
                              : AppColors.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (isUserSign)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.sacredGold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getZodiacIcon(String key) {
    switch (key) {
      case 'aries':
        return Icons.auto_awesome_rounded;
      case 'taurus':
        return Icons.auto_awesome_rounded;
      case 'gemini':
        return Icons.auto_awesome_rounded;
      case 'cancer':
        return Icons.auto_awesome_rounded;
      case 'leo':
        return Icons.auto_awesome_rounded;
      case 'virgo':
        return Icons.auto_awesome_rounded;
      case 'libra':
        return Icons.auto_awesome_rounded;
      case 'scorpio':
        return Icons.auto_awesome_rounded;
      case 'sagittarius':
        return Icons.auto_awesome_rounded;
      case 'capricorn':
        return Icons.auto_awesome_rounded;
      case 'aquarius':
        return Icons.auto_awesome_rounded;
      case 'pisces':
        return Icons.auto_awesome_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  String _getTamilName(String key) {
    switch (key) {
      case 'aries':
        return 'மேஷம்';
      case 'taurus':
        return 'ரிஷபம்';
      case 'gemini':
        return 'மிதுனம்';
      case 'cancer':
        return 'கடகம்';
      case 'leo':
        return 'சிம்மம்';
      case 'virgo':
        return 'கன்னி';
      case 'libra':
        return 'துலாம்';
      case 'scorpio':
        return 'விருச்சிகம்';
      case 'sagittarius':
        return 'தனுசு';
      case 'capricorn':
        return 'மகரம்';
      case 'aquarius':
        return 'கும்பம்';
      case 'pisces':
        return 'மீனம்';
      default:
        return '';
    }
  }
}
