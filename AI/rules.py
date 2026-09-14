"""
PregAI Rural — AI Engine: Risk Rules
--------------------------------------
Author : Yati (AI Integration Lead)
Purpose: Define all clinical threshold rules used for risk classification.
         Every rule here maps directly to a row in the Week 1 AI Rule Document.

Rule structure:
    Each rule is a function that receives the patient data dict and returns:
        - None  → rule did not fire (parameter is normal)
        - ("moderate", "rule_id", "explanation text")  → moderate risk
        - ("high",     "rule_id", "explanation text")  → high risk
"""

# ---------------------------------------------------------------------------
# WEIGHTS  (used by scorer.py)
# ---------------------------------------------------------------------------
WEIGHT = {
    "moderate": 10,
    "high":     25,
}

# ---------------------------------------------------------------------------
# INDIVIDUAL RULES
# ---------------------------------------------------------------------------

def rule_age(data):
    age = data.get("age")
    if age is None:
        return None
    if age < 18 or age >= 40:
        return ("high", "AGE_HIGH",
                f"Maternal age ({age} years) is in the high-risk band "
                f"({'under 18' if age < 18 else '40 or older'}).")
    if age < 20 or age >= 35:
        return ("moderate", "AGE_MOD",
                f"Maternal age ({age} years) is in the moderate-risk band.")
    return None


def rule_systolic_bp(data):
    sbp = data.get("systolic_bp")
    if sbp is None:
        return None
    if sbp >= 140:
        return ("high", "SBP_HIGH",
                f"Systolic BP ({sbp} mmHg) is at or above 140 mmHg — high-risk threshold.")
    if sbp >= 130:
        return ("moderate", "SBP_MOD",
                f"Systolic BP ({sbp} mmHg) is mildly elevated (130–139 mmHg).")
    return None


def rule_diastolic_bp(data):
    dbp = data.get("diastolic_bp")
    if dbp is None:
        return None
    if dbp >= 90:
        return ("high", "DBP_HIGH",
                f"Diastolic BP ({dbp} mmHg) is at or above 90 mmHg — high-risk threshold.")
    if dbp >= 85:
        return ("moderate", "DBP_MOD",
                f"Diastolic BP ({dbp} mmHg) is mildly elevated (85–89 mmHg).")
    return None


def rule_hemoglobin(data):
    hb = data.get("hemoglobin")
    if hb is None:
        return None
    if hb < 9.0:
        return ("high", "HB_HIGH",
                f"Hemoglobin ({hb} g/dL) is critically low — severe anemia.")
    if hb < 11.0:
        return ("moderate", "HB_MOD",
                f"Hemoglobin ({hb} g/dL) is below the normal threshold — mild to moderate anemia.")
    return None


def rule_blood_glucose(data):
    glucose = data.get("blood_glucose_value")
    g_type  = data.get("blood_glucose_type", "fasting").lower()
    if glucose is None:
        return None

    # Thresholds differ by measurement type
    thresholds = {
        "fasting":  (96, 126),   # normal < 96, moderate 96-125, high ≥ 126
        "random":   (140, 200),  # normal < 140, moderate 140-199, high ≥ 200
        "post_ogtt":(140, 200),  # same as random for screening
    }
    mod_thresh, high_thresh = thresholds.get(g_type, thresholds["fasting"])

    if glucose >= high_thresh:
        return ("high", "GLUCOSE_HIGH",
                f"Blood glucose ({glucose} mg/dL, {g_type}) is above the high-risk threshold "
                f"— possible gestational diabetes.")
    if glucose >= mod_thresh:
        return ("moderate", "GLUCOSE_MOD",
                f"Blood glucose ({glucose} mg/dL, {g_type}) is mildly elevated.")
    return None


def rule_urine_protein(data):
    protein = data.get("urine_protein", "negative").lower().replace("+", "").strip()
    mapping = {"negative": 0, "trace": 0, "1": 1, "2": 2, "3": 3, "4": 4}
    level = mapping.get(protein, 0)
    if level >= 2:
        return ("high", "PROTEIN_HIGH",
                f"Urine protein is {data.get('urine_protein')} — significant proteinuria, "
                f"possible pre-eclampsia.")
    if level == 1:
        return ("moderate", "PROTEIN_MOD",
                f"Urine protein is 1+ — mild proteinuria, requires monitoring.")
    return None


def rule_prior_preeclampsia(data):
    if data.get("prior_preeclampsia"):
        return ("moderate", "PREV_PE",
                "Patient has a history of pre-eclampsia in a previous pregnancy — "
                "elevated risk for recurrence.")
    return None


def rule_prior_gestational_diabetes(data):
    if data.get("prior_gestational_diabetes"):
        return ("moderate", "PREV_GDM",
                "Patient has a history of gestational diabetes — "
                "increased risk of recurrence this pregnancy.")
    return None


def rule_plurality(data):
    plurality = (data.get("plurality") or "singleton").lower()
    if "twin" in plurality or "multiple" in plurality:
        return ("moderate", "PLURALITY",
                "Multiple pregnancy (twins or more) — inherently higher risk category.")
    return None


def rule_fetal_heart_rate(data):
    fhr = data.get("fetal_heart_rate")
    if fhr is None:
        return None
    if fhr < 110 or fhr > 160:
        return ("high", "FHR_HIGH",
                f"Fetal heart rate ({fhr} bpm) is outside the normal range (110–160 bpm).")
    return None


def rule_maternal_heart_rate(data):
    mhr = data.get("maternal_heart_rate")
    if mhr is None:
        return None
    if mhr > 100 or mhr < 60:
        return ("moderate", "MHR_MOD",
                f"Maternal heart rate ({mhr} bpm) is outside the normal range (60–100 bpm).")
    return None


# ---------------------------------------------------------------------------
# SYMPTOM RULES  — individual danger flags
# ---------------------------------------------------------------------------

def rule_decreased_fetal_movement(data):
    if data.get("decreased_fetal_movement"):
        return ("high", "SYM_DFM",
                "Decreased fetal movement reported — requires urgent evaluation.")
    return None


def rule_severe_headache_blurred_vision(data):
    if data.get("severe_headache_blurred_vision"):
        return ("high", "SYM_HEADACHE",
                "Severe headache / blurred vision reported — possible pre-eclampsia warning sign.")
    return None


def rule_epigastric_ruq_pain(data):
    if data.get("epigastric_ruq_pain"):
        return ("high", "SYM_PAIN",
                "Epigastric / right upper quadrant pain reported — possible HELLP syndrome or "
                "liver involvement.")
    return None


def rule_vaginal_bleeding(data):
    if data.get("vaginal_bleeding"):
        return ("high", "SYM_BLEEDING",
                "Vaginal bleeding reported — requires immediate clinical evaluation.")
    return None


def rule_fluid_leakage(data):
    if data.get("fluid_leakage"):
        return ("high", "SYM_FLUID",
                "Fluid leakage reported — possible premature rupture of membranes.")
    return None


# ---------------------------------------------------------------------------
# COMPOUND / PATTERN RULES
# ---------------------------------------------------------------------------

def rule_preeclampsia_triad(data):
    """
    Classic pre-eclampsia pattern:
    High BP + proteinuria + headache/blurred vision → flag urgently
    even if each individual rule is only moderate.
    """
    sbp      = data.get("systolic_bp", 0)
    dbp      = data.get("diastolic_bp", 0)
    protein  = data.get("urine_protein", "negative").lower().replace("+", "").strip()
    headache = data.get("severe_headache_blurred_vision", False)
    protein_level = {"negative": 0, "trace": 0, "1": 1, "2": 2, "3": 3, "4": 4}.get(protein, 0)

    if sbp >= 140 and protein_level >= 1 and headache:
        return ("high", "PE_TRIAD",
                "Pre-eclampsia triad detected: high BP + proteinuria + severe headache/blurred vision.")
    return None


# ---------------------------------------------------------------------------
# MASTER RULE LIST  (order matters — compound rules run last)
# ---------------------------------------------------------------------------

ALL_RULES = [
    rule_age,
    rule_systolic_bp,
    rule_diastolic_bp,
    rule_hemoglobin,
    rule_blood_glucose,
    rule_urine_protein,
    rule_prior_preeclampsia,
    rule_prior_gestational_diabetes,
    rule_plurality,
    rule_fetal_heart_rate,
    rule_maternal_heart_rate,
    rule_decreased_fetal_movement,
    rule_severe_headache_blurred_vision,
    rule_epigastric_ruq_pain,
    rule_vaginal_bleeding,
    rule_fluid_leakage,
    rule_preeclampsia_triad,   # compound — always last
]
