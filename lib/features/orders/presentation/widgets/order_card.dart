import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/service_visual_helper.dart';
import '../../../../models/order.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onViewPdf;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onViewDetails;

  const OrderCard({
    super.key,
    required this.order,
    this.onViewPdf,
    this.onDownloadPdf,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final serviceVisual = ServiceVisualHelper.fromOrder(order);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;
    final hintTextColor = isDark ? AppColors.textHintDark : AppColors.textHint;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withAlpha(
              ((isDark ? 0.2 : 0.03) * 255).toInt(),
            ),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildServiceIcon(serviceVisual, isDark),
                    _buildStatusBadge(),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  serviceVisual.localizedTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${'orders.order_id'.tr()}${order.orderNumber}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: hintTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'orders.order_date'.tr(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: secondaryTextColor),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd MMM yyyy').format(order.createdAt),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'orders.amount'.tr(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: secondaryTextColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${order.currency} ${order.amount.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: isDark
                                    ? AppColors.premiumGoldLight
                                    : AppColors.primaryIndigo,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.dividerDark : AppColors.divider,
          ),
          _buildActionRow(context, isDark, secondaryTextColor),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(ServiceVisualInfo visual, bool isDark) {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceElevated
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          visual.imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              visual.iconData,
              color: isDark ? AppColors.premiumGoldLight : AppColors.primaryIndigo,
              size: 24,
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    IconData icon;
    String label;

    switch (order.status) {
      case OrderStatus.PENDING:
        color = AppColors.warning;
        icon = Icons.access_time_rounded;
        label = 'orders.pending'.tr();
        break;
      case OrderStatus.SUCCESS:
        color = AppColors.success;
        icon = Icons.check_circle_outline_rounded;
        label = 'orders.success'.tr();
        break;
      case OrderStatus.CANCELLED:
        color = AppColors.error;
        icon = Icons.cancel_outlined;
        label = 'orders.cancelled'.tr();
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    bool isDark,
    Color secondaryTextColor,
  ) {
    final bool isSuccess =
        order.status == OrderStatus.SUCCESS && order.resultAvailable;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextButton.icon(
              onPressed: onViewDetails,
              icon: const Icon(Icons.info_outline_rounded, size: 18),
              label: Text(
                'orders.view_details'.tr(),
                overflow: TextOverflow.ellipsis,
              ),
              style: TextButton.styleFrom(
                foregroundColor: secondaryTextColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
            ),
          ),
          if (isSuccess) ...[
            const SizedBox(width: 6),
            Flexible(
              child: ElevatedButton.icon(
                onPressed: onViewPdf,
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: Text(
                  'orders.view_report'.tr(),
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.primaryIndigoDark
                      : AppColors.surfaceElevated,
                  foregroundColor: isDark
                      ? Colors.white
                      : AppColors.primaryIndigo,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (onDownloadPdf != null) ...[
              const SizedBox(width: 6),
              Tooltip(
                message: 'orders.download_report'.tr(),
                child: Material(
                  color: isDark
                      ? AppColors.primaryIndigoDark
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: onDownloadPdf,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.download_rounded,
                        size: 20,
                        color: isDark
                            ? Colors.white
                            : AppColors.primaryIndigo,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ] else if (order.status == OrderStatus.PENDING) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'orders.preparing'.tr(),
                style: const TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
