import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../widgets/common/custom_app_bar.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../widgets/zodiac_card.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  String? _selectedSign;
  String? _userSign;

  final List<String> _signs = [
    'aries',
    'taurus',
    'gemini',
    'cancer',
    'leo',
    'virgo',
    'libra',
    'scorpio',
    'sagittarius',
    'capricorn',
    'aquarius',
    'pisces',
  ];

  @override
  void initState() {
    super.initState();
    _userSign = LocalStorageService.instance.getZodiac();
    _selectedSign = _userSign;
  }

  void _onSignTap(String sign) {
    setState(() {
      _selectedSign = sign;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      appBar: CustomAppBar(
        title: 'horoscope.title'.tr(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _signs.length,
                      itemBuilder: (context, index) {
                        final sign = _signs[index];
                        return _staggeredAnimation(
                          index: index,
                          child: ZodiacCard(
                            signKey: sign,
                            isSelected: _selectedSign == sign,
                            isUserSign: _userSign == sign,
                            onTap: () => _onSignTap(sign),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildBottomAction(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'horoscope.discover_cosmic'.tr(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryText,
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withAlpha((0.05 * 255).toInt()),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.primaryGreen,
                size: 32,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'horoscope.header_desc'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.secondaryText,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: PrimaryButton(
        text: 'horoscope.start_horoscope'.tr().toUpperCase(),
        onTap: _selectedSign == null
            ? null
            : () async {
                final navigator = Navigator.of(context);
                await LocalStorageService.instance.setZodiac(_selectedSign);
                if (mounted) {
                  navigator.pushNamed(
                    AppRoutes.horoscopeInput,
                    arguments: _selectedSign,
                  );
                }
              },
      ),
    );
  }

  Widget _staggeredAnimation({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.9 + (0.1 * value), child: child),
        );
      },
      child: child,
    );
  }
}
