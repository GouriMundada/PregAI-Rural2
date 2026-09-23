import 'rule_model.dart';

class ClinicalRules {
  static const Map<String, int> weights = {
    'moderate': 10,
    'high': 25,
  };

  static const Map<String, List<String>> baseRecommendations = {
    'Low': [
      'Continue routine antenatal visits as scheduled.',
      'Maintain a balanced diet rich in iron, folic acid, and protein.',
      'Stay lightly active and get adequate rest.',
      'Return earlier if any new symptoms appear.',
    ],
    'Moderate': [
      'Schedule a follow-up visit within 1 week.',
      'Contact your ASHA worker or doctor if symptoms worsen.',
      'Avoid strenuous physical activity until reviewed.',
      'Monitor any flagged parameters closely until next visit.',
    ],
    'High': [
      'Seek in-person clinical evaluation as soon as possible.',
      'Contact your linked doctor or visit the nearest health facility today.',
      'Do not delay — this case has been flagged on the doctor dashboard.',
      'If you feel acutely unwell, go to an emergency facility immediately.',
    ],
  };

  static const Map<String, String> specificRecommendations = {
    'SBP_HIGH': 'Monitor blood pressure closely; avoid salt and stress.',
    'SBP_MOD': 'Reduce salt intake and check BP at home if possible.',
    'DBP_HIGH': 'High diastolic BP requires prompt clinical review.',
    'DBP_MOD': 'Monitor blood pressure at home if a cuff is available.',
    'HB_HIGH': 'Begin iron and folic acid supplementation as prescribed.',
    'HB_MOD': 'Increase iron-rich food intake (leafy greens, lentils).',
    'GLUCOSE_HIGH': 'Seek immediate assessment for gestational diabetes.',
    'GLUCOSE_MOD': 'Reduce refined sugar and carbohydrate intake.',
    'PROTEIN_HIGH': 'High proteinuria with elevated BP indicates pre-eclampsia risk.',
    'PROTEIN_MOD': 'Mild proteinuria noted; ensure adequate hydration.',
    'PREV_PE': 'Monitor BP and urine protein at every visit due to prior history.',
    'PREV_GDM': 'Request a glucose screening test early in this pregnancy.',
    'PLURALITY': 'Multiple pregnancies require more frequent monitoring.',
    'FHR_HIGH': 'Abnormal fetal heart rate requires immediate clinical evaluation.',
    'MHR_MOD': 'Unusual maternal heart rate noted; inform your doctor.',
    'SYM_DFM': 'Decreased fetal movement is an emergency sign — seek care today.',
    'SYM_HEADACHE': 'Severe headache or blurred vision may indicate pre-eclampsia.',
    'SYM_PAIN': 'Upper abdominal pain can indicate HELLP syndrome — go to a clinic.',
    'SYM_BLEEDING': 'Vaginal bleeding requires immediate evaluation.',
    'SYM_FLUID': 'Fluid leakage requires immediate clinical assessment.',
    'PE_TRIAD': 'Pre-eclampsia triad detected. Go to the hospital now.',
    'AGE_HIGH': 'Younger or older maternal age requires closer monitoring.',
    'AGE_MOD': 'Age-related risk noted; maintain regular ANC visits.',
  };

  /// Runs all clinical threshold checks against patient data
  /// Returns a list of fired rules (empty list if no rules triggered)
  static List<RuleResult> evaluateAll(PatientData p) {
    List<RuleResult> fired = [];

    // =========================================================================
    // DEMOGRAPHIC RULES
    // =========================================================================

    // Age Rule
    if (p.age != null) {
      if (p.age! < 18 || p.age! >= 40) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'AGE_HIGH',
          explanation: 'Maternal age (${p.age} years) is in the high-risk band.',
        ));
      } else if (p.age! < 20 || p.age! >= 35) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'AGE_MOD',
          explanation: 'Maternal age (${p.age} years) is in the moderate-risk band.',
        ));
      }
    }

    // =========================================================================
    // VITAL SIGNS RULES
    // =========================================================================

    // Systolic Blood Pressure
    if (p.systolicBp != null) {
      if (p.systolicBp! >= 140) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'SBP_HIGH',
          explanation: 'Systolic BP (${p.systolicBp} mmHg) is at or above 140 mmHg.',
        ));
      } else if (p.systolicBp! >= 130) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'SBP_MOD',
          explanation: 'Systolic BP (${p.systolicBp} mmHg) is mildly elevated (130–139).',
        ));
      }
    }

    // Diastolic Blood Pressure
    if (p.diastolicBp != null) {
      if (p.diastolicBp! >= 90) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'DBP_HIGH',
          explanation: 'Diastolic BP (${p.diastolicBp} mmHg) is at or above 90 mmHg.',
        ));
      } else if (p.diastolicBp! >= 85) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'DBP_MOD',
          explanation: 'Diastolic BP (${p.diastolicBp} mmHg) is mildly elevated (85–89).',
        ));
      }
    }

    // Maternal Heart Rate
    if (p.maternalHeartRate != null) {
      if (p.maternalHeartRate! < 60 || p.maternalHeartRate! > 100) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'MHR_MOD',
          explanation: 'Maternal heart rate (${p.maternalHeartRate} bpm) is outside normal range.',
        ));
      }
    }

    // Fetal Heart Rate
    if (p.fetalHeartRate != null) {
      if (p.fetalHeartRate! < 110 || p.fetalHeartRate! > 160) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'FHR_HIGH',
          explanation: 'Fetal heart rate (${p.fetalHeartRate} bpm) is outside normal range (110–160).',
        ));
      }
    }

    // =========================================================================
    // LABORATORY TESTS RULES
    // =========================================================================

    // Hemoglobin (Anemia Assessment)
    if (p.hemoglobin != null) {
      if (p.hemoglobin! < 9.0) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'HB_HIGH',
          explanation: 'Hemoglobin (${p.hemoglobin} g/dL) indicates severe anemia (<9.0).',
        ));
      } else if (p.hemoglobin! < 11.0) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'HB_MOD',
          explanation: 'Hemoglobin (${p.hemoglobin} g/dL) is below normal range (9.0–10.9).',
        ));
      }
    }

    // Blood Glucose (with proper type-based thresholds)
    if (p.bloodGlucose != null) {
      // Define thresholds based on measurement type
      double moderateThreshold = 96.0;
      double highThreshold = 126.0;

      String glucoseType = p.bloodGlucoseType.toLowerCase();

      // Fasting thresholds (defaults above)
      if (glucoseType == 'random' || glucoseType == 'post_ogtt') {
        // Random and post-OGTT have higher thresholds
        moderateThreshold = 140.0;
        highThreshold = 200.0;
      }
      // If 'fasting' or unknown type, use fasting thresholds (already set above)

      if (p.bloodGlucose! >= highThreshold) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'GLUCOSE_HIGH',
          explanation: 'Blood glucose (${p.bloodGlucose} mg/dL, $glucoseType) exceeds high threshold (≥${highThreshold.toInt()}).',
        ));
      } else if (p.bloodGlucose! >= moderateThreshold) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'GLUCOSE_MOD',
          explanation: 'Blood glucose (${p.bloodGlucose} mg/dL, $glucoseType) is mildly elevated.',
        ));
      }
    }

    // Urine Protein (Proteinuria Assessment)
    String proteinStr = p.urineProtein.toLowerCase().replaceAll('+', '').trim();
    int proteinLevel = 0;
    if (proteinStr == '1') {
      proteinLevel = 1;
    } else if (['2', '3', '4'].contains(proteinStr)) {
      proteinLevel = 2;
    }

    if (proteinLevel >= 2) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'PROTEIN_HIGH',
        explanation: 'Significant proteinuria noted (${p.urineProtein}) — possible pre-eclampsia.',
      ));
    } else if (proteinLevel == 1) {
      fired.add(RuleResult(
        severity: 'moderate',
        ruleId: 'PROTEIN_MOD',
        explanation: 'Mild proteinuria noted (1+) — requires monitoring.',
      ));
    }

    // =========================================================================
    // OBSTETRIC HISTORY RULES
    // =========================================================================

    // Prior Preeclampsia
    if (p.priorPreeclampsia) {
      fired.add(RuleResult(
        severity: 'moderate',
        ruleId: 'PREV_PE',
        explanation: 'Patient has a history of pre-eclampsia — elevated recurrence risk.',
      ));
    }

    // Prior Gestational Diabetes
    if (p.priorGestationalDiabetes) {
      fired.add(RuleResult(
        severity: 'moderate',
        ruleId: 'PREV_GDM',
        explanation: 'Patient has a history of gestational diabetes — elevated recurrence risk.',
      ));
    }

    // Plurality (Singleton vs Twins+)
    if (p.plurality.toLowerCase().contains('twin') || p.plurality.toLowerCase().contains('multiple')) {
      fired.add(RuleResult(
        severity: 'moderate',
        ruleId: 'PLURALITY',
        explanation: 'Multiple pregnancy (twins or more) — inherently higher-risk category.',
      ));
    }

    // =========================================================================
    // DANGER SYMPTOM RULES
    // =========================================================================

    // Decreased Fetal Movement
    if (p.decreasedFetalMovement) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_DFM',
        explanation: 'Decreased fetal movement reported — emergency sign requiring urgent evaluation.',
      ));
    }

    // Severe Headache or Blurred Vision
    if (p.severeHeadacheBlurredVision) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_HEADACHE',
        explanation: 'Severe headache or blurred vision reported — possible pre-eclampsia warning.',
      ));
    }

    // Epigastric or RUQ Pain
    if (p.epigastricRuqPain) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_PAIN',
        explanation: 'Epigastric or right upper quadrant pain reported — possible HELLP syndrome.',
      ));
    }

    // Vaginal Bleeding
    if (p.vaginalBleeding) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_BLEEDING',
        explanation: 'Vaginal bleeding reported — requires immediate evaluation.',
      ));
    }

    // Fluid Leakage
    if (p.fluidLeakage) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_FLUID',
        explanation: 'Fluid leakage reported — possible premature rupture of membranes.',
      ));
    }

    // =========================================================================
    // COMPOUND / PATTERN RULES
    // =========================================================================

    // Pre-eclampsia Triad: High BP + Proteinuria + Severe Headache/Blurred Vision
    if ((p.systolicBp ?? 0) >= 140 && proteinLevel >= 1 && p.severeHeadacheBlurredVision) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'PE_TRIAD',
        explanation: 'Pre-eclampsia triad pattern detected: high BP + proteinuria + headache/vision change.',
      ));
    }

    return fired;
  }
}
