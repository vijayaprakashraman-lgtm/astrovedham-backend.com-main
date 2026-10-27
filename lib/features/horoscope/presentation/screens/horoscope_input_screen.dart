import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../widgets/common/custom_app_bar.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/inputs/custom_text_field.dart';
import '../../data/models/horoscope_request.dart';
import '../widgets/horoscope_loading.dart';
import '../../data/services/horoscope_service.dart';
import '../../data/repositories/horoscope_repository_impl.dart';

class HoroscopeInputScreen extends StatefulWidget {
  const HoroscopeInputScreen({super.key});

  @override
  State<HoroscopeInputScreen> createState() => _HoroscopeInputScreenState();
}

class _HoroscopeInputScreenState extends State<HoroscopeInputScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _timeController;
  late TextEditingController _placeController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dobController = TextEditingController();
    _timeController = TextEditingController();
    _placeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final first = DateTime(1900);
    final last = now;

    DateTime? selectedDate;
    if (_dobController.text.isNotEmpty) {
      try {
        selectedDate = DateFormat('dd MMM yyyy').parse(_dobController.text);
      } catch (_) {}
    }

    DateTime initial = selectedDate ?? now;
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final String selectedSign =
          ModalRoute.of(context)!.settings.arguments as String;

      final request = HoroscopeRequest(
        zodiacSign: selectedSign,
        fullName: _nameController.text.trim(),
        dateOfBirth: _dobController.text.trim(),
        birthTime: _timeController.text.trim(),
        birthPlace: _placeController.text.trim(),
      );

      final repository = HoroscopeRepositoryImpl(HoroscopeService());

      try {
        final response = await repository.getDailyHoroscope(request);

        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.dailyHoroscopeResult,
          arguments: response,
        );
      } catch (e) {
        setState(() => _isLoading = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('horoscope.error.something_went_wrong'.tr()),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: HoroscopeLoading());

    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      appBar: CustomAppBar(
        title: 'horoscope.details_title'.tr(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'horoscope.details_title'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryText,
                              letterSpacing: -0.8,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'horoscope.details_subtitle'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(
                              color: AppColors.secondaryText,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        label: 'forms.full_name'.tr(),
                        hint: 'forms.full_name_hint'.tr(),
                        controller: _nameController,
                        validator: (v) => v == null || v.isEmpty
                            ? 'horoscope.validation.enter_name'.tr()
                            : null,
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            label: 'forms.dob'.tr(),
                            hint: 'forms.select_date'.tr(),
                            controller: _dobController,
                            validator: (v) => v == null || v.isEmpty
                                ? 'horoscope.validation.select_dob'.tr()
                                : null,
                            prefixIcon: Icons.calendar_today_rounded,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _selectTime,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            label: 'forms.birth_time'.tr(),
                            hint: 'forms.select_time'.tr(),
                            controller: _timeController,
                            validator: (v) => v == null || v.isEmpty
                                ? 'horoscope.validation.select_time'.tr()
                                : null,
                            prefixIcon: Icons.access_time_rounded,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: 'forms.birth_place'.tr(),
                        hint: 'forms.birth_place_hint'.tr(),
                        controller: _placeController,
                        validator: (v) => v == null || v.isEmpty
                            ? 'horoscope.validation.enter_place'.tr()
                            : null,
                        prefixIcon: Icons.location_on_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomAction(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: PrimaryButton(
        text: 'common.continue'.tr().toUpperCase(),
        onTap: _handleContinue,
      ),
    );
  }
}
