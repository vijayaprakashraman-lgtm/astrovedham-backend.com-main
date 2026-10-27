import 'package:flutter/material.dart';
import 'package:astrovedham/core/theme/app_colors.dart';

class ChipSelector<T> extends StatelessWidget {
  final String label;
  final List<T> options;
  final List<T> selectedValues;
  final String Function(T) labelBuilder;
  final Function(T) onSelected;
  final bool multiSelect;

  const ChipSelector({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.labelBuilder,
    required this.onSelected,
    this.multiSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return ChoiceChip(
              label: Text(labelBuilder(option)),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
              selectedColor: AppColors.softLavender,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.primaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.border,
                ),
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }
}
