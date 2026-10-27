import 'package:flutter/material.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/core/animations/app_animations.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isFullWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onTap,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleButton(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.softLavender,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryPurple.withAlpha((0.3 * 255).toInt()),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primaryPurple,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
