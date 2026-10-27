import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'horoscope_input_widgets.dart';

class StandardBirthForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController? fatherNameController;
  final String? gender;
  final Function(String) onGenderChanged;
  final DateTime? dob;
  final Function(DateTime) onDobChanged;
  final TimeOfDay? tob;
  final Function(TimeOfDay) onTobChanged;
  final TextEditingController placeController;
  final String? sectionTitleKey;
  final bool showFatherName;
  final bool showOnlyNameAndDob;

  const StandardBirthForm({
    super.key,
    required this.nameController,
    this.fatherNameController,
    required this.gender,
    required this.onGenderChanged,
    required this.dob,
    required this.onDobChanged,
    required this.tob,
    required this.onTobChanged,
    required this.placeController,
    this.sectionTitleKey,
    this.showFatherName = false,
    this.showOnlyNameAndDob = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitleKey != null) ...[
          InputSectionHeader(titleKey: sectionTitleKey!),
        ],

        // Personal Details
        PremiumInputContainer(
          labelKey: 'forms.full_name',
          child: TextFormField(
            controller: nameController,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hintText: 'forms.full_name_hint'.tr(),
            ),
            validator: (v) => v!.isEmpty ? 'common.required'.tr() : null,
          ),
        ),

        if (showFatherName && fatherNameController != null) ...[
          const SizedBox(height: 24),
          PremiumInputContainer(
            labelKey: 'forms.father_name',
            child: TextFormField(
              controller: fatherNameController,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintText: 'forms.father_name_hint'.tr(),
              ),
              validator: null,
            ),
          ),
        ],

        const SizedBox(height: 24),
        _buildGenderSelector(context),

        const SizedBox(height: 40),
        const InputSectionHeader(titleKey: 'forms.birth_details'),

        // Birth Details
        _buildDatePicker(context),

        if (!showOnlyNameAndDob) ...[
          const SizedBox(height: 24),
          _buildTimePicker(context),
          const SizedBox(height: 24),
          _buildPlaceField(context),
        ],
      ],
    );
  }

  Widget _buildGenderSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'forms.gender'.tr(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        Row(
          children: [
            _buildGenderOption(context, 'common.male', 'Male'),
            const SizedBox(width: 16),
            _buildGenderOption(context, 'common.female', 'Female'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(BuildContext context, String labelKey, String val) {
    final isSelected = gender == val;
    return Expanded(
      child: InkWell(
        onTap: () => onGenderChanged(val),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.sheetBackground : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryGreen.withAlpha((0.05 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              labelKey.tr(),
              style: TextStyle(
                color: isSelected ? AppColors.primaryGreen : AppColors.primaryText,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return PremiumInputContainer(
      labelKey: 'forms.dob',
      child: InkWell(
        onTap: () async {
          final now = DateTime.now();
          final first = DateTime(1900);
          final last = now;
          DateTime initial = dob ?? now;
          if (initial.isBefore(first)) initial = first;
          if (initial.isAfter(last)) initial = last;

          final d = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: first,
            lastDate: last,
          );
          if (d != null) onDobChanged(d);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  dob != null ? DateFormat('dd MMM yyyy').format(dob!) : 'forms.select_date'.tr(),
                  style: TextStyle(
                    color: dob == null ? AppColors.hintText : AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.calendar_today_rounded, color: AppColors.primaryGreen, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return PremiumInputContainer(
      labelKey: 'forms.birth_time',
      child: InkWell(
        onTap: () async {
          final t = await showTimePicker(
            context: context,
            initialTime: tob ?? TimeOfDay.now(),
          );
          if (t != null) onTobChanged(t);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  tob != null ? tob!.format(context) : 'forms.select_time'.tr(),
                  style: TextStyle(
                    color: tob == null ? AppColors.hintText : AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.access_time_rounded, color: AppColors.primaryGreen, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceField(BuildContext context) {
    return PremiumInputContainer(
      labelKey: 'forms.birth_place',
      child: TextFormField(
        controller: placeController,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: const Icon(Icons.location_on_rounded, color: AppColors.primaryGreen, size: 20),
          hintText: 'forms.birth_place_hint'.tr(),
        ),
        validator: (v) => v!.isEmpty ? 'common.required'.tr() : null,
      ),
    );
  }
}
