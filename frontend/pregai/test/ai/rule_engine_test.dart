import 'package:flutter_test/flutter_test.dart';
import 'package:pregai/ai/rule_model.dart';
import 'package:pregai/ai/rule_engine.dart';

void main() {
  group('PregAI Rule Engine Tests', () {
    
    test('Case 1: Low Risk - Routine Checkup', () {
      // A healthy 26-year-old at 24 weeks with normal vitals and labs
      final patient = PatientData(
        age: 26,
        gestationalAgeWeeks: 24,
        gravidity: 2,
        parity: 1,
        systolicBp: 118,
        diastolicBp: 76,
        hemoglobin: 12.1,
        bloodGlucose: 88,
        bloodGlucoseType: 'fasting',
        urineProtein: 'Negative',
        maternalHeartRate: 78,
        fetalHeartRate: 145,
      );

      final result = RuleEngine.calculateRisk(patient);

      expect(result.riskLevel, 'Low');
      expect(result.riskScore, lessThanOrEqualTo(25));
      expect(result.triggeredRules, isEmpty);
      expect(result.flagForDoctor, false);
      expect(result.explanation, isEmpty);
    });

    test('Case 2: Moderate Risk - Borderline Hypertension', () {
      // A 31-year-old with mildly elevated systolic and diastolic BP, 
      // and mildly elevated glucose
      final patient = PatientData(
        age: 31,
        gestationalAgeWeeks: 30,
        gravidity: 1,
        parity: 0,
        systolicBp: 134,  // Moderate: 130-139
        diastolicBp: 88,  // Moderate: 85-89
        hemoglobin: 11.4,
        bloodGlucose: 101, // Moderate for fasting: 96-125
        bloodGlucoseType: 'fasting',
        urineProtein: 'Negative',
        maternalHeartRate: 82,
        fetalHeartRate: 148,
      );

      final result = RuleEngine.calculateRisk(patient);

      expect(result.riskLevel, 'Moderate');
      expect(result.riskScore, greaterThanOrEqualTo(26));
      expect(result.riskScore, lessThanOrEqualTo(60));
      expect(result.triggeredRules.contains('SBP_MOD'), true);
      expect(result.triggeredRules.contains('DBP_MOD'), true);
      expect(result.triggeredRules.contains('GLUCOSE_MOD'), true);
      expect(result.flagForDoctor, true); // 2+ moderate flags → flag for doctor
    });

    test('Case 3: High Risk - Severe Anemia', () {
      // A 22-year-old with severe anemia (Hb < 9.0) and fluid leakage
      final patient = PatientData(
        age: 22,
        gestationalAgeWeeks: 28,
        gravidity: 1,
        parity: 0,
        systolicBp: 122,
        diastolicBp: 80,
        hemoglobin: 8.1,  // High risk: < 9.0
        bloodGlucose: 92,
        bloodGlucoseType: 'fasting',
        urineProtein: 'Negative',
        fluidLeakage: true,  // High risk symptom
        maternalHeartRate: 95,
        fetalHeartRate: 142,
      );

      final result = RuleEngine.calculateRisk(patient);

      expect(result.riskLevel, 'High');
      expect(result.riskScore, greaterThanOrEqualTo(61));
      expect(result.triggeredRules.contains('HB_HIGH'), true);
      expect(result.triggeredRules.contains('SYM_FLUID'), true);
      expect(result.flagForDoctor, true);
    });

    test('Case 4: High Risk - Pre-eclampsia Triad', () {
      // A 17-year-old (young maternal age - high risk) with:
      // - High systolic BP (≥140)
      // - Proteinuria (1+)
      // - Severe headache/blurred vision
      // This triggers the PE_TRIAD compound rule
      final patient = PatientData(
        age: 17,  // High risk: < 18
        gestationalAgeWeeks: 33,
        gravidity: 1,
        parity: 0,
        systolicBp: 142,  // High: ≥ 140
        diastolicBp: 92,  // High: ≥ 90
        hemoglobin: 10.2, // Moderate: 9.0-10.9
        bloodGlucose: 98,
        bloodGlucoseType: 'fasting',
        urineProtein: '1+',  // Moderate proteinuria
        severeHeadacheBlurredVision: true,  // High risk symptom
        maternalHeartRate: 88,
        fetalHeartRate: 155,
      );

      final result = RuleEngine.calculateRisk(patient);

      expect(result.riskLevel, 'High');
      expect(result.riskScore, greaterThanOrEqualTo(61));
      expect(result.triggeredRules.contains('AGE_HIGH'), true);
      expect(result.triggeredRules.contains('SBP_HIGH'), true);
      expect(result.triggeredRules.contains('DBP_HIGH'), true);
      expect(result.triggeredRules.contains('SYM_HEADACHE'), true);
      expect(result.triggeredRules.contains('PE_TRIAD'), true); // Compound rule fired
      expect(result.flagForDoctor, true);
    });

    test('Case 5: Moderate Risk - Gestational Diabetes Watch', () {
      // A 36-year-old (moderate age risk) with:
      // - Mildly elevated glucose (for fasting)
      // - History of prior gestational diabetes
      final patient = PatientData(
        age: 36,  // Moderate: 35-39
        gestationalAgeWeeks: 26,
        gravidity: 3,
        parity: 2,
        systolicBp: 126,
        diastolicBp: 82,
        hemoglobin: 11.6,
        bloodGlucose: 118,  // Moderate for fasting: 96-125
        bloodGlucoseType: 'fasting',
        urineProtein: 'Negative',
        priorGestationalDiabetes: true,  // Moderate risk flag
        maternalHeartRate: 76,
        fetalHeartRate: 143,
      );

      final result = RuleEngine.calculateRisk(patient);

      expect(result.riskLevel, 'Moderate');
      expect(result.riskScore, greaterThanOrEqualTo(26));
      expect(result.triggeredRules.contains('AGE_MOD'), true);
      expect(result.triggeredRules.contains('GLUCOSE_MOD'), true);
      expect(result.triggeredRules.contains('PREV_GDM'), true);
      expect(result.flagForDoctor, true); // 2+ moderate flags
    });

    // =========================================================================
    // ADDITIONAL EDGE CASE TESTS
    // =========================================================================

    test('All values null - should return Low Risk with no rules', () {
      final patient = PatientData();
      final result = RuleEngine.calculateRisk(patient);
      
      expect(result.riskLevel, 'Low');
      expect(result.riskScore, 0);
      expect(result.triggeredRules, isEmpty);
      expect(result.flagForDoctor, false);
    });

    test('Multiple high-severity flags - score capped at 100', () {
      // Triggering many high-risk rules should cap score at 100
      final patient = PatientData(
        age: 17,  // HIGH
        systolicBp: 145,  // HIGH
        diastolicBp: 92,  // HIGH
        hemoglobin: 8.0,  // HIGH
        fetalHeartRate: 105,  // HIGH (< 110)
        decreasedFetalMovement: true,  // HIGH
        vaginalBleeding: true,  // HIGH
      );

      final result = RuleEngine.calculateRisk(patient);
      
      expect(result.riskScore, lessThanOrEqualTo(100));
      expect(result.riskLevel, 'High');
    });

    test('Random glucose type uses correct thresholds', () {
      // Fasting glucose 140 would be HIGH, but random 140 is MODERATE
      final patientFasting = PatientData(
        bloodGlucose: 140,
        bloodGlucoseType: 'fasting',
      );

      final resultFasting = RuleEngine.calculateRisk(patientFasting);
      expect(resultFasting.triggeredRules.contains('GLUCOSE_HIGH'), true);

      // Same glucose, but random type
      final patientRandom = PatientData(
        bloodGlucose: 140,
        bloodGlucoseType: 'random',
      );

      final resultRandom = RuleEngine.calculateRisk(patientRandom);
      expect(resultRandom.triggeredRules.contains('GLUCOSE_MOD'), true);
    });

    test('Pre-eclampsia triad requires ALL three components', () {
      // High BP + Proteinuria but NO headache → should NOT trigger PE_TRIAD
      final patient = PatientData(
        systolicBp: 145,
        urineProtein: '2+',
        severeHeadacheBlurredVision: false,  // Missing this component
      );

      final result = RuleEngine.calculateRisk(patient);
      
      // Should have SBP_HIGH and PROTEIN_HIGH, but NOT PE_TRIAD
      expect(result.triggeredRules.contains('SBP_HIGH'), true);
      expect(result.triggeredRules.contains('PROTEIN_HIGH'), true);
      expect(result.triggeredRules.contains('PE_TRIAD'), false);
    });

    test('Multiple pregnancy (twins) triggers moderate risk', () {
      final patient = PatientData(
        age: 28,
        plurality: 'Twins',
      );

      final result = RuleEngine.calculateRisk(patient);
      
      expect(result.triggeredRules.contains('PLURALITY'), true);
      expect(result.riskLevel, 'Moderate');
    });

    test('JSON serialization round-trip', () {
      final original = PatientData(
        age: 28,
        gestationalAgeWeeks: 24,
        systolicBp: 120,
        diastolicBp: 80,
        hemoglobin: 11.5,
        bloodGlucose: 90,
        bloodGlucoseType: 'fasting',
      );

      // Convert to JSON
      final json = original.toJson();
      
      // Verify JSON contains snake_case keys
      expect(json.containsKey('gestational_age_weeks'), true);
      expect(json.containsKey('systolic_bp'), true);
      expect(json['gestational_age_weeks'], 24);

      // Convert back from JSON
      final reconstructed = PatientData.fromJson(json);
      
      // Verify round-trip worked
      expect(reconstructed.age, original.age);
      expect(reconstructed.gestationalAgeWeeks, original.gestationalAgeWeeks);
      expect(reconstructed.systolicBp, original.systolicBp);
    });

    test('Risk result JSON serialization', () {
      final patient = PatientData(
        age: 31,
        systolicBp: 134,
        diastolicBp: 88,
      );

      final result = RuleEngine.calculateRisk(patient);
      final json = result.toJson();

      // Verify output JSON structure
      expect(json.containsKey('risk_level'), true);
      expect(json.containsKey('risk_score'), true);
      expect(json.containsKey('triggered_rules'), true);
      expect(json.containsKey('explanation'), true);
      expect(json.containsKey('recommendations'), true);
      expect(json.containsKey('flag_for_doctor'), true);

      // Verify data types
      expect(json['risk_level'], isA<String>());
      expect(json['risk_score'], isA<int>());
      expect(json['triggered_rules'], isA<List>());
    });
  });
}
