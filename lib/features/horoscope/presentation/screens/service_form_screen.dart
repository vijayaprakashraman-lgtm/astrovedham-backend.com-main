import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../widgets/common/custom_app_bar.dart';
import '../../../horoscope_generator/domain/entities/horoscope_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/routes/app_routes.dart';
import '../widgets/horoscope_input_widgets.dart';

import '../widgets/standard_birth_form.dart';

class ServiceFormScreen extends StatefulWidget {
  final HoroscopeService service;

  const ServiceFormScreen({super.key, required this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;

  // Form State - Person 1
  late final TextEditingController _name1 = TextEditingController();
  late final TextEditingController _fatherName1 = TextEditingController();
  String? _gender1;
  DateTime? _dob1;
  TimeOfDay? _time1;
  late final TextEditingController _place1 = TextEditingController();

  // Form State - Contact
  late final TextEditingController _phone = TextEditingController();
  late final TextEditingController _email = TextEditingController();

  // Form State - Person 2 (Marriage Matching)
  late final TextEditingController _name2 = TextEditingController();
  String? _gender2;
  DateTime? _dob2;
  TimeOfDay? _time2;
  late final TextEditingController _place2 = TextEditingController();

  // Common Additional
  late final TextEditingController _question = TextEditingController();

  // Specialized Fields
  bool _isDeclared = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _name1.dispose();
    _fatherName1.dispose();
    _place1.dispose();
    _name2.dispose();
    _place2.dispose();
    _question.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  bool get _isTwoStep => false;

  int get _totalSteps => _isTwoStep ? 2 : 1;

  void _next() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < _totalSteps) {
        setState(() => _currentStep++);
      } else {
        _navigateToReview();
      }
    }
  }

  void _navigateToReview() async {
    final profile = LocalStorageService.instance;
    final existingName = profile.getName();
    final formName = _name1.text.trim();

    if (formName.isNotEmpty &&
        (existingName == null || existingName.trim().isEmpty)) {
      await profile.setName(formName);
    }

    if (!mounted) return;

    final Map<String, dynamic> formData = {
      'person1': {
        'name': _name1.text,
        'fatherName': _fatherName1.text,
        'gender': _gender1,
        'dob': _dob1 != null ? DateFormat('dd MMM yyyy').format(_dob1!) : '',
        'time': _time1?.format(context) ?? '',
        'place': _place1.text,
      },
      'contact': {
        'phone': _phone.text.trim(),
        'email': _email.text.trim(),
      },
      'additional': _collectAdditionalData(),
    };

    if (widget.service.type == HoroscopeServiceType.marriageMatchingLite ||
        widget.service.type == HoroscopeServiceType.marriageMatchingPro) {
      formData['person2'] = {
        'name': _name2.text,
        'gender': _gender2,
        'dob': _dob2 != null ? DateFormat('dd MMM yyyy').format(_dob2!) : '',
        'time': _time2?.format(context) ?? '',
        'place': _place2.text,
      };
    }

    Navigator.pushNamed(
      context,
      AppRoutes.reviewDetails,
      arguments: {'service': widget.service, 'formData': formData},
    );
  }

  Map<String, dynamic> _collectAdditionalData() {
    final map = <String, dynamic>{};
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      appBar: CustomAppBar(
        title: widget.service.name.tr(),
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
          if (_totalSteps > 1) _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(key: _formKey, child: _buildCurrentStepContent()),
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
      color: AppColors.sheetBackground,
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

  Widget _buildCurrentStepContent() {
    final type = widget.service.type;

    if (type == HoroscopeServiceType.marriageMatchingLite ||
        type == HoroscopeServiceType.marriageMatchingPro) {
      return _buildMatchingStep1();
    }
    return _buildCommonStep1();
  }

  // --- Step Content Builders ---

  Widget _buildCommonStep1() {
    final bool isLife = widget.service.type == HoroscopeServiceType.life ||
        widget.service.type == HoroscopeServiceType.superLife;
    final bool isNumerology =
        widget.service.type == HoroscopeServiceType.numerology;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StandardBirthForm(
          sectionTitleKey: 'forms.personal_details',
          nameController: _name1,
          fatherNameController: _fatherName1,
          showFatherName: isLife,
          gender: _gender1,
          onGenderChanged: (v) => setState(() => _gender1 = v),
          dob: _dob1,
          onDobChanged: (d) => setState(() => _dob1 = d),
          tob: _time1,
          onTobChanged: (t) => setState(() => _time1 = t),
          placeController: _place1,
          showOnlyNameAndDob: isNumerology,
        ),
        const SizedBox(height: 40),
        _buildContactSection(),
        if (!_isTwoStep) ...[
          const SizedBox(height: 40),
          _buildServiceSpecificFields(),
        ],
      ],
    );
  }

  Widget _buildMatchingStep1() {
    return Column(
      children: [
        StandardBirthForm(
          sectionTitleKey: 'forms.person_1_details',
          nameController: _name1,
          gender: _gender1,
          onGenderChanged: (v) => setState(() => _gender1 = v),
          dob: _dob1,
          onDobChanged: (d) => setState(() => _dob1 = d),
          tob: _time1,
          onTobChanged: (t) => setState(() => _time1 = t),
          placeController: _place1,
        ),
        const SizedBox(height: 40),
        StandardBirthForm(
          sectionTitleKey: 'forms.person_2_details',
          nameController: _name2,
          gender: _gender2,
          onGenderChanged: (v) => setState(() => _gender2 = v),
          dob: _dob2,
          onDobChanged: (d) => setState(() => _dob2 = d),
          tob: _time2,
          onTobChanged: (t) => setState(() => _time2 = t),
          placeController: _place2,
        ),
        const SizedBox(height: 40),
        _buildContactSection(),
      ],
    );
  }

  Widget _buildServiceSpecificFields() {
    return const SizedBox.shrink();
  }

  // --- Helper Field Builders ---

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputSectionHeader(titleKey: 'forms.contact_details'),
        _buildContactTextField(
          _phone,
          'forms.phone',
          'forms.phone_hint',
          keyboardType: TextInputType.phone,
          maxLength: 10,
          validator: validatePhone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        const SizedBox(height: 24),
        _buildContactTextField(
          _email,
          'forms.email',
          'forms.email_hint',
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) return 'errors.email_required'.tr();
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(v.trim())) {
              return 'errors.email_invalid'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContactTextField(
    TextEditingController ctrl,
    String labelKey,
    String hintKey, {
    TextInputType? keyboardType,
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
          hintText: hintKey.tr(),
        ),
        validator: validator,
        inputFormatters: inputFormatters,
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
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _isDeclared = !_isDeclared),
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _isDeclared,
                    onChanged: (v) => setState(() => _isDeclared = v ?? false),
                    activeColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'forms.declaration'.tr(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _next,
            child: Text(
              (_currentStep < _totalSteps ? 'common.next' : 'common.review')
                  .tr()
                  .toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
