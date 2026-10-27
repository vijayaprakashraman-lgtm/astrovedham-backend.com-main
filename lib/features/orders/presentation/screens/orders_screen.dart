import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import 'package:astrovedham/models/order.dart';
import 'package:astrovedham/core/providers/order_provider.dart';
import 'package:astrovedham/core/providers/auth_provider.dart';
import 'package:astrovedham/core/services/local_report_service.dart';

import '../widgets/order_card.dart';

import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/core/utils/file_utils.dart';
import 'package:astrovedham/core/utils/service_visual_helper.dart';
import 'package:astrovedham/core/notifications/notification_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  Future<void> _refreshOrders() async {
    await context.read<OrderProvider>().refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final allOrders = orderProvider.orders;
    final isLoading = orderProvider.isLoading;
    final isMoreLoading = orderProvider.isMoreLoading;
    final hasNextPage = orderProvider.hasNextPage;

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.sheetBackground,
        appBar: CustomAppBar(
          title: 'orders.title'.tr(),
          centerTitle: true,
          showBottomDivider: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 64,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'orders.login_required_title'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'orders.login_required_desc'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login).then((_) {
                      if (context.mounted) {
                        context.read<OrderProvider>().loadOrders();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'orders.login_now'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.sheetBackground,
        appBar: CustomAppBar(
          title: 'orders.title'.tr(),
          centerTitle: true,
          showBottomDivider: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.05 * 255).toInt()),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColors.primaryPurple,
                  unselectedLabelColor: AppColors.secondaryText,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  tabs: [
                    Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('orders.pending'.tr()))),
                    Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('orders.success'.tr()))),
                    Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('orders.cancelled'.tr()))),
                  ],
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPurple,
                      ),
                    )
                  : TabBarView(
                      children: [
                        _buildOrderList(
                          context,
                          allOrders,
                          OrderStatus.PENDING,
                          hasNextPage,
                          isMoreLoading,
                        ),
                        _buildOrderList(
                          context,
                          allOrders,
                          OrderStatus.SUCCESS,
                          hasNextPage,
                          isMoreLoading,
                        ),
                        _buildOrderList(
                          context,
                          allOrders,
                          OrderStatus.CANCELLED,
                          hasNextPage,
                          isMoreLoading,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    List<OrderModel> allOrders,
    OrderStatus status,
    bool hasNextPage,
    bool isMoreLoading,
  ) {
    final filteredOrders = allOrders.where((o) => o.status == status).toList();

    // Floating navigation total height (80.0) + bottom margin (6.0) = 86.0
    // Plus safe area bottom inset and 20.0 spacing
    final bottomPadding = 86.0 + MediaQuery.of(context).padding.bottom + 20.0;

    if (filteredOrders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshOrders,
        color: AppColors.primaryPurple,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomPadding),
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: AppColors.hintText.withAlpha(100),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'orders.no_orders'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      color: AppColors.primaryPurple,
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: bottomPadding,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredOrders.length + (hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == filteredOrders.length) {
            return _buildLoadMoreButton(context, isMoreLoading);
          }

          final order = filteredOrders[index];
          return OrderCard(
            order: order,
            onViewPdf: () {
              Navigator.pushNamed(
                context,
                AppRoutes.orderPdf,
                arguments: order,
              );
            },
            onDownloadPdf: () => _downloadPdf(context, order),
            onViewDetails: () {
              Navigator.pushNamed(
                context,
                AppRoutes.orderDetail,
                arguments: order.orderNumber,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context, bool isMoreLoading) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: isMoreLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: AppColors.primaryPurple,
                ),
              ),
            )
          : TextButton(
              onPressed: () => context.read<OrderProvider>().loadMoreOrders(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryPurple,
              ),
              child: Text('common.load_more'.tr()),
            ),
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
          backgroundColor: AppColors.primaryPurple,
          duration: const Duration(seconds: 2),
        ),
      );

      Uint8List? bytes;

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
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
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
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
