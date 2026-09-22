import 'rule_models.dart';
import 'clinical_rules.dart';

class RuleEngine {
  /// Entry point for calculating pregnancy risk
  static AIRiskResult calculateRisk(PatientData patientData) {
    List<RuleResult> fired = ClinicalRules.evaluateAll(patientData);

    // Score calculation
    int rawScore = 0;
    int highCount = 0;
    int moderateCount = 0;

    for (var rule in fired) {
      rawScore += ClinicalRules.weights[rule.severity] ?? 0;
      if (rule.severity == 'high') highCount++;
      if (rule.severity == 'moderate') moderateCount++;
    }

    int riskScore = rawScore > 100 ? 100 : rawScore;

    // Classification & 2+ escalation rule
    String riskLevel = 'Low';
    if (highCount >= 1 || riskScore >= 61) {
      riskLevel = 'High';
    } else if (moderateCount >= 2 || riskScore >= 26) {
      riskLevel = 'Moderate';
    }

    // Assemble outputs
    List<String> triggeredRules = fired.map((e) => e.ruleId).toList();
    List<String> explanations = fired.map((e) => e.explanation).toList();

    // Compile recommendations
    List<String> recs = List.from(ClinicalRules.baseRecommendations[riskLevel] ?? []);
    for (var ruleId in triggeredRules) {
      if (ClinicalRules.specificRecommendations.containsKey(ruleId)) {
        String specific = ClinicalRules.specificRecommendations[ruleId]!;
        if (!recs.contains(specific)) {
          recs.add(specific);
        }
      }
    }

    bool flagForDoctor = (riskLevel == 'High') || (moderateCount >= 2);

    return AIRiskResult(
      riskLevel: riskLevel,
      riskScore: riskScore,
      triggeredRules: triggeredRules,
      explanation: explanations,
      recommendations: recs,
      flagForDoctor: flagForDoctor,
    );
  }
}
