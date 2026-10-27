import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/core/utils/phone_utils.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';
import 'package:astrovedham/features/horoscope/presentation/widgets/horoscope_input_widgets.dart';
import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_service.dart';

import 'package:astrovedham/features/horoscope/presentation/widgets/standard_birth_form.dart';

class ConsultationFormScreen extends StatefulWidget {
  final HoroscopeService service;

  const ConsultationFormScreen({super.key, required this.service});

  @override
  State<ConsultationFormScreen> createState() => _ConsultationFormScreenState();
}

class _ConsultationFormScreenState extends State<ConsultationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;
  final int _totalSteps = 2;

  // Form State - Personal & Birth Details
  late final TextEditingController _name = TextEditingController();
  late final TextEditingController _fatherName = TextEditingController();
  String? _gender;
  DateTime? _dob;
  TimeOfDay? _time;
  late final TextEditingController _place = TextEditingController();

  // Form State - Consultation & Contact Details
  String? _selectedTopic;
  DateTime? _preferredDate;
  TimeOfDay? _preferredTime;
  late final TextEditingController _phone = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _notes = TextEditingController();

  final List<String> _topics = [
    'options.interests.marriage',
    'options.interests.career',
    'options.interests.finance',
    'options.interests.education',
    'options.interests.family',
    'options.interests.health',
    'options.interests.business',
    'options.interests.property',
    'services.life_subtitle', // Represents General Life
    'options.interests.other',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _fatherName.dispose();
    _place.dispose();
    _phone.dispose();
    _email.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < _totalSteps) {
        setState(() => _currentStep++);
      } else {
        _navigateToReview();
      }
    }
  }

  void _navigateToReview() {
    final Map<String, dynamic> formData = {
      'person1': {
        'name': _name.text,
        'fatherName': _fatherName.text,
        'gender': _gender,
        'dob': _dob != null ? DateFormat('dd MMM yyyy').format(_dob!) : '',
        'time': _time?.format(context) ?? '',
        'place': _place.text,
      },
      'contact': {
        'phone': _phone.text.trim(),
        'email': _email.text.trim(),
      },
      'consultation': {
        'topic': _selectedTopic,
        'preferredDate': _preferredDate != null
            ? DateFormat('dd MMM yyyy').format(_preferredDate!)
            : '',
        'preferredTime': _preferredTime?.format(context) ?? '',
        'question': _notes.text,
      },
    };

    Navigator.pushNamed(
      context,
      AppRoutes.reviewDetails,
      arguments: {'service': widget.service, 'formData': formData},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      appBar: CustomAppBar(
        title: 'forms.consultation_details'.tr(),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(key: _formKey, child: _buildStepContent()),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'common.step'.tr(
                  args: [_currentStep.toString(), _totalSteps.toString()],
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Text(
                '${(_currentStep / _totalSteps * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _currentStep / _totalSteps,
              minHeight: 8,
              backgroundColor: AppColors.lightBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    if (_currentStep == 1) return _buildStep1();
    return _buildStep2();
  }

  Widget _buildStep1() {
    return StandardBirthForm(
      sectionTitleKey: 'forms.personal_details',
      nameController: _name,
      fatherNameController: _fatherName,
      showFatherName: true,
      gender: _gender,
      onGenderChanged: (v) => setState(() => _gender = v),
      dob: _dob,
      onDobChanged: (d) => setState(() => _dob = d),
      tob: _time,
      onTobChanged: (t) => setState(() => _time = t),
      placeController: _place,
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputSectionHeader(titleKey: 'forms.consultation_details'),
        _buildTopicDropdown(),
        const SizedBox(height: 20),
        _buildDatePicker(
          'forms.preferred_date',
          _preferredDate,
          (d) => setState(() => _preferredDate = d),
          firstDate: DateTime.now(),
        ),
        const SizedBox(height: 20),
        _buildTimePicker(
          'forms.preferred_time',
          _preferredTime,
          (t) => setState(() => _preferredTime = t),
        ),
        const SizedBox(height: 40),
        const InputSectionHeader(titleKey: 'forms.contact_details'),
        _buildTextField(
          _phone,
          'forms.phone',
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          hintKey: 'forms.phone_hint',
          maxLength: 10,
          validator: validatePhone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextField(
          _email,
          'forms.email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          hintKey: 'forms.email_hint',
          validator: (v) {
            if (v == null || v.isEmpty) return 'errors.email_required'.tr();
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(v.trim())) {
              return 'errors.email_invalid'.tr();
            }
            return null;
          },
        ),
        const SizedBox(height: 40),
        const InputSectionHeader(titleKey: 'forms.question'),
        TextFormField(
          controller: _notes,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'forms.question_hint'.tr(),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
          validator: (v) => v == null || v.isEmpty ? 'common.required'.tr() : null,
        ),
      ],
    );
  }

  Widget _buildTopicDropdown() {
    return PremiumInputContainer(
      labelKey: 'forms.consultation_topic',
      child: DropdownButtonFormField<String>(
        initialValue: _selectedTopic,
        items: _topics
            .map((t) => DropdownMenuItem(value: t, child: Text(t.tr())))
            .toList(),
        onChanged: (v) => setState(() => _selectedTopic = v),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        validator: (v) => v == null ? 'common.required'.tr() : null,
        hint: Text('common.select'.tr(), style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String labelKey, {
    IconData? icon,
    TextInputType? keyboardType,
    String? hintKey,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return PremiumInputContainer(
      labelKey: labelKey,
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLength: maxLength,
        buildCounter: maxLength != null ? (context, {required currentLength, required isFocused, maxLength}) => null : null,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintText: hintKey?.tr(),
          prefixIcon: icon != null
              ? Icon(icon, color: AppColors.primaryGreen, size: 20)
              : null,
        ),
        validator: validator ?? (v) => v!.isEmpty ? 'common.required'.tr() : null,
        inputFormatters: inputFormatters,
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? selected,
    Function(DateTime?) onSelected, {
    DateTime? firstDate,
  }) {
    return PremiumInputContainer(
      labelKey: label,
      child: InkWell(
        onTap: () async {
          final now = DateTime.now();
          final effectiveFirst = firstDate ?? DateTime(1900);
          final effectiveLast = DateTime(2100);
          DateTime initial = selected ?? now;
          if (initial.isBefore(effectiveFirst)) initial = effectiveFirst;
          if (initial.isAfter(effectiveLast)) initial = effectiveLast;

          final d = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: effectiveFirst,
            lastDate: effectiveLast,
          );
          if (d != null) onSelected(d);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(
                selected != null
                    ? DateFormat('dd MMM yyyy').format(selected)
                    : 'forms.select_date'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.primaryGreen,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    String label,
    TimeOfDay? selected,
    Function(TimeOfDay?) onSelected,
  ) {
    return PremiumInputContainer(
      labelKey: label,
      child: InkWell(
        onTap: () async {
          final t = await showTimePicker(
            context: context,
            initialTime: selected ?? TimeOfDay.now(),
          );
          if (t != null) onSelected(t);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(
                selected != null
                    ? selected.format(context)
                    : 'forms.select_time'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.primaryGreen,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _next,
        child: Text(
          (_currentStep < _totalSteps ? 'common.next' : 'common.review')
              .tr()
              .toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
      ),
    );
  }
}
