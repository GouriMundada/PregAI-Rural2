import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/section_header.dart';
import 'risk_result_screen.dart';

class RiskAssessmentScreen extends StatefulWidget {
  final Patient? patient;

  const RiskAssessmentScreen({super.key, this.patient});

  @override
  State<RiskAssessmentScreen> createState() => _RiskAssessmentScreenState();
}

class _RiskAssessmentScreenState extends State<RiskAssessmentScreen> {
  bool _isAnalyzing = false;
  late Patient _selectedPatient;
  bool get _isTabRoot => widget.patient == null;

  @override
  void initState() {
    super.initState();
    _selectedPatient = widget.patient ?? DummyData.patients.first;
  }

  Future<void> _analyzeRisk() async {
    setState(() => _isAnalyzing = true);
    // Demo-only delay to simulate analysis. No real ML model is used.
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    setState(() => _isAnalyzing = false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RiskResultScreen(patient: _selectedPatient),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppMetrics.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review maternal health indicators',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppMetrics.spaceL),

            if (_isTabRoot) ...[
              const SectionHeader(title: 'Select Patient', icon: Icons.person_search_outlined),
              _PatientPicker(
                selected: _selectedPatient,
                onSelected: (p) => setState(() => _selectedPatient = p),
              ),
              const SizedBox(height: AppMetrics.spaceL),
            ],

            const SectionHeader(title: 'Patient Information', icon: Icons.person_outline),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppMetrics.spaceM),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.lightPink,
                    child: Text(
                      _selectedPatient.name[0],
                      style: const TextStyle(color: AppColors.accentRed, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: AppMetrics.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_selectedPatient.name, style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          'Age ${_selectedPatient.age}  •  GA ${_selectedPatient.gestationalAgeDisplay}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppMetrics.spaceL),
            const SectionHeader(title: 'Health Parameters', icon: Icons.monitor_heart_outlined),
            _ParamGrid(patient: _selectedPatient),

            const SizedBox(height: AppMetrics.spaceM),
            if (_selectedPatient.symptoms.isNotEmpty) ...[
              Text('Symptoms', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppMetrics.spaceS),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedPatient.symptoms
                    .map((s) => Chip(label: Text(s), backgroundColor: AppColors.lightPink))
                    .toList(),
              ),
            ] else
              Text('No symptoms reported.', style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: AppMetrics.spaceXL),
            AppButton(
              label: 'Analyze Risk',
              icon: Icons.query_stats_rounded,
              isLoading: _isAnalyzing,
              onPressed: _analyzeRisk,
            ),
            const SizedBox(height: AppMetrics.spaceS),
            Text(
              'This is a frontend demonstration only. No actual analysis is performed.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppMetrics.spaceL),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Risk Assessment')),
      body: body,
      bottomNavigationBar: _isTabRoot
          ? AppBottomNavigation(
              currentIndex: 2,
              onTap: (index) => handleTabTap(context, index, 2),
            )
          : null,
    );
  }
}

class _PatientPicker extends StatelessWidget {
  final Patient selected;
  final ValueChanged<Patient> onSelected;

  const _PatientPicker({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DummyData.patients.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppMetrics.spaceS),
        itemBuilder: (context, index) {
          final patient = DummyData.patients[index];
          final isSelected = patient.id == selected.id;
          return GestureDetector(
            onTap: () => onSelected(patient),
            child: Container(
              width: 92,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.lightPink,
                  width: 1.4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.lightPink,
                    child: Text(
                      patient.name[0],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.accentRed,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    patient.name.split(' ').first,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.darkText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ParamGrid extends StatelessWidget {
  final Patient patient;
  const _ParamGrid({required this.patient});

  @override
  Widget build(BuildContext context) {
    final params = [
      ('Blood Pressure', patient.bloodPressureDisplay, Icons.speed_outlined),
      ('Hemoglobin', patient.hemoglobinDisplay, Icons.water_drop_outlined),
      (
        'Blood Glucose',
        '${patient.bloodGlucose} mg/dL (${patient.glucoseMeasurementType.label})',
        Icons.bloodtype_outlined,
      ),
      ('Urine Protein', patient.urineProtein.label, Icons.opacity_outlined),
      ('Fetal Heart Rate', '${patient.fetalHeartRate} bpm', Icons.child_friendly_outlined),
      ('Weight', patient.weightDisplay, Icons.monitor_weight_outlined),
      ('Temperature', patient.temperatureDisplay, Icons.thermostat_outlined),
      ('Gestational Age', patient.gestationalAgeDisplay, Icons.timelapse_outlined),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppMetrics.spaceM,
        crossAxisSpacing: AppMetrics.spaceM,
        childAspectRatio: 1.8,
      ),
      itemCount: params.length,
      itemBuilder: (context, index) {
        final (label, value, icon) = params[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(height: 6),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
