import 'package:flutter/material.dart';
import 'package:astrovedham/core/theme/app_colors.dart';

enum StatusType { success, error, warning, info }

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;

  const StatusBadge({super.key, required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color textColor;

    switch (type) {
      case StatusType.success:
        color = AppColors.success.withAlpha((0.1 * 255).toInt());
        textColor = AppColors.success;
        break;
      case StatusType.error:
        color = AppColors.error.withAlpha((0.1 * 255).toInt());
        textColor = AppColors.error;
        break;
      case StatusType.warning:
        color = AppColors.warning.withAlpha((0.1 * 255).toInt());
        textColor = AppColors.warning;
        break;
      case StatusType.info:
        color = AppColors.primaryPurple.withAlpha((0.1 * 255).toInt());
        textColor = AppColors.primaryPurple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
