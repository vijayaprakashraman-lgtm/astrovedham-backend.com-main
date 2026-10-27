import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';

import '../widgets/celestial_welcome_banner.dart';
import '../widgets/horoscope_services_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'app_name'.tr(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CelestialWelcomeBanner(),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: HoroscopeServicesSection(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
