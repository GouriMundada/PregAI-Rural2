/// Data model representing patient input parameters
/// Fully aligned with AI_Input_Parameters (21 parameters)
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

  /// Convert PatientData to JSON (snake_case for API compatibility)
  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'gestational_age_weeks': gestationalAgeWeeks,
      'gravidity': gravidity,
      'parity': parity,
      'prior_preeclampsia': priorPreeclampsia,
      'prior_gestational_diabetes': priorGestationalDiabetes,
      'prior_c_section': priorCSection,
      'plurality': plurality,
      'systolic_bp': systolicBp,
      'diastolic_bp': diastolicBp,
      'maternal_heart_rate': maternalHeartRate,
      'fetal_heart_rate': fetalHeartRate,
      'weight': weight,
      'hemoglobin': hemoglobin,
      'urine_protein': urineProtein,
      'blood_glucose': bloodGlucose,
      'blood_glucose_type': bloodGlucoseType,
      'decreased_fetal_movement': decreasedFetalMovement,
      'severe_headache_blurred_vision': severeHeadacheBlurredVision,
      'epigastric_ruq_pain': epigastricRuqPain,
      'vaginal_bleeding': vaginalBleeding,
      'fluid_leakage': fluidLeakage,
    };
  }

  /// Create PatientData from JSON (snake_case from API)
  static PatientData fromJson(Map<String, dynamic> json) {
    return PatientData(
      age: json['age'] as int?,
      gestationalAgeWeeks: json['gestational_age_weeks'] as int?,
      gravidity: json['gravidity'] as int?,
      parity: json['parity'] as int?,
      priorPreeclampsia: json['prior_preeclampsia'] as bool? ?? false,
      priorGestationalDiabetes: json['prior_gestational_diabetes'] as bool? ?? false,
      priorCSection: json['prior_c_section'] as bool? ?? false,
      plurality: json['plurality'] as String? ?? 'Singleton',
      systolicBp: json['systolic_bp'] as int?,
      diastolicBp: json['diastolic_bp'] as int?,
      maternalHeartRate: json['maternal_heart_rate'] as int?,
      fetalHeartRate: json['fetal_heart_rate'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      hemoglobin: (json['hemoglobin'] as num?)?.toDouble(),
      urineProtein: json['urine_protein'] as String? ?? 'Negative',
      bloodGlucose: (json['blood_glucose'] as num?)?.toDouble(),
      bloodGlucoseType: json['blood_glucose_type'] as String? ?? 'fasting',
      decreasedFetalMovement: json['decreased_fetal_movement'] as bool? ?? false,
      severeHeadacheBlurredVision: json['severe_headache_blurred_vision'] as bool? ?? false,
      epigastricRuqPain: json['epigastric_ruq_pain'] as bool? ?? false,
      vaginalBleeding: json['vaginal_bleeding'] as bool? ?? false,
      fluidLeakage: json['fluid_leakage'] as bool? ?? false,
    );
  }
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

  /// Convert to JSON for API responses
  Map<String, dynamic> toJson() {
    return {
      'severity': severity,
      'rule_id': ruleId,
      'explanation': explanation,
    };
  }
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

  /// Convert AIRiskResult to JSON (matches output contract)
  Map<String, dynamic> toJson() {
    return {
      'risk_level': riskLevel,
      'risk_score': riskScore,
      'triggered_rules': triggeredRules,
      'explanation': explanation,
      'recommendations': recommendations,
      'flag_for_doctor': flagForDoctor,
    };
  }

  /// Create AIRiskResult from JSON
  static AIRiskResult fromJson(Map<String, dynamic> json) {
    return AIRiskResult(
      riskLevel: json['risk_level'] as String,
      riskScore: json['risk_score'] as int,
      triggeredRules: List<String>.from(json['triggered_rules'] as List? ?? []),
      explanation: List<String>.from(json['explanation'] as List? ?? []),
      recommendations: List<String>.from(json['recommendations'] as List? ?? []),
      flagForDoctor: json['flag_for_doctor'] as bool? ?? false,
    );
  }
}
