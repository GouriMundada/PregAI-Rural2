import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/section_header.dart';
import 'health_guidance_screen.dart';

class RiskResultScreen extends StatelessWidget {
  final Patient patient;

  const RiskResultScreen({super.key, required this.patient});

  Color get _color {
    switch (patient.riskLevel) {
      case RiskLevel.low:
        return AppColors.success;
      case RiskLevel.medium:
        return AppColors.warning;
      case RiskLevel.high:
        return AppColors.danger;
    }
  }

  IconData get _icon {
    switch (patient.riskLevel) {
      case RiskLevel.low:
        return Icons.check_circle_rounded;
      case RiskLevel.medium:
        return Icons.warning_rounded;
      case RiskLevel.high:
        return Icons.dangerous_rounded;
    }
  }

  String get _recommendation {
    switch (patient.riskLevel) {
      case RiskLevel.low:
        return 'Continue regular antenatal follow-up.';
      case RiskLevel.medium:
        return 'Closer monitoring and an earlier follow-up visit is recommended.';
      case RiskLevel.high:
        return 'Medical evaluation is recommended.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk Assessment Result')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppMetrics.spaceL),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _color.withValues(alpha: 0.35), width: 1.4),
                ),
                child: Column(
                  children: [
                    Icon(_icon, color: _color, size: 56),
                    const SizedBox(height: AppMetrics.spaceM),
                    Text(
                      patient.riskLevel.label.toUpperCase(),
                      style: TextStyle(
                        color: _color,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'for ${patient.name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppMetrics.spaceM),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.lightPink,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.accentRed, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is a demonstration result only, not a medical diagnosis.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.accentRed,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(title: 'Key Indicators', icon: Icons.list_alt_rounded),
              _IndicatorTile(label: 'Blood Pressure', value: patient.bloodPressureDisplay, icon: Icons.speed_outlined),
              _IndicatorTile(label: 'Hemoglobin', value: patient.hemoglobin, icon: Icons.water_drop_outlined),
              _IndicatorTile(
                label: 'Symptoms',
                value: patient.symptoms.isEmpty ? 'None reported' : patient.symptoms.join(', '),
                icon: Icons.sick_outlined,
              ),
              _IndicatorTile(
                label: 'Gestational Age',
                value: patient.gestationalAge,
                icon: Icons.timelapse_outlined,
              ),
              _IndicatorTile(label: 'Urine Protein', value: patient.urineProtein.label, icon: Icons.opacity_outlined),
              _IndicatorTile(
                label: 'Warning Signs',
                value: patient.hasWarningSigns ? patient.activeWarningSigns.join(', ') : 'None reported',
                icon: Icons.warning_amber_rounded,
              ),

              const SizedBox(height: AppMetrics.spaceL),
              const SectionHeader(title: 'Recommended Action', icon: Icons.assignment_turned_in_outlined),
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
                child: Text(_recommendation, style: Theme.of(context).textTheme.bodyLarge),
              ),

              const SizedBox(height: AppMetrics.spaceXL),
              AppButton(
                label: 'View Health Guidance',
                icon: Icons.menu_book_outlined,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HealthGuidanceScreen()),
                ),
              ),
              const SizedBox(height: AppMetrics.spaceM),
              AppButton(
                label: 'Back to Patient',
                icon: Icons.arrow_back_rounded,
                type: AppButtonType.secondary,
                onPressed: () {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  if (navigator.canPop()) navigator.pop();
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

class _IndicatorTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _IndicatorTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppMetrics.spaceS),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.lightPink, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
