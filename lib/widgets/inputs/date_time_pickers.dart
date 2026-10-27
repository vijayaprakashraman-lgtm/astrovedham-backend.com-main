import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:astrovedham/core/theme/app_colors.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onSelected;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final now = DateTime.now();
            final first = DateTime(1900);
            final last = now;

            DateTime initial = selectedDate ?? now;
            if (initial.isBefore(first)) initial = first;
            if (initial.isAfter(last)) initial = last;

            final date = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: first,
              lastDate: last,
            );
            if (date != null) onSelected(date);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                        : 'forms.select_date'.tr(),
                    style: TextStyle(
                      color: selectedDate != null
                          ? AppColors.primaryText
                          : AppColors.hintText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? selectedTime;
  final bool dontKnowTime;
  final Function(TimeOfDay) onSelected;
  final Function(bool) onToggleUnknown;

  const TimePickerField({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.dontKnowTime,
    required this.onSelected,
    required this.onToggleUnknown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: dontKnowTime
              ? null
              : () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        selectedTime ?? const TimeOfDay(hour: 12, minute: 0),
                  );
                  if (time != null) onSelected(time);
                },
          child: Opacity(
            opacity: dontKnowTime ? 0.5 : 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : 'forms.select_time'.tr(),
                      style: TextStyle(
                        color: selectedTime != null
                            ? AppColors.primaryText
                            : AppColors.hintText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: dontKnowTime,
                onChanged: (val) => onToggleUnknown(val ?? false),
                activeColor: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'common.i_dont_know_time'.tr(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        if (dontKnowTime)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'common.time_limited_info'.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.warning,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
