import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';

class InputSectionHeader extends StatelessWidget {
  final String titleKey;
  final String? subtitleKey;

  const InputSectionHeader({
    super.key,
    required this.titleKey,
    this.subtitleKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleKey.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.primaryGreen,
            fontSize: 18,
          ),
        ),
        if (subtitleKey != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitleKey!.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.secondaryText,
              height: 1.4,
            ),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }
}

class PremiumInputContainer extends StatelessWidget {
  final Widget child;
  final String labelKey;
  final IconData? icon;

  const PremiumInputContainer({
    super.key,
    required this.child,
    required this.labelKey,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            labelKey.tr(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.secondaryText,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.border,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}

class ChipGroupSelector extends StatelessWidget {
  final List<String> options;
  final List<String> selectedValues;
  final Function(String) onSelected;
  final bool multiSelect;

  const ChipGroupSelector({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onSelected,
    this.multiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final isSelected = selectedValues.contains(opt);
        return InkWell(
          onTap: () => onSelected(opt),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                        ? AppColors.darkSurfaceElevated
                        : AppColors.surfaceElevated)
                  : (isDark ? AppColors.darkSurface : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.primaryGreen)
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: (isDark ? Colors.black : AppColors.primaryGreen)
                            .withAlpha((0.1 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              opt.tr(),
              style: TextStyle(
                color: isSelected
                    ? (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.primaryGreen)
                    : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.primaryText),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SingleSelectCardGroup extends StatelessWidget {
  final List<String> options;
  final String? selectedValue;
  final Function(String) onSelected;

  const SingleSelectCardGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: options.map((opt) {
        final isSelected = selectedValue == opt;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => onSelected(opt),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.surfaceElevated.withAlpha(
                              (0.5 * 255).toInt(),
                            ))
                    : (isDark ? AppColors.darkSurface : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.primaryGreen)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).toInt()),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      opt.tr(),
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? (isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.primaryGreen)
                            : (isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.primaryText),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.primaryGreen,
                      size: 22,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
