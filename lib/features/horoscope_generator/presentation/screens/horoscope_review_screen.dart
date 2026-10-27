import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import 'package:astrovedham/widgets/buttons/primary_button.dart';
import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_service.dart';
import 'package:astrovedham/core/providers/order_provider.dart';

class HoroscopeReviewScreen extends StatelessWidget {
  final HoroscopeService service;
  final dynamic data;

  const HoroscopeReviewScreen({super.key, required this.service, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'common.review'.tr(),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewCard(context),
            const SizedBox(height: 40),
            PrimaryButton(
              text: 'common.generate'.tr(),
              onTap: () async {
                try {
                  final orderData = {
                    'horoscopeType': service.id,
                    'horoscopeTitle': service.name.tr(),
                    'amount': 499.0,
                    'currency': 'INR',
                    'inputDetails': data,
                  };

                  await context.read<OrderProvider>().addOrder(orderData);

                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.root,
                    (route) => false,
                    arguments: 1, // Index for My Orders tab
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('orders.error_msg'.tr(args: [e.toString()])),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            context,
            'forms.full_name'.tr(),
            'John Doe',
          ), // Mock for now
          const Divider(height: 32),
          _buildInfoRow(context, 'forms.gender'.tr(), 'common.male'.tr()),
          const Divider(height: 32),
          _buildInfoRow(context, 'forms.dob'.tr(), '15 July 1990'),
          const Divider(height: 32),
          _buildInfoRow(context, 'forms.birth_place'.tr(), 'Chennai, India'),
          const Divider(height: 32),
          _buildInfoRow(context, 'navigation.services'.tr(), service.name.tr()),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
