/// Data model representing patient input parameters
/// Fully aligned with AI_Input_Parameters_2.docx
class PatientData {
  final int? age;
  final int? gestationalAgeWeeks;
  final int? gravidity;
  final int? parity;
  final bool priorPreeclampsia;
  final bool priorGestationalDiabetes;
  final bool priorCSection;
  final String plurality; // 'Singleton' or 'Twins+'
  final int? systolicBp;
  final int? diastolicBp;
  final int? maternalHeartRate;
  final int? fetalHeartRate;
  final double? weight;
  final double? hemoglobin;
  final String urineProtein; // 'Negative', 'Trace', '1+', '2+', '3+', '4+'
  final double? bloodGlucose;
  final String bloodGlucoseType; // 'fasting', 'random', or 'post_ogtt'
  final bool decreasedFetalMovement;
  final bool severeHeadacheBlurredVision;
  final bool epigastricRuqPain;
  final bool vaginalBleeding;
  final bool fluidLeakage;

  PatientData({
    this.age,
    this.gestationalAgeWeeks,
    this.gravidity,
    this.parity,
    this.priorPreeclampsia = false,
    this.priorGestationalDiabetes = false,
    this.priorCSection = false,
    this.plurality = 'Singleton',
    this.systolicBp,
    this.diastolicBp,
    this.maternalHeartRate,
    this.fetalHeartRate,
    this.weight,
    this.hemoglobin,
    this.urineProtein = 'Negative',
    this.bloodGlucose,
    this.bloodGlucoseType = 'fasting',
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
