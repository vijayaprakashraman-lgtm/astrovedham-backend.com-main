import 'package:flutter/material.dart';
import 'package:astrovedham/core/theme/app_colors.dart';

enum HoroscopeServiceType {
  astrologer,
  life,
  superLife,
  marriage,
  marriageMatchingLite,
  marriageMatchingPro,
  singlePage,
  wealth,
  yearly,
  gemstones,
  numerology,
}

class HoroscopeService {
  final String id;
  final String name; // Localization key
  final String description; // Localization key
  final String subtitle; // Localization key
  final String imagePath;
  final IconData iconData;
  final HoroscopeServiceType type;
  final List<String> highlights;
  final String originalPrice;
  final String currentPrice;
  final String discount;
  final int samplePages;
  final String methodTitle; // Localization key
  final String methodDesc; // Localization key
  final String ctaKey; // Localized CTA key
  final String samplePdfUrl;
  final bool isPremium;

  const HoroscopeService({
    required this.id,
    required this.name,
    required this.description,
    required this.subtitle,
    required this.imagePath,
    required this.iconData,
    required this.type,
    required this.highlights,
    required this.originalPrice,
    required this.currentPrice,
    required this.discount,
    required this.samplePages,
    required this.methodTitle,
    required this.methodDesc,
    required this.ctaKey,
    required this.samplePdfUrl,
    this.isPremium = false,
  });

  ServiceThemeColors get theme {
    switch (type) {
      case HoroscopeServiceType.astrologer:
        return AppColors.serviceThemes['astrologer']!;
      case HoroscopeServiceType.life:
        return AppColors.serviceThemes['life']!;
      case HoroscopeServiceType.superLife:
        return AppColors.serviceThemes['super_life']!;
      case HoroscopeServiceType.marriage:
        return AppColors.serviceThemes['marriage']!;
      case HoroscopeServiceType.marriageMatchingLite:
        return AppColors.serviceThemes['marriage_matching_lite']!;
      case HoroscopeServiceType.marriageMatchingPro:
        return AppColors.serviceThemes['marriage_matching_pro']!;
      case HoroscopeServiceType.singlePage:
        return AppColors.serviceThemes['single_page']!;
      case HoroscopeServiceType.wealth:
        return AppColors.serviceThemes['wealth']!;
      case HoroscopeServiceType.yearly:
        return AppColors.serviceThemes['yearly']!;
      case HoroscopeServiceType.gemstones:
        return AppColors.serviceThemes['gemstones']!;
      case HoroscopeServiceType.numerology:
        return AppColors.serviceThemes['numerology']!;
    }
  }

  /// Map to documented backend plan_type string
  String? get apiPlanType {
    switch (type) {
      case HoroscopeServiceType.singlePage:
        return 'Single';
      case HoroscopeServiceType.life:
        return 'Life';
      case HoroscopeServiceType.yearly:
        return 'Yearly';
      case HoroscopeServiceType.superLife:
        return 'Super';
      case HoroscopeServiceType.numerology:
        return 'Numerology';
      case HoroscopeServiceType.gemstones:
        return 'Gemstone';
      case HoroscopeServiceType.wealth:
        return 'Wealth';
      case HoroscopeServiceType.marriage:
        return 'MarriageH';
      case HoroscopeServiceType.marriageMatchingLite:
        return 'Marriage';
      case HoroscopeServiceType.marriageMatchingPro:
        return 'ProMarriage';
      case HoroscopeServiceType.astrologer:
        return null; // Consultation is not a horoscope generator plan type
    }
  }

  static const List<HoroscopeService> allServices = [
    HoroscopeService(
      id: 'astrologer-consultation',
      name: 'services.astrologer',
      description: 'services.consultation_subtitle',
      subtitle: 'services.consultation_subtitle',
      imagePath: 'assets/images/astrologer.webp',
      iconData: Icons.person_search_rounded,
      type: HoroscopeServiceType.astrologer,
      originalPrice: '₹999',
      currentPrice: '₹500',
      discount: '50% OFF',
      samplePages: 0,
      methodTitle: 'services.how_it_works',
      methodDesc: 'services.consultation_subtitle',
      ctaKey: 'common.continue',
      samplePdfUrl: '',
      highlights: [
        'services.benefit_1',
        'services.benefit_2',
        'services.benefit_3',
        'services.benefit_4',
        'services.benefit_5',
        'services.benefit_6',
      ],
    ),
    HoroscopeService(
      id: 'life-horoscope',
      name: 'services.life',
      description: 'services.life_desc',
      subtitle: 'services.life_subtitle',
      imagePath: 'assets/images/life_horoscope.webp',
      iconData: Icons.auto_awesome_rounded,
      type: HoroscopeServiceType.life,
      originalPrice: '₹999',
      currentPrice: '₹199',
      discount: '80% OFF',
      samplePages: 73,
      methodTitle: 'services.method_title',
      methodDesc: 'services.method_desc',
      ctaKey: 'common.get_life',
      samplePdfUrl: 'https://files.msg91.com/456460/erjkjhqg.pdf',
      highlights: [
        'services.highlights.life_appearance',
        'services.highlights.life_education',
        'services.highlights.life_career',
        'services.highlights.life_wealth',
        'services.highlights.life_marriage_period',
        'services.highlights.life_house_yoga',
        'services.highlights.life_dasha_bhukti',
        'services.highlights.life_yogas',
        'services.highlights.life_doshas',
        'services.highlights.life_remedies',
        'services.highlights.life_planetary_results',
      ],
    ),
    HoroscopeService(
      id: 'super-life-horoscope',
      name: 'services.super_life',
      description: 'services.super_life_desc',
      subtitle: 'services.super_life_subtitle',
      imagePath: 'assets/images/super_life_horoscope.webp',
      iconData: Icons.stars_rounded,
      type: HoroscopeServiceType.superLife,
      isPremium: true,
      originalPrice: '₹999',
      currentPrice: '₹199',
      discount: '80% OFF',
      samplePages: 95,
      methodTitle: 'services.method_title',
      methodDesc: 'services.method_desc',
      ctaKey: 'common.get_super_life',
      samplePdfUrl: 'https://files.msg91.com/456460/vjhiaifk.pdf',
      highlights: [
        'services.highlights.life_appearance',
        'services.highlights.life_education',
        'services.highlights.life_career',
        'services.highlights.life_wealth',
        'services.highlights.life_marriage_period',
        'services.highlights.life_house_yoga',
        'services.highlights.life_dasha_bhukti',
        'services.highlights.life_yogas',
        'services.highlights.life_doshas',
        'services.highlights.life_remedies',
        'services.highlights.life_planetary_results',
        'services.highlights.super_full_remedies',
        'services.highlights.super_yoga_benefits',
        'services.highlights.super_growth_periods',
        'services.highlights.super_spiritual_remedies',
      ],
    ),
    HoroscopeService(
      id: 'marriage-horoscope',
      name: 'services.marriage',
      description: 'services.marriage_desc',
      subtitle: 'services.marriage_subtitle',
      imagePath: 'assets/images/marriage_horoscope.webp',
      iconData: Icons.favorite_rounded,
      type: HoroscopeServiceType.marriage,
      originalPrice: '₹399',
      currentPrice: '₹99',
      discount: '75% OFF',
      samplePages: 16,
      methodTitle: 'services.method_title',
      methodDesc: 'services.method_desc',
      ctaKey: 'common.get_marriage',
      samplePdfUrl: 'https://files.msg91.com/456460/wojedqeu.pdf',
      highlights: [
        'services.highlights.mar_marriage_period',
        'services.highlights.mar_marriage_obstacle',
        'services.highlights.mar_doshas',
        'services.highlights.mar_remedies',
        'services.highlights.mar_partner_nature',
        'services.highlights.mar_future',
      ],
    ),
    HoroscopeService(
      id: 'marriage-matching-lite',
      name: 'services.marriage_matching_lite',
      description: 'services.marriage_matching_lite_desc',
      subtitle: 'services.marriage_matching_lite_subtitle',
      imagePath: 'assets/images/marriage_matching.webp',
      iconData: Icons.favorite_outline_rounded,
      type: HoroscopeServiceType.marriageMatchingLite,
      originalPrice: '₹249',
      currentPrice: '₹49',
      discount: '80% OFF',
      samplePages: 4,
      methodTitle: 'services.matching_method_title',
      methodDesc: 'services.matching_method_desc',
      ctaKey: 'common.get_matching',
      samplePdfUrl: 'https://files.msg91.com/456460/xzbahqlu.pdf',
      highlights: [
        'services.highlights.match_10_poruthams',
        'services.highlights.match_rasi',
        'services.highlights.match_star',
        'services.highlights.match_dosha',
        'services.highlights.match_advice',
      ],
    ),
    HoroscopeService(
      id: 'marriage-matching-pro',
      name: 'services.marriage_matching_pro',
      description: 'services.marriage_matching_pro_desc',
      subtitle: 'services.marriage_matching_pro_subtitle',
      imagePath: 'assets/images/marriage_matching_pro.webp',
      iconData: Icons.favorite_rounded,
      type: HoroscopeServiceType.marriageMatchingPro,
      isPremium: true,
      originalPrice: '₹500',
      currentPrice: '₹99',
      discount: '80% OFF',
      samplePages: 7,
      methodTitle: 'services.matching_method_title',
      methodDesc: 'services.matching_method_desc',
      ctaKey: 'common.get_matching',
      samplePdfUrl: 'https://files.msg91.com/456460/qtthqils.pdf',
      highlights: [
        'services.highlights.match_10_poruthams',
        'services.highlights.match_rasi',
        'services.highlights.match_star',
        'services.highlights.match_vedha',
        'services.highlights.match_mahendram',
        'services.highlights.match_yoni',
        'services.highlights.match_rajju',
        'services.highlights.match_dosha',
        'services.highlights.match_sevvai',
        'services.highlights.match_rahu_ketu',
        'services.highlights.match_advice',
      ],
    ),
    HoroscopeService(
      id: 'single-page-horoscope',
      name: 'services.single_page',
      description: 'services.single_page_desc',
      subtitle: 'services.single_page_subtitle',
      imagePath: 'assets/images/single_page_horoscope.webp',
      iconData: Icons.description_rounded,
      type: HoroscopeServiceType.singlePage,
      originalPrice: '₹99',
      currentPrice: '₹30',
      discount: '70% OFF',
      samplePages: 1,
      methodTitle: 'services.method_title',
      methodDesc: 'services.method_desc',
      ctaKey: 'common.get_single_page',
      samplePdfUrl: 'https://files.msg91.com/456460/stkyaxde.pdf',
      highlights: [
        'services.highlights.sin_rasi',
        'services.highlights.sin_star',
        'services.highlights.sin_lagnam',
        'services.highlights.sin_rasi_chart',
        'services.highlights.sin_navamsa',
        'services.highlights.sin_thirukanitham',
      ],
    ),
    HoroscopeService(
      id: 'wealth-horoscope',
      name: 'services.wealth',
      description: 'services.wealth_desc',
      subtitle: 'services.wealth_subtitle',
      imagePath: 'assets/images/wealth_horoscope.webp',
      iconData: Icons.account_balance_wallet_rounded,
      type: HoroscopeServiceType.wealth,
      originalPrice: '₹399',
      currentPrice: '₹99',
      discount: '75% OFF',
      samplePages: 20,
      methodTitle: 'services.method_title',
      methodDesc: 'services.method_desc',
      ctaKey: 'common.get_wealth',
      samplePdfUrl: 'https://files.msg91.com/456460/bfmmelgv.pdf',
      highlights: [
        'services.highlights.wea_wealth_yoga',
        'services.highlights.wea_career_yoga',
        'services.highlights.wea_income',
        'services.highlights.wea_luck',
        'services.highlights.wea_investment',
        'services.highlights.wea_house',
        'services.highlights.wea_land',
        'services.highlights.wea_vehicle',
        'services.highlights.wea_business_growth',
      ],
    ),
    HoroscopeService(
      id: 'yearly-prediction',
      name: 'services.yearly',
      description: 'services.yearly_desc',
      subtitle: 'services.yearly_subtitle',
      imagePath: 'assets/images/yearly_prediction.webp',
      iconData: Icons.calendar_today_rounded,
      type: HoroscopeServiceType.yearly,
      originalPrice: '₹299',
      currentPrice: '₹99',
      discount: '67% OFF',
      samplePages: 18,
      methodTitle: 'services.method_title',
      methodDesc: 'services.method_desc',
      ctaKey: 'common.get_yearly',
      samplePdfUrl: 'https://files.msg91.com/456460/wqvwvdjn.pdf',
      highlights: [
        'services.highlights.yea_full_results',
        'services.highlights.yea_monthly',
        'services.highlights.yea_career',
        'services.highlights.yea_marriage',
        'services.highlights.yea_education',
        'services.highlights.yea_health',
        'services.highlights.yea_income',
        'services.highlights.yea_transit',
        'services.highlights.yea_good_days',
        'services.highlights.yea_caution_periods',
      ],
    ),
    HoroscopeService(
      id: 'gemstones-horoscope',
      name: 'services.gemstones',
      description: 'services.gemstones_desc',
      subtitle: 'services.gemstones_subtitle',
      imagePath: 'assets/images/gemstones_horoscope.webp',
      iconData: Icons.diamond_rounded,
      type: HoroscopeServiceType.gemstones,
      originalPrice: '₹399',
      currentPrice: '₹99',
      discount: '75% OFF',
      samplePages: 8,
      methodTitle: 'services.method_title',
      methodDesc: 'services.method_desc',
      ctaKey: 'common.get_gemstones',
      samplePdfUrl: 'https://files.msg91.com/456460/qheosxyh.pdf',
      highlights: [
        'services.highlights.gem_lucky_gems',
        'services.highlights.gem_weak_planet',
        'services.highlights.gem_strong_planet',
        'services.highlights.gem_wearable',
        'services.highlights.gem_avoidable',
        'services.highlights.gem_method',
      ],
    ),
    HoroscopeService(
      id: 'numerology-horoscope',
      name: 'services.numerology',
      description: 'services.numerology_desc',
      subtitle: 'services.numerology_subtitle',
      imagePath: 'assets/images/numerology_horoscope.webp',
      iconData: Icons.looks_one_rounded,
      type: HoroscopeServiceType.numerology,
      originalPrice: '₹199',
      currentPrice: '₹49',
      discount: '75% OFF',
      samplePages: 9,
      methodTitle: 'services.method_title',
      methodDesc: 'services.method_desc',
      ctaKey: 'common.get_numerology',
      samplePdfUrl: 'https://files.msg91.com/456460/irmdubzf.pdf',
      highlights: [
        'services.highlights.num_birth_number',
        'services.highlights.num_destiny_number',
        'services.highlights.num_name_number',
        'services.highlights.num_lucky_numbers',
        'services.highlights.num_colors',
        'services.highlights.num_dates',
        'services.highlights.num_career',
        'services.highlights.num_marriage',
      ],
    ),

  ];
}
