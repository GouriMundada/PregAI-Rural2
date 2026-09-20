"""Structural validation only; clinical threshold assessment belongs to AI/."""
from numbers import Real

BOOLEAN_FIELDS = {"previous_preeclampsia", "previous_gestational_diabetes", "previous_c_section", "decreased_fetal_movement", "severe_headache_blurred_vision", "epigastric_ruq_pain", "vaginal_bleeding", "fluid_leakage"}
GLUCOSE_TYPES = {"fasting", "random", "post_ogtt"}
URINE_PROTEIN_VALUES = {"negative", "trace", "1+", "2+", "3+", "4+"}


def _number(value):
    return isinstance(value, Real) and not isinstance(value, bool)


def validate_patient(data, partial=False):
    errors = []
    for field in ("name", "age", "phone", "address", "preferred_language"):
        if not partial and (field not in data or data[field] in (None, "")):
            errors.append(f"{field.replace('_', ' ').capitalize()} is required")
    if "age" in data and (not isinstance(data["age"], int) or isinstance(data["age"], bool) or data["age"] <= 0): errors.append("Age must be a positive whole number")
    if "phone" in data and (not isinstance(data["phone"], str) or not data["phone"].strip()): errors.append("Phone must be a non-empty string")
    return errors


def validate_pregnancy(data, partial=False):
    errors = []
    if not partial and "gestational_age_weeks" not in data: errors.append("Gestational age weeks is required")
    if "gestational_age_weeks" in data and (not isinstance(data["gestational_age_weeks"], int) or isinstance(data["gestational_age_weeks"], bool) or data["gestational_age_weeks"] < 0): errors.append("Gestational age weeks must be a non-negative whole number")
    for field in ("previous_preeclampsia", "previous_gestational_diabetes", "previous_c_section"):
        if field in data and not isinstance(data[field], bool): errors.append(f"{field.replace('_', ' ')} must be a boolean")
    return errors


def validate_anc(data, partial=False):
    errors = []
    for field in ("systolic_bp", "diastolic_bp"):
        if not partial and field not in data: errors.append(f"{field.replace('_', ' ').capitalize()} is required")
        if field in data and not _number(data[field]): errors.append(f"{field.replace('_', ' ').capitalize()} must be numeric")
    for field in ("maternal_heart_rate", "fetal_heart_rate", "hemoglobin", "blood_glucose"):
        if field in data and data[field] is not None and not _number(data[field]): errors.append(f"{field.replace('_', ' ').capitalize()} must be numeric when supplied")
    if data.get("blood_glucose") is not None and data.get("blood_glucose_type") not in GLUCOSE_TYPES: errors.append("blood_glucose_type must be fasting, random, or post_ogtt when blood_glucose is provided")
    if "urine_protein" in data and str(data["urine_protein"]).lower() not in URINE_PROTEIN_VALUES: errors.append("urine_protein must be Negative, Trace, 1+, 2+, 3+, or 4+")
    for field in BOOLEAN_FIELDS - {"previous_preeclampsia", "previous_gestational_diabetes", "previous_c_section"}:
        if field in data and not isinstance(data[field], bool): errors.append(f"{field.replace('_', ' ')} must be a boolean")
    return errors


def validate_risk_payload(data):
    if not isinstance(data, dict): return ["Request body must be a JSON object"]
    patient, pregnancy, anc_visit = data.get("patient"), data.get("pregnancy"), data.get("anc_visit")
    if not all(isinstance(part, dict) for part in (patient, pregnancy, anc_visit)): return ["patient, pregnancy, and anc_visit objects are required"]
    # A standalone assessment can be made before gestational age is known.
    # The AI engine treats a missing age in weeks as unavailable data, while
    # the persisted-pregnancy endpoint continues to require it.
    return validate_patient(patient) + validate_pregnancy(pregnancy, partial=True) + validate_anc(anc_visit)
