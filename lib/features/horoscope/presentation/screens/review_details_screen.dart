import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/common/custom_app_bar.dart';
import '../../../horoscope_generator/domain/entities/horoscope_service.dart';
import '../../../../core/providers/order_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/profile_completion_helper.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../auth/presentation/widgets/auth_bottom_sheet.dart';

class ReviewDetailsScreen extends StatefulWidget {
  final HoroscopeService service;
  final Map<String, dynamic> formData;

  const ReviewDetailsScreen({
    super.key,
    required this.service,
    required this.formData,
  });

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      appBar: CustomAppBar(
        title: 'common.review_your_details'.tr(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildServiceSummary(),
                      const SizedBox(height: 24),
                      _buildDetailsCard(),
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomAction(),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withAlpha(80),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.service.iconData,
                color: AppColors.primaryGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.name.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                Text(
                  widget.service.currentPrice,
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'forms.personal_details'.tr(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryGreen,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.edit_rounded, size: 14),
                  label: Text('common.edit'.tr()),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.sacredGold,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (widget.formData['person1'] != null)
                  ..._buildDetailRows(Map<String, dynamic>.from(widget.formData['person1'])),
                if (widget.formData['person2'] != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  ..._buildDetailRows(Map<String, dynamic>.from(widget.formData['person2'])),
                ],
                if (widget.formData['consultation'] != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  ..._buildDetailRows(Map<String, dynamic>.from(widget.formData['consultation'])),
                ],
                if (widget.formData['contact'] != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  ..._buildDetailRows(Map<String, dynamic>.from(widget.formData['contact'])),
                ],
                if (widget.formData['additional'] != null &&
                    (widget.formData['additional'] as Map).isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  ..._buildDetailRows(Map<String, dynamic>.from(widget.formData['additional'])),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDetailRows(Map<String, dynamic> data) {
    return data.entries.map((e) => _buildDetailItem(e.key, e.value)).toList();
  }

  Widget _buildDetailItem(String label, dynamic value) {
    String labelKey = label;
    if (label == 'name') labelKey = 'forms.full_name';
    if (label == 'fatherName') labelKey = 'forms.father_name';
    if (label == 'gender') labelKey = 'forms.gender';
    if (label == 'dob') labelKey = 'forms.dob';
    if (label == 'time') labelKey = 'forms.birth_time';
    if (label == 'place') labelKey = 'forms.birth_place';
    if (label == 'phone') labelKey = 'forms.phone';
    if (label == 'email') labelKey = 'forms.email';
    if (label == 'topic') labelKey = 'forms.consultation_topic';
    if (label == 'preferredDate') labelKey = 'forms.preferred_date';
    if (label == 'preferredTime') labelKey = 'forms.preferred_time';
    if (label == 'question') labelKey = 'forms.question';

    String displayValue = '-';
    if (value is List) {
      displayValue = value.map((i) => i.toString().tr()).join(', ');
    } else if (value != null) {
      displayValue = value.toString();
      if (label == 'topic') displayValue = displayValue.tr();
    }

    if (displayValue.isEmpty) displayValue = '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              labelKey.tr(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              displayValue,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _confirmOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(
                'common.continue'.tr().toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
      ),
    );
  }

  String _formatDateToApi(dynamic dob) {
    if (dob == null) return '';
    if (dob is DateTime) return DateFormat('yyyy-MM-dd').format(dob);
    String s = dob.toString().trim();
    if (s.isEmpty) return '';
    try {
      DateTime? dt = DateTime.tryParse(s);
      if (dt != null) return DateFormat('yyyy-MM-dd').format(dt);
      dt = DateFormat('dd MMM yyyy').parse(s);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {
      return s;
    }
  }

  String _formatTimeTo24Hr(dynamic tob) {
    if (tob == null) return '00:00';
    String s = tob.toString().trim();
    if (s.isEmpty) return '00:00';
    try {
      if (RegExp(r'^\d{1,2}:\d{2}$').hasMatch(s)) {
        final parts = s.split(':');
        final h = parts[0].padLeft(2, '0');
        final m = parts[1].padLeft(2, '0');
        return '$h:$m';
      }
      if (RegExp(r'^\d{1,2}:\d{2}\s*(AM|PM)$', caseSensitive: false).hasMatch(s)) {
        final dt = DateFormat('h:mm a').parse(s);
        return DateFormat('HH:mm').format(dt);
      }
    } catch (_) {}
    return s;
  }

  String _formatGenderToApi(String? gender) {
    if (gender == null) return 'M';
    final g = gender.trim().toUpperCase();
    if (g.startsWith('F') || g == 'FEMALE') return 'F';
    return 'M';
  }

  Future<void> _confirmOrder() async {
    if (_isProcessing) return;

    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      final authSuccess = await AuthBottomSheet.show(context);
      if (authSuccess != true || !mounted) {
        return;
      }
    }

    final profileCompleted = await ProfileCompletionHelper.ensurePhoneAndGender(context);
    if (!profileCompleted || !mounted) {
      return;
    }

    try {
      await NotificationService.instance.requestNotificationPermission();
      await NotificationService.instance.registerFcmToken();
    } catch (_) {}

    final apiPlanType = widget.service.apiPlanType;
    if (apiPlanType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Astrologer Consultation booking will be available shortly.'),
          backgroundColor: AppColors.sacredGold,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final orderProvider = context.read<OrderProvider>();
      await orderProvider.fetchPlans();

      String? planId = orderProvider.getPlanIdForType(apiPlanType);
      if (planId == null || planId.isEmpty) {
        planId = apiPlanType; // fallback if plan ID is matching plan type
      }

      final returnUrl = 'https://astrovedham.com/payment_status?order_id={order_id}';
      final buyNowResult = await orderProvider.buyNow(
        planId: planId,
        returnUrl: returnUrl,
      );

      final String paymentLink = buyNowResult['payment_link']?.toString() ?? '';
      final String orderId = buyNowResult['order_id']?.toString() ?? '';

      if (paymentLink.isEmpty) {
        throw Exception('Failed to obtain payment gateway link.');
      }

      if (!mounted) return;

      final webResult = await Navigator.pushNamed(
        context,
        AppRoutes.webview,
        arguments: paymentLink,
      );

      if (!mounted) return;

      final bool isPaymentReturned = (webResult is Map && webResult['success'] == true) ||
          webResult == true;

      final String finalOrderId = (webResult is Map ? webResult['order_id'] : null) ?? orderId;

      if (finalOrderId.isNotEmpty && isPaymentReturned) {
        try {
          await orderProvider.verifyPayment(finalOrderId);
        } catch (e) {
          if (mounted) {
            debugPrint('[PAYMENT VERIFY WARNING] $e');
          }
        }
      }

      final person1 = Map<String, dynamic>.from(widget.formData['person1'] ?? {});
      final person2 = Map<String, dynamic>.from(widget.formData['person2'] ?? {});
      final contact = Map<String, dynamic>.from(widget.formData['contact'] ?? {});

      final userMobile = LocalStorageService.instance.getMobile() ?? '';
      final userEmail = LocalStorageService.instance.getEmail() ?? '';

      final Map<String, dynamic> generatePayload = {};

      if (apiPlanType == 'Marriage' || apiPlanType == 'ProMarriage') {
        generatePayload['horoscope_type'] = apiPlanType;
        generatePayload['name'] = person1['name'] ?? '';
        generatePayload['dob'] = _formatDateToApi(person1['dob']);
        generatePayload['tob'] = _formatTimeTo24Hr(person1['time']);
        generatePayload['place'] = person1['place'] ?? '';

        generatePayload['fname'] = person2['name'] ?? '';
        generatePayload['fdob'] = _formatDateToApi(person2['dob']);
        generatePayload['ftob'] = _formatTimeTo24Hr(person2['time']);
        generatePayload['fplace'] = person2['place'] ?? '';

        generatePayload['cname'] = person1['name'] ?? '';
        generatePayload['mobile'] = (contact['phone']?.toString().isNotEmpty == true)
            ? contact['phone']
            : userMobile;
        generatePayload['emailid'] = (contact['email']?.toString().isNotEmpty == true)
            ? contact['email']
            : userEmail;
        generatePayload['is_whatsapp'] = true;
      } else {
        generatePayload['horoscope_type'] = apiPlanType;
        generatePayload['name'] = person1['name'] ?? '';
        generatePayload['gender'] = _formatGenderToApi(person1['gender']);
        generatePayload['dob'] = _formatDateToApi(person1['dob']);
        generatePayload['tob'] = _formatTimeTo24Hr(person1['time']);
        generatePayload['place'] = person1['place'] ?? '';

        generatePayload['mobile'] = (contact['phone']?.toString().isNotEmpty == true)
            ? contact['phone']
            : userMobile;
        generatePayload['emailid'] = (contact['email']?.toString().isNotEmpty == true)
            ? contact['email']
            : userEmail;
        generatePayload['is_whatsapp'] = true;
      }

      await orderProvider.generateHoroscope(generatePayload);

      if (!mounted) return;
      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('orders.success_msg'.tr()),
          backgroundColor: AppColors.successGreen,
        ),
      );

      await context.read<OrderProvider>().refreshOrders();
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.root,
        (route) => false,
        arguments: 1, // Index for My Orders tab
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('orders.error_msg'.tr(args: [e.toString().replaceAll('Exception: ', '')])),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
