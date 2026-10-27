import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/core/services/local_storage_service.dart';
import 'package:astrovedham/core/services/auth_service.dart';
import 'package:astrovedham/core/utils/phone_utils.dart';
import 'package:astrovedham/widgets/buttons/primary_button.dart';

class ProfileCompletionHelper {
  static Future<bool> ensurePhoneAndGender(BuildContext context) async {
    final storage = LocalStorageService.instance;

    // 1. Phone
    String? phone = storage.getMobile();
    if (phone == null || phone.trim().isEmpty) {
      final enteredPhone = await _showPhoneCollectionDialog(context);
      if (enteredPhone == null || enteredPhone.trim().isEmpty) {
        return false;
      }
    }

    // 2. Gender
    String? gender = storage.getGender();
    if (gender == null || gender.trim().isEmpty) {
      final selectedGender = await _showGenderCollectionDialog(context);
      if (selectedGender == null || selectedGender.trim().isEmpty) {
        return false;
      }
    }

    return true;
  }

  static Future<String?> _showPhoneCollectionDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    bool isSaving = false;
    String? resultPhone;

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setBottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'auth.complete_profile'.tr(),
                          style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryText,
                              ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'auth.phone_prompt_desc'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'auth.mobile_number'.tr(),
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller,
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
                          fillColor: AppColors.sheetBackground,
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
                          return validatePhone(value);
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'auth.phone_helper'.tr(),
                        style: const TextStyle(
                          color: AppColors.hintText,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: 'common.continue'.tr().toUpperCase(),
                        isLoading: isSaving,
                        onTap: isSaving
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                setBottomSheetState(() => isSaving = true);
                                final rawMobile = controller.text.trim();
                                final normalized = normalizePhone(rawMobile);
                                try {
                                  await AuthService.instance.updatePhone(normalized);
                                  resultPhone = normalized;
                                  if (ctx.mounted) {
                                    Navigator.pop(ctx);
                                  }
                                } catch (err) {
                                  if (ctx.mounted) {
                                    setBottomSheetState(() => isSaving = false);
                                    String errMessage = err.toString().replaceAll('Exception: ', '').trim();
                                    if (errMessage.contains('already associated') || errMessage.contains('already exists')) {
                                      errMessage = 'This mobile number is already associated with another account.';
                                    }
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(
                                        content: Text(errMessage),
                                        backgroundColor: AppColors.alertRed,
                                      ),
                                    );
                                  }
                                }
                              },
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            'common.cancel'.tr(),
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    return resultPhone;
  }

  static Future<String?> _showGenderCollectionDialog(BuildContext context) async {
    String? selectedGender;
    bool isSaving = false;
    String? resultGender;

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setBottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'register.select_gender'.tr(),
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please select your gender to complete your profile.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderCard(
                            'Male',
                            'common.male'.tr(),
                            Icons.male_rounded,
                            selectedGender,
                            (val) => setBottomSheetState(() => selectedGender = val),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildGenderCard(
                            'Female',
                            'common.female'.tr(),
                            Icons.female_rounded,
                            selectedGender,
                            (val) => setBottomSheetState(() => selectedGender = val),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildGenderCard(
                            'Other',
                            'profile.other'.tr(),
                            Icons.wc_rounded,
                            selectedGender,
                            (val) => setBottomSheetState(() => selectedGender = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      text: 'common.continue'.tr().toUpperCase(),
                      isLoading: isSaving,
                      onTap: selectedGender == null
                          ? null
                          : () async {
                              await LocalStorageService.instance.setGender(selectedGender!);
                              resultGender = selectedGender;
                              if (ctx.mounted) {
                                Navigator.pop(ctx);
                              }
                            },
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'common.cancel'.tr(),
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    return resultGender;
  }

  static Widget _buildGenderCard(
    String value,
    String label,
    IconData icon,
    String? currentSelected,
    ValueChanged<String> onSelect,
  ) {
    final isSelected = currentSelected == value;
    return InkWell(
      onTap: () => onSelect(value),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sheetBackground : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withAlpha(25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGreen : AppColors.secondaryText,
              size: 26,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? AppColors.primaryGreen : AppColors.primaryText,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
