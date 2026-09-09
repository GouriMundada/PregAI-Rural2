import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';

/// A risk-level pill badge, reused on Patient Records, Patient
/// Details, and Risk Result screens.
class RiskBadge extends StatelessWidget {
  final RiskLevel level;
  final bool large;

  const RiskBadge({super.key, required this.level, this.large = false});

  Color get _color {
    switch (level) {
      case RiskLevel.low:
        return AppColors.success;
      case RiskLevel.medium:
        return AppColors.warning;
      case RiskLevel.high:
        return AppColors.danger;
    }
  }

  IconData get _icon {
    switch (level) {
      case RiskLevel.low:
        return Icons.check_circle_rounded;
      case RiskLevel.medium:
        return Icons.warning_rounded;
      case RiskLevel.high:
        return Icons.dangerous_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16 : 10,
        vertical: large ? 8 : 5,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppMetrics.chipRadius),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: large ? 20 : 14, color: _color),
          const SizedBox(width: 6),
          Text(
            level.label,
            style: TextStyle(
              color: _color,
              fontWeight: FontWeight.w700,
              fontSize: large ? 15 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// A patient summary card used in the Patient Records list.
class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const PatientCard({super.key, required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(AppMetrics.spaceM),
          decoration: BoxDecoration(
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
                radius: 26,
                backgroundColor: AppColors.lightPink,
                child: Text(
                  patient.name.isNotEmpty ? patient.name[0] : '?',
                  style: const TextStyle(
                    color: AppColors.accentRed,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppMetrics.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patient.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      'Age: ${patient.age}  •  GA: ${patient.gestationalAge}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Last ANC: ${patient.lastAncVisit}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppMetrics.spaceS),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RiskBadge(level: patient.riskLevel),
                  const SizedBox(height: 22),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.greyText),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
