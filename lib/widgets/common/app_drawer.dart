import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  label: 'navigation.home'.tr(),
                  isSelected:
                      ModalRoute.of(context)?.settings.name == AppRoutes.root,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.auto_awesome_outlined,
                  label: 'navigation.services'.tr(),
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.receipt_long_outlined,
                  label: 'navigation.orders'.tr(),
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.cancel_outlined,
                  label: 'navigation.cancelled'.tr(),
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(indent: 16, endIndent: 16, height: 32),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  label: 'navigation.profile'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  label: 'navigation.settings'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  label: 'navigation.about'.tr(),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${'common.version'.tr()} 1.0.0',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.hintText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
      decoration: const BoxDecoration(color: AppColors.primaryBackground),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withAlpha((0.1 * 255).toInt()),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.primaryPurple,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'app_name'.tr(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primaryPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'tagline'.tr(),
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primaryPurple : AppColors.secondaryText,
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.primaryPurple : AppColors.primaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        selected: isSelected,
        selectedTileColor: AppColors.primaryPurple.withAlpha(
          (0.1 * 255).toInt(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
