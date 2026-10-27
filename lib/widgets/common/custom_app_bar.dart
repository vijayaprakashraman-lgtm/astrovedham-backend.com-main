import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrovedham/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBottomDivider;
  final bool centerTitle;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBottomDivider = false,
    this.centerTitle = true,
    this.backgroundColor,
    this.systemOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    );

    return AppBar(
      systemOverlayStyle: systemOverlayStyle ?? defaultOverlayStyle,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
              fontSize: 22,
              color: isDark ? AppColors.darkTextPrimary : AppColors.primaryText,
            ),
      ),
      actions: actions,
      leading: leading,
      backgroundColor:
          backgroundColor ?? (isDark ? Colors.transparent : Colors.transparent),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : AppColors.primaryGreen,
      ),
      bottom: showBottomDivider
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                height: 1,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
