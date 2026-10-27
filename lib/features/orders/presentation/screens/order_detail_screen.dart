import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/models/order.dart';
import 'package:astrovedham/core/providers/order_provider.dart';
import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/core/utils/file_utils.dart';
import 'package:astrovedham/core/services/local_report_service.dart';
import 'package:astrovedham/core/utils/service_visual_helper.dart';
import 'package:astrovedham/core/notifications/notification_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderNumber;

  const OrderDetailScreen({super.key, required this.orderNumber});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<OrderModel?> _orderFuture;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('[ORDER DEBUG] OrderDetailScreen initState for: ${widget.orderNumber}');
    }
    _orderFuture = context.read<OrderProvider>().getOrderDetails(
      widget.orderNumber,
    );
  }

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.root,
        (route) => false,
        arguments: 1, // Index for My Orders tab
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1FFF7), // Light mint AstroVedham background
        body: SafeArea(
          child: FutureBuilder<OrderModel?>(
            future: _orderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2E9B68)),
                );
              }

              if (snapshot.hasError || snapshot.data == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'horoscope.error.something_went_wrong'.tr(),
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: const Color(0xFF0B4F3A),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _orderFuture = context
                                  .read<OrderProvider>()
                                  .getOrderDetails(widget.orderNumber);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E9B68),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(160, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text('horoscope.error.try_again'.tr()),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final order = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopHeader(context),
                    const SizedBox(height: 12),
                    _buildOrderHeroCard(order),
                    const SizedBox(height: 16),
                    _buildStatusSection(order),
                    const SizedBox(height: 16),
                    _buildOrderTimeline(order),
                    const SizedBox(height: 20),
                    _buildPersonalDetailsCard(context, order),
                    const SizedBox(height: 20),
                    _buildBirthDetailsCard(context, order),
                    if (order.status == OrderStatus.SUCCESS && order.resultAvailable) ...[
                      const SizedBox(height: 28),
                      _buildActionButton(context, order),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Material(
            color: const Color(0xFFDDF8E9),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => _handleBack(context),
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF0B4F3A),
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'orders.view_details'.tr(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0B4F3A),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeroCard(OrderModel order) {
    final serviceVisual = ServiceVisualHelper.fromOrder(order);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDF8E9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B4F3A).withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF8E9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                serviceVisual.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    serviceVisual.iconData,
                    color: const Color(0xFF0B4F3A),
                    size: 28,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceVisual.localizedTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: const Color(0xFF0B4F3A),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${'orders.order_id'.tr()}${order.orderNumber}',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF6B7D75),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(OrderModel order) {
    Color statusBg;
    Color statusBorder;
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (order.status) {
      case OrderStatus.PENDING:
        statusBg = const Color(0xFFFFFBEB);
        statusBorder = const Color(0xFFFDE68A);
        statusColor = const Color(0xFFD88A18);
        statusIcon = Icons.access_time_filled_rounded;
        statusText = 'orders.pending'.tr();
        break;
      case OrderStatus.SUCCESS:
        statusBg = const Color(0xFFECFDF5);
        statusBorder = const Color(0xFFA7F3D0);
        statusColor = const Color(0xFF2E9B68);
        statusIcon = Icons.check_circle_rounded;
        statusText = 'orders.success'.tr();
        break;
      case OrderStatus.CANCELLED:
        statusBg = const Color(0xFFFEF2F2);
        statusBorder = const Color(0xFFFCA5A5);
        statusColor = const Color(0xFFC94A4A);
        statusIcon = Icons.cancel_rounded;
        statusText = 'orders.cancelled'.tr();
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: statusBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusBorder),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 22),
          const SizedBox(width: 12),
          Text(
            statusText,
            style: GoogleFonts.plusJakartaSans(
              color: statusColor,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          Text(
            DateFormat('dd MMM yyyy\nhh:mm a').format(order.createdAt),
            textAlign: TextAlign.right,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF6B7D75),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline(OrderModel order) {
    final bool isPlaced = true;
    final bool isProcessing = order.status == OrderStatus.PENDING || order.status == OrderStatus.SUCCESS;
    final bool isCompleted = order.status == OrderStatus.SUCCESS;
    final bool isCancelled = order.status == OrderStatus.CANCELLED;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDF8E9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B4F3A).withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTimelineStep(
            label: 'orders.order_placed'.tr(),
            isDone: isPlaced,
            color: const Color(0xFF2E9B68),
            icon: Icons.check_rounded,
          ),
          _buildTimelineConnector(isDone: isProcessing && !isCancelled),
          _buildTimelineStep(
            label: isCancelled ? 'orders.cancelled'.tr() : 'orders.processing'.tr(),
            isDone: isCompleted,
            color: isCancelled
                ? const Color(0xFFC94A4A)
                : (isCompleted ? const Color(0xFF2E9B68) : const Color(0xFFD88A18)),
            icon: isCancelled
                ? Icons.close_rounded
                : (isCompleted ? Icons.check_rounded : Icons.sync_rounded),
          ),
          _buildTimelineConnector(isDone: isCompleted),
          _buildTimelineStep(
            label: 'orders.completed'.tr(),
            isDone: isCompleted,
            color: isCompleted ? const Color(0xFF2E9B68) : const Color(0xFFA5AAA7),
            icon: isCompleted ? Icons.check_rounded : Icons.circle_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String label,
    required bool isDone,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? color : color.withOpacity(0.12),
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 16,
                color: isDone ? Colors.white : color,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDone ? const Color(0xFF0B4F3A) : const Color(0xFF6B7D75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineConnector({required bool isDone}) {
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isDone ? const Color(0xFF2E9B68) : const Color(0xFFE6F4ED),
    );
  }

  Widget _buildPersonalDetailsCard(BuildContext context, OrderModel order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDF8E9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B4F3A).withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'forms.personal_details'.tr().toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: const Color(0xFF0B4F3A),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE6F4ED), thickness: 1),
          const SizedBox(height: 6),
          _buildInfoRow('forms.full_name', order.customerName),
          _buildInfoRow('forms.mobile', order.customerPhone ?? '-'),
          _buildInfoRow('forms.email', order.customerEmail ?? '-'),
          _buildInfoRow(
            'orders.amount',
            '${order.currency} ${order.amount.toStringAsFixed(2)}',
            isEmphasized: true,
          ),
          if (order.completedAt != null)
            _buildInfoRow(
              'orders.completed_date',
              DateFormat('dd MMM yyyy').format(order.completedAt!),
            ),
          if (order.cancelledAt != null)
            _buildInfoRow(
              'orders.cancelled_date',
              DateFormat('dd MMM yyyy').format(order.cancelledAt!),
            ),
          if (order.cancellationReason != null)
            _buildInfoRow('orders.reason', order.cancellationReason!),
        ],
      ),
    );
  }

  Widget _buildBirthDetailsCard(BuildContext context, OrderModel order) {
    final Map<String, dynamic>? details = order.inputDetails;
    final bool hasDetails = details != null && details.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDF8E9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B4F3A).withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
          title: Text(
            'forms.birth_details'.tr().toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: const Color(0xFF0B4F3A),
              letterSpacing: 1.2,
            ),
          ),
          iconColor: const Color(0xFF0B4F3A),
          collapsedIconColor: const Color(0xFF6B7D75),
          children: [
            const Divider(color: Color(0xFFE6F4ED), thickness: 1),
            const SizedBox(height: 6),
            if (!hasDetails)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: Color(0xFF6B7D75),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'orders.birth_details_not_provided'.tr(),
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6B7D75),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...details.entries.where((e) => e.value is! Map).map((e) {
                return _buildInfoRow(_formatKey(e.key), e.value.toString());
              }),
          ],
        ),
      ),
    );
  }

  String _formatKey(String key) {
    if (key.startsWith('forms.')) {
      return key.tr();
    }
    switch (key.toLowerCase()) {
      case 'dob':
      case 'date_of_birth':
        return 'forms.dob'.tr();
      case 'birth_time':
      case 'time_of_birth':
      case 'time':
        return 'forms.birth_time'.tr();
      case 'birth_place':
      case 'place_of_birth':
      case 'place':
        return 'forms.birth_place'.tr();
      case 'gender':
        return 'forms.gender'.tr();
      case 'full_name':
      case 'name':
        return 'forms.full_name'.tr();
      default:
        final clean = key.replaceAll('_', ' ');
        if (clean.isEmpty) return key;
        return clean[0].toUpperCase() + clean.substring(1);
    }
  }

  Widget _buildInfoRow(String label, String value, {bool isEmphasized = false}) {
    final String translatedLabel =
        (label.startsWith('forms.') || label.startsWith('orders.'))
            ? label.tr()
            : label;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              translatedLabel,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF6B7D75),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.plusJakartaSans(
                color: isEmphasized ? const Color(0xFF0B4F3A) : const Color(0xFF022C22),
                fontSize: isEmphasized ? 16 : 15,
                fontWeight: isEmphasized ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, OrderModel order) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.orderPdf, arguments: order);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E9B68),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: const Color(0xFF2E9B68).withOpacity(0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: const Icon(Icons.visibility_rounded, size: 22),
            label: Text(
              'orders.view_report'.tr().toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () => _downloadPdf(context, order),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0B4F3A),
              side: const BorderSide(color: Color(0xFF2E9B68), width: 1.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: const Icon(Icons.file_download_rounded, size: 22),
            label: Text(
              'orders.download_report'.tr().toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _sanitizeFileName(String title) {
    final clean = title
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    return clean.isEmpty ? 'Report' : clean;
  }

  Future<void> _downloadPdf(BuildContext context, OrderModel order) async {
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('orders.downloading_report'.tr(args: [order.orderNumber])),
          backgroundColor: const Color(0xFF0B4F3A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          duration: const Duration(seconds: 2),
        ),
      );

      Uint8List? bytes;

      if (kIsWeb) {
        if (!context.mounted) return;
        bytes = await context.read<OrderProvider>().getOrderReport(
          order.orderNumber,
        );
      } else {
        // 1. Check local report cache first
        final localReportFile =
            await LocalReportService.instance.getLocalReport(order.orderNumber);
        final bool hasCache = localReportFile != null && await localReportFile.exists();
        debugPrint('[PDF] local cache exists: $hasCache');

        if (localReportFile != null) {
          bytes = await localReportFile.readAsBytes();
        } else {
          // 2. Download from backend if missing from local cache
          if (!context.mounted) return;
          bytes = await context.read<OrderProvider>().getOrderReport(
            order.orderNumber,
          );
          if (bytes != null && bytes.isNotEmpty) {
            await LocalReportService.instance.saveReport(
              order.orderNumber,
              bytes,
            );
            debugPrint('[PDF] cache saved: true');
          } else {
            debugPrint('[PDF] cache saved: false');
          }
        }
      }

      if (bytes == null || bytes.isEmpty) {
        throw Exception('download_failed');
      }

      // 3. Format clean user-friendly filename
      final serviceVisual = ServiceVisualHelper.fromOrder(order);
      final sanitizedTitle = _sanitizeFileName(serviceVisual.localizedTitle);
      final fileName = 'AstroVedham_${sanitizedTitle}_${order.orderNumber}.pdf';

      // 4. Save COPY to public Downloads folder via MediaStore
      final savedPath = await FileUtils.saveToPublicDownloads(
        bytes: bytes,
        fileName: fileName,
      );

      final bool isPublicSaved = savedPath != null && savedPath.isNotEmpty;
      debugPrint('[PDF] public download saved: $isPublicSaved');

      if (!isPublicSaved) {
        throw Exception('save_failed');
      }

      await NotificationService.instance.showDownloadSuccessNotification(order.orderNumber);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('orders.download_success'.tr()),
          backgroundColor: const Color(0xFF2E9B68),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[DOWNLOAD ERROR] $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final errorMsg = e.toString().contains('save_failed')
          ? 'orders.save_error'.tr()
          : 'orders.download_error'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
