"""Adapter from API/database names to the AI team's existing input contract."""
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from AI import calculate_risk


def assess(patient, pregnancy, anc_visit):
    ai_input = {
        "age": patient["age"],
        "gestational_age_weeks": pregnancy.get("gestational_age_weeks"),
        "gravidity": pregnancy.get("gravidity"),
        "parity": pregnancy.get("parity"),
        "systolic_bp": anc_visit["systolic_bp"],
        "diastolic_bp": anc_visit["diastolic_bp"],
        "maternal_heart_rate": anc_visit.get("maternal_heart_rate"),
        "fetal_heart_rate": anc_visit.get("fetal_heart_rate"),
        "weight": anc_visit.get("weight"),
        "hemoglobin": anc_visit.get("hemoglobin"),
        "blood_glucose": anc_visit.get("blood_glucose"),
        # Preserve the AI engine's documented defaults when optional ANC
        # measurements are not collected for this visit.
        "blood_glucose_type": anc_visit.get("blood_glucose_type") or "fasting",
        "urine_protein": anc_visit.get("urine_protein") or "Negative",
        "prior_preeclampsia": pregnancy.get("previous_preeclampsia", False),
        "prior_gestational_diabetes": pregnancy.get("previous_gestational_diabetes", False),
        "prior_c_section": pregnancy.get("previous_c_section", False),
        "plurality": pregnancy.get("pregnancy_type", "singleton"),
    }
    for field in ("decreased_fetal_movement", "severe_headache_blurred_vision", "epigastric_ruq_pain", "vaginal_bleeding", "fluid_leakage"):
        ai_input[field] = anc_visit.get(field, False)
    return calculate_risk(ai_input)
