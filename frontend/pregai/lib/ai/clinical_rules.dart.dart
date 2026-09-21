import 'rule_models.dart';

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
  static List<RuleResult> evaluateAll(PatientData p) {
    List<RuleResult> fired = [];

    // Age
    if (p.age != null) {
      if (p.age! < 18 || p.age! >= 40) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'AGE_HIGH',
          explanation: 'Maternal age (${p.age}) is in the high-risk band.',
        ));
      } else if (p.age! < 20 || p.age! >= 35) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'AGE_MOD',
          explanation: 'Maternal age (${p.age}) is in the moderate-risk band.',
        ));
      }
    }

    // Systolic BP
    if (p.systolicBp != null) {
      if (p.systolicBp! >= 140) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'SBP_HIGH',
          explanation: 'Systolic BP (${p.systolicBp} mmHg) is elevated (≥140).',
        ));
      } else if (p.systolicBp! >= 130) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'SBP_MOD',
          explanation: 'Systolic BP (${p.systolicBp} mmHg) is mildly elevated.',
        ));
      }
    }

    // Diastolic BP
    if (p.diastolicBp != null) {
      if (p.diastolicBp! >= 90) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'DBP_HIGH',
          explanation: 'Diastolic BP (${p.diastolicBp} mmHg) is elevated (≥90).',
        ));
      } else if (p.diastolicBp! >= 85) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'DBP_MOD',
          explanation: 'Diastolic BP (${p.diastolicBp} mmHg) is mildly elevated.',
        ));
      }
    }

    // Hemoglobin
    if (p.hemoglobin != null) {
      if (p.hemoglobin! < 9.0) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'HB_HIGH',
          explanation: 'Hemoglobin (${p.hemoglobin} g/dL) indicates severe anemia.',
        ));
      } else if (p.hemoglobin! < 11.0) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'HB_MOD',
          explanation: 'Hemoglobin (${p.hemoglobin} g/dL) is below normal range.',
        ));
      }
    }

    // Blood Glucose
    if (p.bloodGlucose != null) {
      double modThresh = 96.0;
      double highThresh = 126.0;
      if (p.bloodGlucoseType.toLowerCase() != 'fasting') {
        modThresh = 140.0;
        highThresh = 200.0;
      }
      if (p.bloodGlucose! >= highThresh) {
        fired.add(RuleResult(
          severity: 'high',
          ruleId: 'GLUCOSE_HIGH',
          explanation: 'Blood glucose (${p.bloodGlucose} mg/dL) exceeds high threshold.',
        ));
      } else if (p.bloodGlucose! >= modThresh) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'GLUCOSE_MOD',
          explanation: 'Blood glucose (${p.bloodGlucose} mg/dL) is mildly elevated.',
        ));
      }
    }

    // Prior Preeclampsia
    if (p.priorPreeclampsia) {
      fired.add(RuleResult(
        severity: 'moderate',
        ruleId: 'PREV_PE',
        explanation: 'Patient has a history of pre-eclampsia in a previous pregnancy.',
      ));
    }

    // Prior Gestational Diabetes
    if (p.priorGestationalDiabetes) {
      fired.add(RuleResult(
        severity: 'moderate',
        ruleId: 'PREV_GDM',
        explanation: 'Patient has a history of gestational diabetes.',
      ));
    }

    // Plurality
    if (p.plurality.toLowerCase().contains('twin') || p.plurality.toLowerCase().contains('multiple')) {
      fired.add(RuleResult(
        severity: 'moderate',
        ruleId: 'PLURALITY',
        explanation: 'Multiple pregnancy (twins or more) noted.',
      ));
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

    // Maternal Heart Rate
    if (p.maternalHeartRate != null) {
      if (p.maternalHeartRate! < 60 || p.maternalHeartRate! > 100) {
        fired.add(RuleResult(
          severity: 'moderate',
          ruleId: 'MHR_MOD',
          explanation: 'Maternal heart rate (${p.maternalHeartRate} bpm) is outside normal range (60–100).',
        ));
      }
    }

    // Urine Protein
    String protein = p.urineProtein.toLowerCase().replaceAll('+', '').trim();
    int proteinLevel = 0;
    if (protein == '1') proteinLevel = 1;
    if (['2', '3', '4'].contains(protein)) proteinLevel = 2;

    if (proteinLevel >= 2) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'PROTEIN_HIGH',
        explanation: 'Significant proteinuria noted (${p.urineProtein}).',
      ));
    } else if (proteinLevel == 1) {
      fired.add(RuleResult(
        severity: 'moderate',
        ruleId: 'PROTEIN_MOD',
        explanation: 'Mild proteinuria noted (1+).',
      ));
    }

    // Danger Symptoms
    if (p.decreasedFetalMovement) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_DFM',
        explanation: 'Decreased fetal movement reported.',
      ));
    }
    if (p.severeHeadacheBlurredVision) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_HEADACHE',
        explanation: 'Severe headache or blurred vision reported.',
      ));
    }
    if (p.epigastricRuqPain) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_PAIN',
        explanation: 'Epigastric or right upper quadrant pain reported.',
      ));
    }
    if (p.vaginalBleeding) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_BLEEDING',
        explanation: 'Vaginal bleeding reported.',
      ));
    }
    if (p.fluidLeakage) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'SYM_FLUID',
        explanation: 'Fluid leakage reported.',
      ));
    }

    // Pre-eclampsia Triad Pattern
    if ((p.systolicBp ?? 0) >= 140 && proteinLevel >= 1 && p.severeHeadacheBlurredVision) {
      fired.add(RuleResult(
        severity: 'high',
        ruleId: 'PE_TRIAD',
        explanation: 'Pre-eclampsia triad: High BP + proteinuria + headache.',
      ));
    }

    return fired;
  }
}