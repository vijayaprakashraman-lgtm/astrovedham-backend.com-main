import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import 'package:astrovedham/widgets/common/app_drawer.dart';
import 'package:astrovedham/core/theme/app_colors.dart';

class CancelledOrdersScreen extends StatelessWidget {
  const CancelledOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      drawer: const AppDrawer(),
      appBar: CustomAppBar(
        title: 'navigation.cancelled'.tr(),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Center(
        child: Text(
          'common.placeholder_cancelled'.tr(),
          style: const TextStyle(color: AppColors.secondaryText),
        ),
      ),
    );
  }
}
