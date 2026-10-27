import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:astrovedham/models/order.dart';

class ServiceVisualInfo {
  final String serviceSlug;
  final String titleKey;
  final String imagePath;
  final IconData iconData;

  const ServiceVisualInfo({
    required this.serviceSlug,
    required this.titleKey,
    required this.imagePath,
    required this.iconData,
  });

  /// Returns localized service title
  String get localizedTitle => titleKey.tr();
}

class ServiceVisualHelper {
  ServiceVisualHelper._();

  static const Map<String, ServiceVisualInfo> _map = {
    'super_life_horoscope': ServiceVisualInfo(
      serviceSlug: 'super_life_horoscope',
      titleKey: 'services.super_life',
      imagePath: 'assets/images/super_life_horoscope.webp',
      iconData: Icons.stars_rounded,
    ),
    'life_horoscope': ServiceVisualInfo(
      serviceSlug: 'life_horoscope',
      titleKey: 'services.life',
      imagePath: 'assets/images/life_horoscope.webp',
      iconData: Icons.auto_awesome_rounded,
    ),
    'complete_marriage_compatibility': ServiceVisualInfo(
      serviceSlug: 'complete_marriage_compatibility',
      titleKey: 'services.marriage_matching_pro',
      imagePath: 'assets/images/marriage_matching_pro.webp',
      iconData: Icons.favorite_rounded,
    ),
    'marriage_compatibility': ServiceVisualInfo(
      serviceSlug: 'marriage_compatibility',
      titleKey: 'services.marriage_matching_lite',
      imagePath: 'assets/images/marriage_matching.webp',
      iconData: Icons.favorite_outline_rounded,
    ),
    'marriage_horoscope': ServiceVisualInfo(
      serviceSlug: 'marriage_horoscope',
      titleKey: 'services.marriage',
      imagePath: 'assets/images/marriage_horoscope.webp',
      iconData: Icons.favorite_rounded,
    ),
    'single_page_horoscope': ServiceVisualInfo(
      serviceSlug: 'single_page_horoscope',
      titleKey: 'services.single_page',
      imagePath: 'assets/images/single_page_horoscope.webp',
      iconData: Icons.description_rounded,
    ),
    'wealth_horoscope': ServiceVisualInfo(
      serviceSlug: 'wealth_horoscope',
      titleKey: 'services.wealth',
      imagePath: 'assets/images/wealth_horoscope.webp',
      iconData: Icons.account_balance_wallet_rounded,
    ),
    'yearly_prediction': ServiceVisualInfo(
      serviceSlug: 'yearly_prediction',
      titleKey: 'services.yearly',
      imagePath: 'assets/images/yearly_prediction.webp',
      iconData: Icons.calendar_today_rounded,
    ),
    'gemstones_horoscope': ServiceVisualInfo(
      serviceSlug: 'gemstones_horoscope',
      titleKey: 'services.gemstones',
      imagePath: 'assets/images/gemstones_horoscope.webp',
      iconData: Icons.diamond_rounded,
    ),
    'numerology': ServiceVisualInfo(
      serviceSlug: 'numerology',
      titleKey: 'services.numerology',
      imagePath: 'assets/images/numerology_horoscope.webp',
      iconData: Icons.looks_one_rounded,
    ),
    'astrologer_consultation': ServiceVisualInfo(
      serviceSlug: 'astrologer_consultation',
      titleKey: 'services.astrologer',
      imagePath: 'assets/images/astrologer.webp',
      iconData: Icons.person_search_rounded,
    ),
  };

  /// Resolves the service visual information directly from an OrderModel
  static ServiceVisualInfo fromOrder(OrderModel order) {
    return resolve(
      horoscopeType: order.horoscopeType,
      horoscopeTitle: order.horoscopeTitle,
      serviceName: order.serviceName,
      serviceId: order.serviceId,
    );
  }

  /// Resolves service visual information from string candidates
  static ServiceVisualInfo resolve({
    String? horoscopeType,
    String? horoscopeTitle,
    String? serviceName,
    String? serviceId,
  }) {
    final candidates = [
      horoscopeType,
      serviceId,
      horoscopeTitle,
      serviceName,
    ].whereType<String>().where((s) => s.trim().isNotEmpty).toList();

    for (final rawCandidate in candidates) {
      final slug = _normalize(rawCandidate);

      if (slug.contains('super_life') || slug.contains('superlife')) {
        return _map['super_life_horoscope']!;
      }
      if (slug.contains('life')) {
        return _map['life_horoscope']!;
      }
      if (slug.contains('complete_marriage') ||
          slug.contains('marriage_matching_pro') ||
          slug.contains('complete_marriage_compatibility') ||
          slug.contains('complete marriage')) {
        return _map['complete_marriage_compatibility']!;
      }
      if (slug.contains('marriage_compatibility') ||
          slug.contains('marriage_matching_lite') ||
          slug.contains('marriage_matching') ||
          slug.contains('marriage matching') ||
          slug.contains('marriage compatibility')) {
        return _map['marriage_compatibility']!;
      }
      if (slug.contains('marriage')) {
        return _map['marriage_horoscope']!;
      }
      if (slug.contains('single_page') ||
          slug.contains('singlepage') ||
          slug.contains('single page')) {
        return _map['single_page_horoscope']!;
      }
      if (slug.contains('wealth')) {
        return _map['wealth_horoscope']!;
      }
      if (slug.contains('yearly')) {
        return _map['yearly_prediction']!;
      }
      if (slug.contains('gemstone') || slug.contains('gem')) {
        return _map['gemstones_horoscope']!;
      }
      if (slug.contains('numerology') || slug.contains('number')) {
        return _map['numerology']!;
      }
      if (slug.contains('astrologer') || slug.contains('consultation')) {
        return _map['astrologer_consultation']!;
      }
    }

    if (kDebugMode) {
      debugPrint(
        '[SERVICE_MAPPING] Unresolved service from order candidates: $candidates. Using fallback.',
      );
    }

    // Fallback: Use serviceName / horoscopeTitle if available, otherwise generic
    final displayTitleKey =
        (horoscopeTitle != null && horoscopeTitle.trim().isNotEmpty)
            ? horoscopeTitle
            : ((serviceName != null && serviceName.trim().isNotEmpty)
                ? serviceName
                : 'horoscope.title');

    return ServiceVisualInfo(
      serviceSlug: 'unknown',
      titleKey: displayTitleKey,
      imagePath: 'assets/images/app_icon.png',
      iconData: Icons.auto_awesome_rounded,
    );
  }

  static String _normalize(String input) {
    return input.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  }
}
