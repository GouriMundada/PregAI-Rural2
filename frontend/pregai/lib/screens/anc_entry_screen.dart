import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/section_header.dart';

class AncEntryScreen extends StatefulWidget {
  final String? patientName;

  const AncEntryScreen({super.key, this.patientName});

  @override
  State<AncEntryScreen> createState() => _AncEntryScreenState();
}

class _AncEntryScreenState extends State<AncEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _visitDateController = TextEditingController();
  final _gestAgeController = TextEditingController();
  final _visitNumberController = TextEditingController();

  // Blood pressure is captured as two separate fields — systolic and
  // diastolic — rather than one combined string, since the database
  // and risk/ML logic need each value independently.
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _weightController = TextEditingController();
  final _maternalHeartRateController = TextEditingController();
  final _fetalHeartRateController = TextEditingController();
  final _tempController = TextEditingController();

  final _hemoglobinController = TextEditingController();
  final _bloodGlucoseController = TextEditingController();

  final _notesController = TextEditingController();

  UrineProtein? _urineProtein = UrineProtein.negative;
  GlucoseMeasurementType? _glucoseType = GlucoseMeasurementType.fasting;

  final Set<String> _selectedSymptoms = {};

  // Warning / danger signs are tracked individually rather than folded
  // into the general symptom chips, so each can be flagged on its own.
  bool _decreasedFetalMovement = false;
  bool _severeHeadacheOrBlurredVision = false;
  bool _epigastricOrRuqPain = false;
  bool _vaginalBleeding = false;
  bool _fluidLeakage = false;

  bool _isSaving = false;

  @override
  void dispose() {
    _visitDateController.dispose();
    _gestAgeController.dispose();
    _visitNumberController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _weightController.dispose();
    _maternalHeartRateController.dispose();
    _fetalHeartRateController.dispose();
    _tempController.dispose();
    _hemoglobinController.dispose();
    _bloodGlucoseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      _visitDateController.text = '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> _saveAnc() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.success),
            SizedBox(width: 12),
            Expanded(child: Text('ANC data saved successfully')),
          ],
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ANC Entry')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppMetrics.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientName != null
                      ? 'Recording antenatal care for ${widget.patientName}'
                      : 'Record antenatal care information',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppMetrics.spaceL),

                const SectionHeader(
                  title: 'Visit Information',
                  icon: Icons.event_note_outlined,
                ),
                AppTextField(
                  label: 'Visit Date',
                  icon: Icons.calendar_today_outlined,
                  isRequired: true,
                  readOnly: true,
                  controller: _visitDateController,
                  onTap: _pickDate,
                ),
                AppTextField(
                  label: 'Gestational Age (weeks)',
                  icon: Icons.timelapse_outlined,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  controller: _gestAgeController,
                ),
                AppTextField(
                  label: 'ANC Visit Number',
                  icon: Icons.numbers_outlined,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  controller: _visitNumberController,
                ),

                const SizedBox(height: AppMetrics.spaceM),
                const SectionHeader(
                  title: 'Vital Signs',
                  icon: Icons.monitor_heart_outlined,
                ),
                // Systolic / Diastolic BP are captured as two distinct
                // numeric fields, side by side, instead of a single
                // combined "120/80" text value.
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Systolic BP',
                        icon: Icons.arrow_upward_rounded,
                        isRequired: true,
                        hint: 'mmHg',
                        keyboardType: TextInputType.number,
                        controller: _systolicController,
                      ),
                    ),
                    const SizedBox(width: AppMetrics.spaceM),
                    Expanded(
                      child: AppTextField(
                        label: 'Diastolic BP',
                        icon: Icons.arrow_downward_rounded,
                        isRequired: true,
                        hint: 'mmHg',
                        keyboardType: TextInputType.number,
                        controller: _diastolicController,
                      ),
                    ),
                  ],
                ),
                AppTextField(
                  label: 'Maternal Heart Rate (bpm)',
                  icon: Icons.favorite_border_rounded,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  controller: _maternalHeartRateController,
                ),
                AppTextField(
                  label: 'Fetal Heart Rate (bpm)',
                  icon: Icons.child_friendly_outlined,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  controller: _fetalHeartRateController,
                ),
                AppTextField(
                  label: 'Weight (kg)',
                  icon: Icons.monitor_weight_outlined,
                  isRequired: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _weightController,
                ),
                AppTextField(
                  label: 'Temperature (°F)',
                  icon: Icons.thermostat_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _tempController,
                ),

                const SizedBox(height: AppMetrics.spaceM),
                const SectionHeader(
                  title: 'Laboratory Information',
                  icon: Icons.science_outlined,
                ),
                AppTextField(
                  label: 'Hemoglobin (g/dL)',
                  icon: Icons.water_drop_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _hemoglobinController,
                ),
                AppDropdownField<UrineProtein>(
                  label: 'Urine Protein',
                  icon: Icons.opacity_outlined,
                  isRequired: true,
                  value: _urineProtein,
                  items: UrineProtein.values,
                  itemLabel: (u) => u.label,
                  onChanged: (v) => setState(() => _urineProtein = v),
                ),
                // Blood glucose is only meaningful together with the
                // measurement type it was taken under — a value alone
                // (without knowing fasting/random/post-glucose) can't be
                // interpreted, so both are required together.
                AppTextField(
                  label: 'Blood Glucose (mg/dL)',
                  icon: Icons.bloodtype_outlined,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  controller: _bloodGlucoseController,
                ),
                AppDropdownField<GlucoseMeasurementType>(
                  label: 'Measurement Type',
                  icon: Icons.schedule_outlined,
                  isRequired: true,
                  value: _glucoseType,
                  items: GlucoseMeasurementType.values,
                  itemLabel: (g) => g.label,
                  onChanged: (v) => setState(() => _glucoseType = v),
                ),

                const SizedBox(height: AppMetrics.spaceM),
                const SectionHeader(
                  title: 'Symptoms',
                  subtitle: 'Select all that apply',
                  icon: Icons.sick_outlined,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: DummyData.ancSymptomOptions.map((symptom) {
                    final selected = _selectedSymptoms.contains(symptom);
                    return FilterChip(
                      label: Text(symptom),
                      selected: selected,
                      showCheckmark: false,
                      avatar: selected
                          ? const Icon(Icons.check_circle, size: 18, color: Colors.white)
                          : null,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedSymptoms.add(symptom);
                          } else {
                            _selectedSymptoms.remove(symptom);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppMetrics.spaceL),
                const SectionHeader(
                  title: 'Warning Signs',
                  subtitle: 'Danger signs requiring urgent attention',
                  icon: Icons.warning_amber_rounded,
                ),
                _WarningSignsCard(
                  children: [
                    _WarningToggle(
                      label: 'Decreased Fetal Movement',
                      value: _decreasedFetalMovement,
                      onChanged: (v) => setState(() => _decreasedFetalMovement = v),
                    ),
                    _WarningToggle(
                      label: 'Severe Headache / Blurred Vision',
                      value: _severeHeadacheOrBlurredVision,
                      onChanged: (v) => setState(() => _severeHeadacheOrBlurredVision = v),
                    ),
                    _WarningToggle(
                      label: 'Epigastric / RUQ Pain',
                      value: _epigastricOrRuqPain,
                      onChanged: (v) => setState(() => _epigastricOrRuqPain = v),
                    ),
                    _WarningToggle(
                      label: 'Vaginal Bleeding',
                      value: _vaginalBleeding,
                      onChanged: (v) => setState(() => _vaginalBleeding = v),
                    ),
                    _WarningToggle(
                      label: 'Fluid Leakage',
                      value: _fluidLeakage,
                      onChanged: (v) => setState(() => _fluidLeakage = v),
                      isLast: true,
                    ),
                  ],
                ),

                const SizedBox(height: AppMetrics.spaceL),
                const SectionHeader(
                  title: 'Clinical Notes',
                  icon: Icons.description_outlined,
                ),
                AppTextField(
                  label: 'Notes',
                  hint: 'Enter any clinical observations...',
                  maxLines: 5,
                  controller: _notesController,
                ),

                const SizedBox(height: AppMetrics.spaceL),
                AppButton(
                  label: 'Save ANC Data',
                  icon: Icons.save_outlined,
                  isLoading: _isSaving,
                  onPressed: _saveAnc,
                ),
                const SizedBox(height: AppMetrics.spaceL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Card wrapper for the warning-sign toggles, styled with a red tint
/// so it visually reads as more urgent than the routine symptom chips.
class _WarningSignsCard extends StatelessWidget {
  final List<Widget> children;
  const _WarningSignsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.danger.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _WarningToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _WarningToggle({
    required this.label,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Icon(
                value ? Icons.error_rounded : Icons.circle_outlined,
                size: 18,
                color: value ? AppColors.danger : AppColors.greyText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
              ),
              Switch(
                value: value,
                activeThumbColor: AppColors.danger,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
