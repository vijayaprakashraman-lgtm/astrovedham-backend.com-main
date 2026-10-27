import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_service.dart';
import 'package:astrovedham/features/home/presentation/widgets/horoscope_service_card.dart';
import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/core/theme/app_colors.dart';

class HoroscopeServicesSection extends StatelessWidget {
  const HoroscopeServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = HoroscopeService.allServices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  Text(
                    'horoscope_services'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryText,
                          letterSpacing: -0.8,
                          fontSize: 22,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'horoscope_services_subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final service = services[index];
            return _staggeredEntrance(
              index: index,
              child: HoroscopeServiceCard(
                service: service,
                onTap: () {
                  if (service.type == HoroscopeServiceType.astrologer) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.consultationInfo,
                      arguments: service,
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.serviceInfo,
                      arguments: service,
                    );
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _staggeredEntrance({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 50)),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
