import 'clinical_rules.dart';
import 'rule_model.dart';

class RuleEngine {
  static AIRiskResult calculateRisk(PatientData patient) {
    final firedRules = ClinicalRules.evaluateAll(patient);

    int moderateCount = 0;
    int highCount = 0;

    for (final rule in firedRules) {
      if (rule.severity == 'moderate') {
        moderateCount++;
      } else if (rule.severity == 'high') {
        highCount++;
      }
    }

    // Base score from clinical rules.
    int score =
        (moderateCount * ClinicalRules.weights['moderate']!) +
        (highCount * ClinicalRules.weights['high']!);

    // A high-risk rule needs to produce a clearly high-risk score.
    // This also makes combinations of high-risk findings appropriately
    // distinguishable from moderate cases.
    if (highCount > 0 && score < 61) {
      score = 61;
    }

    // Cap the score at 100.
    if (score > 100) {
      score = 100;
    }

    String riskLevel;

    if (highCount > 0) {
      riskLevel = 'High';
    } else if (moderateCount >= 1) {
      riskLevel = 'Moderate';
    } else {
      riskLevel = 'Low';
    }

    final triggeredRules =
        firedRules.map((rule) => rule.ruleId).toList();

    final explanations =
        firedRules.map((rule) => rule.explanation).toList();

    final recommendations = <String>[
      ...(ClinicalRules.baseRecommendations[riskLevel] ?? []),
    ];

    for (final rule in firedRules) {
      final recommendation =
          ClinicalRules.specificRecommendations[rule.ruleId];

      if (recommendation != null &&
          !recommendations.contains(recommendation)) {
        recommendations.add(recommendation);
      }
    }

    // Flag the doctor when:
    // 1. There is any high-risk rule, OR
    // 2. There are two or more moderate-risk rules.
    final flagForDoctor =
        highCount > 0 || moderateCount >= 2;

    return AIRiskResult(
      riskLevel: riskLevel,
      riskScore: score,
      triggeredRules: triggeredRules,
      explanation: explanations,
      recommendations: recommendations,
      flagForDoctor: flagForDoctor,
    );
  }
}