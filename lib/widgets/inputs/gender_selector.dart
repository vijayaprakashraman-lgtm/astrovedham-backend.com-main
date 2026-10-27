import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_input_models.dart';

class GenderSelector extends StatelessWidget {
  final Gender? selectedGender;
  final Function(Gender) onSelected;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'forms.gender'.tr(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGenderCard(
                context,
                gender: Gender.male,
                label: 'common.male'.tr(),
                icon: Icons.male,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderCard(
                context,
                gender: Gender.female,
                label: 'common.female'.tr(),
                icon: Icons.female,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(
    BuildContext context, {
    required Gender gender,
    required String label,
    required IconData icon,
  }) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () => onSelected(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.softLavender : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.border,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.secondaryText,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.primaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
