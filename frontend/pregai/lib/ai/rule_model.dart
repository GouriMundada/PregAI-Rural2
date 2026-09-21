/// Data model representing patient input parameters
class PatientData {
  final int? age;
  final int? gestationalAgeWeeks;
  final int? systolicBp;
  final int? diastolicBp;
  final double? hemoglobin;
  final double? bloodGlucoseValue;
  final String bloodGlucoseType; // 'fasting', 'random', or 'post_ogtt'
  final String urineProtein; // 'Negative', 'Trace', '1+', '2+', etc.
  final bool priorPreeclampsia;
  final bool priorGestationalDiabetes;
  final String plurality; // 'Singleton' or 'Twins+'
  final int? fetalHeartRate;
  final int? maternalHeartRate;
  final bool decreasedFetalMovement;
  final bool severeHeadacheBlurredVision;
  final bool epigastricRuqPain;
  final bool vaginalBleeding;
  final bool fluidLeakage;

  PatientData({
    this.age,
    this.gestationalAgeWeeks,
    this.systolicBp,
    this.diastolicBp,
    this.hemoglobin,
    this.bloodGlucoseValue,
    this.bloodGlucoseType = 'fasting',
    this.urineProtein = 'Negative',
    this.priorPreeclampsia = false,
    this.priorGestationalDiabetes = false,
    this.plurality = 'Singleton',
    this.fetalHeartRate,
    this.maternalHeartRate,
    this.decreasedFetalMovement = false,
    this.severeHeadacheBlurredVision = false,
    this.epigastricRuqPain = false,
    this.vaginalBleeding = false,
    this.fluidLeakage = false,
  });
}

/// Rule match result model
class RuleResult {
  final String severity; // 'moderate' or 'high'
  final String ruleId;
  final String explanation;

  RuleResult({
    required this.severity,
    required this.ruleId,
    required this.explanation,
  });
}

/// Final output contract returned by the AI engine
class AIRiskResult {
  final String riskLevel; // 'Low', 'Moderate', or 'High'
  final int riskScore; // 0 to 100
  final List<String> triggeredRules;
  final List<String> explanation;
  final List<String> recommendations;
  final bool flagForDoctor;

  AIRiskResult({
    required this.riskLevel,
    required this.riskScore,
    required this.triggeredRules,
    required this.explanation,
    required this.recommendations,
    required this.flagForDoctor,
  });
}
