"""
PregAI Rural — AI Engine: Tests
---------------------------------
Author : Yati (AI Integration Lead)
Purpose: Validate the rule engine against the 5 sample cases
         defined in the Week 1 AI Rule Document.
Run    : python -m pytest ai_engine/test_engine.py -v
         OR: python ai_engine/test_engine.py
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from ai_engine.scorer import calculate_risk


# ---------------------------------------------------------------------------
# SAMPLE CASES  (from Week 1 report)
# ---------------------------------------------------------------------------

CASES = [
    {
        "label": "Case 1 — Low Risk, routine checkup",
        "input": {
            "age": 26,
            "gestational_age_weeks": 24,
            "systolic_bp": 118,
            "diastolic_bp": 76,
            "hemoglobin": 12.1,
            "blood_glucose_value": 88,
            "blood_glucose_type": "fasting",
            "urine_protein": "Negative",
            "prior_preeclampsia": False,
            "prior_gestational_diabetes": False,
            "prior_c_section": False,
            "plurality": "Singleton",
            "decreased_fetal_movement": False,
            "severe_headache_blurred_vision": False,
            "epigastric_ruq_pain": False,
            "vaginal_bleeding": False,
            "fluid_leakage": False,
        },
        "expected_risk_level": "Low",
    },
    {
        "label": "Case 2 — Moderate Risk, borderline hypertension",
        "input": {
            "age": 31,
            "gestational_age_weeks": 30,
            "systolic_bp": 134,
            "diastolic_bp": 88,
            "hemoglobin": 11.4,
            "blood_glucose_value": 101,
            "blood_glucose_type": "fasting",
            "urine_protein": "Negative",
            "prior_preeclampsia": False,
            "prior_gestational_diabetes": False,
            "plurality": "Singleton",
            "decreased_fetal_movement": False,
            "severe_headache_blurred_vision": False,
            "epigastric_ruq_pain": False,
            "vaginal_bleeding": False,
            "fluid_leakage": False,
        },
        "expected_risk_level": "Moderate",
    },
    {
        "label": "Case 3 — High Risk, severe anemia",
        "input": {
            "age": 22,
            "gestational_age_weeks": 28,
            "systolic_bp": 122,
            "diastolic_bp": 80,
            "hemoglobin": 8.1,
            "blood_glucose_value": 92,
            "blood_glucose_type": "fasting",
            "urine_protein": "Negative",
            "plurality": "Singleton",
            "decreased_fetal_movement": False,
            "severe_headache_blurred_vision": False,
            "epigastric_ruq_pain": False,
            "vaginal_bleeding": False,
            "fluid_leakage": True,
        },
        "expected_risk_level": "High",
    },
    {
        "label": "Case 4 — High Risk, adolescent + high BP + headache",
        "input": {
            "age": 17,
            "gestational_age_weeks": 33,
            "systolic_bp": 142,
            "diastolic_bp": 92,
            "hemoglobin": 10.2,
            "blood_glucose_value": 98,
            "blood_glucose_type": "fasting",
            "urine_protein": "1+",
            "plurality": "Singleton",
            "decreased_fetal_movement": False,
            "severe_headache_blurred_vision": True,
            "epigastric_ruq_pain": False,
            "vaginal_bleeding": False,
            "fluid_leakage": False,
        },
        "expected_risk_level": "High",
    },
    {
        "label": "Case 5 — Moderate Risk, gestational diabetes watch",
        "input": {
            "age": 36,
            "gestational_age_weeks": 26,
            "systolic_bp": 126,
            "diastolic_bp": 82,
            "hemoglobin": 11.6,
            "blood_glucose_value": 118,
            "blood_glucose_type": "fasting",
            "urine_protein": "Negative",
            "prior_gestational_diabetes": True,
            "plurality": "Singleton",
            "decreased_fetal_movement": False,
            "severe_headache_blurred_vision": False,
            "epigastric_ruq_pain": False,
            "vaginal_bleeding": False,
            "fluid_leakage": False,
        },
        "expected_risk_level": "Moderate",
    },
]


# ---------------------------------------------------------------------------
# RUNNER
# ---------------------------------------------------------------------------

def run_tests():
    passed = 0
    failed = 0

    print("\n" + "=" * 60)
    print("  PregAI Rural — AI Engine Test Suite")
    print("=" * 60)

    for case in CASES:
        result = calculate_risk(case["input"])
        ok = result["risk_level"] == case["expected_risk_level"]

        status = "✓ PASS" if ok else "✗ FAIL"
        if ok:
            passed += 1
        else:
            failed += 1

        print(f"\n{status}  {case['label']}")
        print(f"  Expected : {case['expected_risk_level']}")
        print(f"  Got      : {result['risk_level']}  (score: {result['risk_score']})")
        print(f"  Rules    : {result['triggered_rules']}")
        print(f"  Flagged  : {result['flag_for_doctor']}")

        if not ok:
            print(f"  Explanation: {result['explanation']}")

    print("\n" + "=" * 60)
    print(f"  Results: {passed} passed, {failed} failed out of {len(CASES)} cases")
    print("=" * 60 + "\n")

    return failed == 0


if __name__ == "__main__":
    success = run_tests()
    sys.exit(0 if success else 1)
