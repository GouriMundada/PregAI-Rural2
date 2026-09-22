import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/patient_card.dart';
import '../widgets/section_header.dart';
import 'anc_entry_screen.dart';
import 'personalized_diet_plan_screen.dart';
import 'risk_assessment_screen.dart';

class PatientDetailsScreen extends StatelessWidget {
  final Patient patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(patient.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileHeader(patient: patient),
              const SizedBox(height: AppMetrics.spaceL),

              const SectionHeader(
                title: 'Patient Information',
                icon: Icons.badge_outlined,
              ),
              _InfoCard(rows: [
                _InfoRow('Age', '${patient.age} years'),
                _InfoRow('Phone', patient.phone),
                _InfoRow('Address', patient.address),
                _InfoRow('Preferred Language', patient.preferredLanguage),
              ]),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(
                title: 'Pregnancy',
                icon: Icons.pregnant_woman_outlined,
              ),
              _InfoCard(rows: [
                _InfoRow('LMP', patient.lmp),
                _InfoRow('Gestational Age', patient.gestationalAgeDisplay),
                _InfoRow('EDD (from LMP)', patient.edd),
                _InfoRow('Gravidity', '${patient.gravidity}'),
                _InfoRow('Parity', '${patient.parity}'),
                _InfoRow('Pregnancy Type', patient.pregnancyType.label),
                _InfoRow('Previous C-Section', patient.previousCSection ? 'Yes' : 'No'),
                _InfoRow('Previous Preeclampsia', patient.previousPreeclampsia ? 'Yes' : 'No'),
                _InfoRow(
                  'Previous Gestational Diabetes',
                  patient.previousGestationalDiabetes ? 'Yes' : 'No',
                ),
              ]),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(
                title: 'Maternal Measurements',
                icon: Icons.monitor_heart_outlined,
              ),
              _InfoCard(rows: [
                _InfoRow('Weight', patient.weightDisplay),
                _InfoRow('Systolic BP', '${patient.systolicBP} mmHg'),
                _InfoRow('Diastolic BP', '${patient.diastolicBP} mmHg'),
                _InfoRow('Maternal Heart Rate', '${patient.maternalHeartRate} bpm'),
                _InfoRow('Temperature', patient.temperatureDisplay),
                _InfoRow('Hemoglobin', patient.hemoglobinDisplay),
                _InfoRow('Urine Protein', patient.urineProtein.label),
              ]),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(
                title: 'Blood Glucose',
                icon: Icons.bloodtype_outlined,
              ),
              _InfoCard(rows: [
                _InfoRow('Blood Glucose', '${patient.bloodGlucose} mg/dL'),
                _InfoRow('Measurement Type', patient.glucoseMeasurementType.label),
              ]),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(
                title: 'Fetal Assessment',
                icon: Icons.child_friendly_outlined,
              ),
              _InfoCard(rows: [
                _InfoRow('Fetal Heart Rate', '${patient.fetalHeartRate} bpm'),
                _InfoRow(
                  'Decreased Fetal Movement',
                  patient.decreasedFetalMovement ? 'Yes' : 'No',
                ),
              ]),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(
                title: 'Warning Symptoms',
                icon: Icons.warning_amber_rounded,
              ),
              _InfoCard(rows: [
                _InfoRow(
                  'Severe Headache/Blurred Vision',
                  patient.severeHeadacheOrBlurredVision ? 'Yes' : 'No',
                ),
                _InfoRow('Epigastric/RUQ Pain', patient.epigastricOrRuqPain ? 'Yes' : 'No'),
                _InfoRow('Vaginal Bleeding', patient.vaginalBleeding ? 'Yes' : 'No'),
                _InfoRow('Fluid Leakage', patient.fluidLeakage ? 'Yes' : 'No'),
              ]),

              if (patient.hasWarningSigns) ...[
                const SizedBox(height: AppMetrics.spaceM),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppMetrics.spaceM),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
                    border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: patient.activeWarningSigns
                        .map((sign) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_rounded, color: AppColors.danger, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    sign,
                                    style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(
                title: 'Latest ANC Visit',
                icon: Icons.medical_information_outlined,
              ),
              _InfoCard(rows: [
                _InfoRow('Latest Visit', patient.lastAncVisit),
              ]),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(
                title: 'Risk Status',
                icon: Icons.health_and_safety_outlined,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppMetrics.spaceL),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Current Risk Level', style: Theme.of(context).textTheme.titleMedium),
                    RiskBadge(level: patient.riskLevel, large: true),
                  ],
                ),
              ),

              const SizedBox(height: AppMetrics.spaceXL),
              AppButton(
                label: 'Add ANC Visit',
                icon: Icons.add_circle_outline_rounded,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AncEntryScreen(patientName: patient.name),
                  ),
                ),
              ),
              const SizedBox(height: AppMetrics.spaceM),
              AppButton(
                label: 'Risk Assessment',
                icon: Icons.health_and_safety_outlined,
                type: AppButtonType.secondary,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RiskAssessmentScreen(patient: patient),
                  ),
                ),
              ),
              const SizedBox(height: AppMetrics.spaceM),
              AppButton(
                label: 'Nutrition Guidance',
                icon: Icons.restaurant_menu_rounded,
                type: AppButtonType.secondary,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PersonalizedDietPlanScreen(patient: patient),
                  ),
                ),
              ),
              const SizedBox(height: AppMetrics.spaceM),
              AppButton(
                label: 'View History',
                icon: Icons.history_rounded,
                type: AppButtonType.secondary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Visit history is a demo placeholder.')),
                  );
                },
              ),
              const SizedBox(height: AppMetrics.spaceL),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Patient patient;
  const _ProfileHeader({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppMetrics.spaceL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            child: Text(
              patient.name.isNotEmpty ? patient.name[0] : '?',
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: AppMetrics.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Age ${patient.age}  •  GA ${patient.gestationalAgeDisplay}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> rows;
  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: List.generate(rows.length, (index) {
          final row = rows[index];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(row.label, style: Theme.of(context).textTheme.bodyMedium),
                    Flexible(
                      child: Text(
                        row.value,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              if (index != rows.length - 1) const Divider(height: 1),
            ],
          );
        }),
      ),
    );
  }
}
