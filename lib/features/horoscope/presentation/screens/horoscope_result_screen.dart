import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/common/custom_app_bar.dart';
import '../../data/models/horoscope_response.dart';
import '../widgets/horoscope_result_item.dart';

class HoroscopeResultScreen extends StatelessWidget {
  const HoroscopeResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final response =
        ModalRoute.of(context)!.settings.arguments as HoroscopeResponse;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(title: 'horoscope.title'.tr(), centerTitle: false),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, response),
              const SizedBox(height: 32),
              Text(
                'horoscope.todays_horoscope'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryPurple,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              HoroscopeResultItem(
                title: 'horoscope.love'.tr(),
                content: response.love,
                icon: Icons.favorite_rounded,
                color: const Color(0xFFE0528F),
              ),
              HoroscopeResultItem(
                title: 'horoscope.career'.tr(),
                content: response.career,
                icon: Icons.work_rounded,
                color: const Color(0xFF2563EB),
              ),
              HoroscopeResultItem(
                title: 'horoscope.finance'.tr(),
                content: response.finance,
                icon: Icons.account_balance_wallet_rounded,
                color: const Color(0xFF0F9D78),
              ),
              HoroscopeResultItem(
                title: 'horoscope.health'.tr(),
                content: response.health,
                icon: Icons.health_and_safety_rounded,
                color: const Color(0xFFE05252),
              ),
              HoroscopeResultItem(
                title: 'horoscope.luck'.tr(),
                content: response.luck,
                icon: Icons.auto_awesome_rounded,
                color: AppColors.premiumGold,
              ),
              const SizedBox(height: 16),
              _buildLuckySection(context, response),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HoroscopeResponse response) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withAlpha((0.3 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2 * 255).toInt()),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withAlpha((0.3 * 255).toInt()),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'horoscope.zodiac.${response.zodiacSign}'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getTamilName(response.zodiacSign),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withAlpha((0.8 * 255).toInt()),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuckySection(BuildContext context, HoroscopeResponse response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'horoscope.luck'.tr().toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primaryPurple,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildLuckyRow(
                context,
                'horoscope.lucky_number'.tr(),
                response.luckyNumber.toString(),
                Icons.looks_one_rounded,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, color: AppColors.border),
              ),
              _buildLuckyRow(
                context,
                'horoscope.lucky_color'.tr(),
                response.luckyColor,
                Icons.palette_rounded,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, color: AppColors.border),
              ),
              _buildLuckyRow(
                context,
                'horoscope.lucky_time'.tr(),
                response.luckyTime,
                Icons.access_time_filled_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLuckyRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.softLavender,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 18),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ],
    );
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
