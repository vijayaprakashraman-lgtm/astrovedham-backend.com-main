import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/utils/profile_completion_helper.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/common/custom_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  bool _otpSent = false;
  String _targetMobile = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (!_phoneFormKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    if (authProvider.isLoading) return;

    final rawMobile = _phoneController.text.trim();
    final normalized = normalizePhone(rawMobile);

    final success = await authProvider.sendOtp(normalized);

    if (!mounted) return;

    if (success) {
      setState(() {
        _otpSent = true;
        _targetMobile = normalized;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.otp_sent_to'.tr(args: [normalized])),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } else {
      final serverError = authProvider.error;
      final displayMsg = (serverError != null && serverError.isNotEmpty)
          ? serverError
          : 'auth.authentication_failed'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(displayMsg),
          backgroundColor: AppColors.alertRed,
        ),
      );
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (!_otpFormKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    if (authProvider.isLoading) return;

    final otp = _otpController.text.trim();

    final success = await authProvider.verifyOtp(
      mobile: _targetMobile,
      otp: otp,
    );

    if (!mounted) return;

    if (success) {
      final completed = await ProfileCompletionHelper.ensurePhoneAndGender(context);
      if (!completed || !mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.login_success'.tr()),
          backgroundColor: AppColors.successGreen,
        ),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.root,
          (route) => false,
        );
      }
    } else {
      final serverError = authProvider.error;
      final displayMsg = (serverError != null && serverError.isNotEmpty)
          ? serverError
          : 'auth.invalid_otp'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(displayMsg),
          backgroundColor: AppColors.alertRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      appBar: CustomAppBar(
        title: '',
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryText),
          onPressed: () {
            if (_otpSent) {
              setState(() => _otpSent = false);
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.root);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/app_icon.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                _otpSent ? 'auth.enter_otp'.tr() : 'auth.login'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                _otpSent
                    ? 'auth.otp_sent_to'.tr(args: [_targetMobile])
                    : 'auth.login_subtitle'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 36),

              if (!_otpSent) ...[
                Form(
                  key: _phoneFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'auth.mobile_hint'.tr(),
                          prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.primaryGreen, size: 22),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.lightBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.lightBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                          ),
                        ),
                        validator: validatePhone,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: 'auth.send_otp'.tr().toUpperCase(),
                        isLoading: authProvider.isLoading,
                        onTap: authProvider.isLoading ? null : _handleSendOtp,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Form(
                  key: _otpFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          letterSpacing: 8,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                        decoration: InputDecoration(
                          hintText: '------',
                          hintStyle: const TextStyle(letterSpacing: 8, color: AppColors.hintText),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.lightBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.lightBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length != 6) {
                            return 'auth.otp_required'.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: 'auth.verify_otp'.tr().toUpperCase(),
                        isLoading: authProvider.isLoading,
                        onTap: authProvider.isLoading ? null : _handleVerifyOtp,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () => setState(() => _otpSent = false),
                            child: Text(
                              'auth.change_mobile'.tr(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: authProvider.isLoading ? null : _handleSendOtp,
                            child: Text(
                              'auth.resend_otp'.tr(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),
              Text(
                'auth.secure_signin'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
