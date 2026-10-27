import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:astrovedham/core/theme/app_colors.dart';

class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;
    final outlineColor = theme.colorScheme.outline;
    final inactiveColor = AppColors.textHint;
    final activeTextColor = theme.colorScheme.onSurface;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          // Responsive pill width (between 280 and 380 logical pixels)
          final pillWidth = (screenWidth * 0.84).clamp(280.0, 380.0);
          final slotWidth = pillWidth / 3;
          final leftMargin = (screenWidth - pillWidth) / 2;

          const double pillHeight = 62.0;
          const double circleSize = 48.0;
          const double totalHeight = 80.0;
          const double circleTop = 2.0;
          const double pillTop = 18.0;

          // Sequential navigation flow:
          // Slot 0 (Left): Home (Index 0)
          // Slot 1 (Center): My Orders (Index 1)
          // Slot 2 (Right): Profile (Index 2)
          final int activeSlotIndex = currentIndex.clamp(0, 2);

          final activeSlotCenterX = leftMargin + (activeSlotIndex + 0.5) * slotWidth;
          final activeCircleLeft = activeSlotCenterX - (circleSize / 2);

          final activeIcon = _getIconForSlot(activeSlotIndex);

          return Container(
            height: totalHeight,
            width: screenWidth,
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 6),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Floating Stationary Navigation Pill Container
                Positioned(
                  top: pillTop,
                  left: leftMargin,
                  child: Container(
                    width: pillWidth,
                    height: pillHeight,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(31),
                      border: Border.all(
                        color: outlineColor.withValues(alpha: 0.35),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 18,
                          spreadRadius: 0,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Slot 0 (Left): Home (Index 0)
                        Expanded(
                          child: _buildNavItem(
                            slotIndex: 0,
                            targetIndex: 0,
                            labelKey: 'home',
                            fallbackLabel: 'Home',
                            icon: Icons.home_rounded,
                            isActive: activeSlotIndex == 0,
                            primaryColor: primaryColor,
                            inactiveColor: inactiveColor,
                            activeTextColor: activeTextColor,
                            onTap: () => onTap(0),
                          ),
                        ),
                        // Slot 1 (Center): My Orders (Index 1)
                        Expanded(
                          child: _buildNavItem(
                            slotIndex: 1,
                            targetIndex: 1,
                            labelKey: 'orders',
                            fallbackLabel: 'My Orders',
                            icon: Icons.receipt_long_rounded,
                            isActive: activeSlotIndex == 1,
                            primaryColor: primaryColor,
                            inactiveColor: inactiveColor,
                            activeTextColor: activeTextColor,
                            onTap: () => onTap(1),
                          ),
                        ),
                        // Slot 2 (Right): Profile (Index 2)
                        Expanded(
                          child: _buildNavItem(
                            slotIndex: 2,
                            targetIndex: 2,
                            labelKey: 'profile',
                            fallbackLabel: 'Profile',
                            icon: Icons.person_rounded,
                            isActive: activeSlotIndex == 2,
                            primaryColor: primaryColor,
                            inactiveColor: inactiveColor,
                            activeTextColor: activeTextColor,
                            onTap: () => onTap(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Animated Floating Active Raised Circle Button
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  top: circleTop,
                  left: activeCircleLeft,
                  child: GestureDetector(
                    onTap: () => onTap(activeSlotIndex),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                        border: Border.all(
                          color: surfaceColor,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.38),
                            blurRadius: 14,
                            spreadRadius: 1,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Icon(
                            activeIcon,
                            key: ValueKey<int>(activeSlotIndex),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForSlot(int slotIndex) {
    switch (slotIndex) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.receipt_long_rounded;
      case 2:
      default:
        return Icons.person_rounded;
    }
  }

  Widget _buildNavItem({
    required int slotIndex,
    required int targetIndex,
    required String labelKey,
    required String fallbackLabel,
    required IconData icon,
    required bool isActive,
    required Color primaryColor,
    required Color inactiveColor,
    required Color activeTextColor,
    required VoidCallback onTap,
  }) {
    String labelText;
    try {
      labelText = labelKey.tr();
    } catch (_) {
      labelText = fallbackLabel;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(31),
      highlightColor: Colors.transparent,
      splashColor: primaryColor.withValues(alpha: 0.08),
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Inactive icon space: Fades out when active because the raised active circle sits above it
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isActive ? 0.0 : 1.0,
              child: Icon(
                icon,
                size: 22,
                color: inactiveColor,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeTextColor : inactiveColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: Text(labelText, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
