import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../data/patient_repository.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/section_header.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _lmpController = TextEditingController();
  final _eddController = TextEditingController();
  final _gestAgeController = TextEditingController();

  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  final _notesController = TextEditingController();

  String? _preferredLanguage = 'English';
  int? _gravidity = 1;
  int? _parity = 0;
  PregnancyType _pregnancyType = PregnancyType.singleton;
  bool _previousPreeclampsia = false;
  bool _previousGdm = false;
  bool _previousCSection = false;
  String? _relationship = 'Spouse';

  bool _isSaving = false;

  final _gravidityOptions = List.generate(8, (i) => i + 1);
  final _parityOptions = List.generate(8, (i) => i);
  final _relationships = const ['Spouse', 'Parent', 'Sibling', 'Relative', 'Friend', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _lmpController.dispose();
    _eddController.dispose();
    _gestAgeController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickLmp() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return;

    _lmpController.text = _formatDate(picked);

    // EDD is calculated from LMP using Naegele's rule (LMP + 280 days)
    // rather than entered manually, so it always stays consistent with LMP.
    final edd = picked.add(const Duration(days: 280));
    _eddController.text = _formatDate(edd);
    setState(() {});
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _savePatient() async {
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColors.lightPink,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 40),
        ),
        title: const Text('Success', textAlign: TextAlign.center),
        content: const Text(
          'Patient information entered successfully',
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Done',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Registration')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppMetrics.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter patient's basic information",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppMetrics.spaceL),

                const SectionHeader(
                  title: 'Personal Information',
                  icon: Icons.badge_outlined,
                ),
                AppTextField(
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  isRequired: true,
                  controller: _nameController,
                ),
                AppTextField(
                  label: 'Age',
                  icon: Icons.cake_outlined,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  validator: Validators.numeric('Age'),
                ),
                AppTextField(
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                AppTextField(
                  label: 'Address',
                  icon: Icons.location_on_outlined,
                  isRequired: true,
                  maxLines: 2,
                  controller: _addressController,
                ),
                AppDropdownField<String>(
                  label: 'Preferred Language',
                  icon: Icons.translate_rounded,
                  isRequired: true,
                  value: _preferredLanguage,
                  items: DummyData.languageOptions,
                  itemLabel: (l) => l,
                  onChanged: (v) => setState(() => _preferredLanguage = v),
                ),

                const SizedBox(height: AppMetrics.spaceM),
                const SectionHeader(
                  title: 'Pregnancy Information',
                  icon: Icons.pregnant_woman_outlined,
                ),
                AppTextField(
                  label: 'Last Menstrual Period (LMP)',
                  icon: Icons.calendar_today_outlined,
                  isRequired: true,
                  readOnly: true,
                  controller: _lmpController,
                  onTap: _pickLmp,
                ),
                AppTextField(
                  label: 'Gestational Age (weeks)',
                  icon: Icons.timelapse_outlined,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  controller: _gestAgeController,
                  validator: Validators.numeric('Gestational age'),
                ),
                AppTextField(
                  label: 'Expected Delivery Date (EDD)',
                  icon: Icons.event_available_outlined,
                  isRequired: true,
                  readOnly: true,
                  controller: _eddController,
                  hint: 'Auto-calculated from LMP',
                ),
                AppDropdownField<int>(
                  label: 'Gravidity (Total Pregnancies)',
                  icon: Icons.repeat_rounded,
                  isRequired: true,
                  value: _gravidity,
                  items: _gravidityOptions,
                  itemLabel: (n) => n.toString(),
                  onChanged: (v) => setState(() => _gravidity = v),
                ),
                AppDropdownField<int>(
                  label: 'Parity (Previous Births)',
                  icon: Icons.child_care_outlined,
                  isRequired: true,
                  value: _parity,
                  items: _parityOptions,
                  itemLabel: (n) => n.toString(),
                  onChanged: (v) => setState(() => _parity = v),
                ),
                AppDropdownField<PregnancyType>(
                  label: 'Pregnancy Type',
                  icon: Icons.groups_2_outlined,
                  isRequired: true,
                  value: _pregnancyType,
                  items: PregnancyType.values,
                  itemLabel: (p) => p.label,
                  onChanged: (v) => setState(() => _pregnancyType = v ?? _pregnancyType),
                ),

                const SizedBox(height: AppMetrics.spaceM),
                const SectionHeader(
                  title: 'Obstetric History',
                  subtitle: 'From previous pregnancies, if any',
                  icon: Icons.history_edu_outlined,
                ),
                _YesNoCard(
                  children: [
                    _YesNoRow(
                      label: 'Previous Preeclampsia',
                      value: _previousPreeclampsia,
                      onChanged: (v) => setState(() => _previousPreeclampsia = v),
                    ),
                    _YesNoRow(
                      label: 'Previous Gestational Diabetes',
                      value: _previousGdm,
                      onChanged: (v) => setState(() => _previousGdm = v),
                    ),
                    _YesNoRow(
                      label: 'Previous C-Section',
                      value: _previousCSection,
                      onChanged: (v) => setState(() => _previousCSection = v),
                      isLast: true,
                    ),
                  ],
                ),

                const SizedBox(height: AppMetrics.spaceM),
                const SectionHeader(
                  title: 'Emergency Contact',
                  icon: Icons.contact_phone_outlined,
                ),
                AppTextField(
                  label: 'Emergency Contact Name',
                  icon: Icons.person_pin_outlined,
                  isRequired: true,
                  controller: _emergencyNameController,
                ),
                AppTextField(
                  label: 'Emergency Contact Number',
                  icon: Icons.phone_in_talk_outlined,
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                  controller: _emergencyPhoneController,
                ),
                AppDropdownField<String>(
                  label: 'Relationship',
                  icon: Icons.diversity_3_outlined,
                  value: _relationship,
                  items: _relationships,
                  itemLabel: (r) => r,
                  onChanged: (v) => setState(() => _relationship = v),
                ),

                const SizedBox(height: AppMetrics.spaceM),
                const SectionHeader(
                  title: 'Additional Information',
                  icon: Icons.notes_outlined,
                ),
                AppTextField(
                  label: 'Notes / Remarks',
                  icon: Icons.edit_note_outlined,
                  maxLines: 4,
                  controller: _notesController,
                ),

                const SizedBox(height: AppMetrics.spaceL),
                AppButton(
                  label: 'Save Patient',
                  icon: Icons.save_outlined,
                  isLoading: _isSaving,
                  onPressed: _savePatient,
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

/// Card wrapper for a group of Yes/No obstetric-history toggles.
class _YesNoCard extends StatelessWidget {
  final List<Widget> children;
  const _YesNoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppMetrics.spaceM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _YesNoRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _YesNoRow({
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
              Expanded(
                child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
              ),
              Switch(
                value: value,
                activeThumbColor: AppColors.primary,
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
