import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_service.dart';
import 'package:astrovedham/features/horoscope/presentation/widgets/standard_birth_form.dart';
import 'package:astrovedham/widgets/buttons/primary_button.dart';
import 'package:astrovedham/features/horoscope/presentation/widgets/horoscope_input_widgets.dart';
import 'package:astrovedham/core/routes/app_routes.dart';
import 'package:astrovedham/core/utils/phone_utils.dart';

class UniversalHoroscopeForm extends StatefulWidget {
  final HoroscopeService service;
  final Function(dynamic) onComplete;

  const UniversalHoroscopeForm({
    super.key,
    required this.service,
    required this.onComplete,
  });

  @override
  State<UniversalHoroscopeForm> createState() => _UniversalHoroscopeFormState();
}

class _UniversalHoroscopeFormState extends State<UniversalHoroscopeForm> {
  final _formKey = GlobalKey<FormState>();

  // Person 1 Controllers
  final _name1 = TextEditingController();
  String? _gender1;
  DateTime? _dob1;
  TimeOfDay? _time1;
  final _place1 = TextEditingController();

  // Contact Controllers
  final _phone = TextEditingController();
  final _email = TextEditingController();

  // Person 2 Controllers (Matching)
  final _name2 = TextEditingController();
  String? _gender2;
  DateTime? _dob2;
  TimeOfDay? _time2;
  final _place2 = TextEditingController();

  // Specialized State

  @override
  void dispose() {
    _name1.dispose();
    _place1.dispose();
    _phone.dispose();
    _email.dispose();
    _name2.dispose();
    _place2.dispose();
    super.dispose();
  }

  bool get _isMatching =>
      widget.service.type == HoroscopeServiceType.marriageMatchingLite ||
      widget.service.type == HoroscopeServiceType.marriageMatchingPro;
  bool get _isNumerology =>
      widget.service.type == HoroscopeServiceType.numerology;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        'person1': {
          'name': _name1.text,
          'gender': _gender1,
          'dob': _dob1 != null ? DateFormat('dd MMM yyyy').format(_dob1!) : '',
          'time': _time1?.format(context) ?? '',
          'place': _place1.text,
        },
        'contact': {
          'phone': _phone.text.trim(),
          'email': _email.text.trim(),
        },
      };

      if (_isMatching) {
        data['person2'] = {
          'name': _name2.text,
          'gender': _gender2,
          'dob': _dob2 != null ? DateFormat('dd MMM yyyy').format(_dob2!) : '',
          'time': _time2?.format(context) ?? '',
          'place': _place2.text,
        };
      }

      data['additional'] = {};

      Navigator.pushNamed(
        context,
        AppRoutes.reviewDetails,
        arguments: {'service': widget.service, 'formData': data},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StandardBirthForm(
            sectionTitleKey: _isMatching ? 'forms.person_1' : null,
            nameController: _name1,
            gender: _gender1,
            onGenderChanged: (v) => setState(() => _gender1 = v),
            dob: _dob1,
            onDobChanged: (d) => setState(() => _dob1 = d),
            tob: _time1,
            onTobChanged: (t) => setState(() => _time1 = t),
            placeController: _place1,
            showOnlyNameAndDob: _isNumerology,
          ),

          if (_isMatching) ...[
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 32),
            StandardBirthForm(
              sectionTitleKey: 'forms.person_2',
              nameController: _name2,
              gender: _gender2,
              onGenderChanged: (v) => setState(() => _gender2 = v),
              dob: _dob2,
              onDobChanged: (d) => setState(() => _dob2 = d),
              tob: _time2,
              onTobChanged: (t) => setState(() => _time2 = t),
              placeController: _place2,
            ),
          ],

          _buildDynamicSections(),
          const SizedBox(height: 40),
          _buildContactSection(),

          const SizedBox(height: 40),
          PrimaryButton(text: 'common.review'.tr(), onTap: _submit),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

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

  Widget _buildDynamicSections() {
    return const SizedBox.shrink();
  }
}
