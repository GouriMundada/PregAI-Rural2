"""PregAI Rural Python rule-based AI engine.

This implementation mirrors the current Flutter/Dart rule engine
so the backend and frontend use the same clinical rule behavior.
"""


MODERATE_WEIGHT = 10
HIGH_WEIGHT = 25


BASE_RECOMMENDATIONS = {
    "Low": [
        "Continue routine antenatal visits as scheduled.",
        "Maintain a balanced diet rich in iron, folic acid, and protein.",
        "Stay lightly active and get adequate rest.",
        "Return earlier if any new symptoms appear.",
    ],
    "Moderate": [
        "Schedule a follow-up visit within 1 week.",
        "Contact your ASHA worker or doctor if symptoms worsen.",
        "Avoid strenuous physical activity until reviewed.",
        "Monitor any flagged parameters closely until next visit.",
    ],
    "High": [
        "Seek in-person clinical evaluation as soon as possible.",
        "Contact your linked doctor or visit the nearest health facility today.",
        "Do not delay - this case has been flagged on the doctor dashboard.",
        "If you feel acutely unwell, go to an emergency facility immediately.",
    ],
}


SPECIFIC_RECOMMENDATIONS = {
    "SBP_HIGH": "Monitor blood pressure closely; avoid salt and stress.",
    "SBP_MOD": "Reduce salt intake and check BP at home if possible.",
    "DBP_HIGH": "High diastolic BP requires prompt clinical review.",
    "DBP_MOD": "Monitor blood pressure at home if a cuff is available.",
    "HB_HIGH": "Begin iron and folic acid supplementation as prescribed.",
    "HB_MOD": "Increase iron-rich food intake (leafy greens, lentils).",
    "GLUCOSE_HIGH": "Seek immediate assessment for gestational diabetes.",
    "GLUCOSE_MOD": "Reduce refined sugar and carbohydrate intake.",
    "PROTEIN_HIGH": "High proteinuria with elevated BP indicates pre-eclampsia risk.",
    "PROTEIN_MOD": "Mild proteinuria noted; ensure adequate hydration.",
    "PREV_PE": "Monitor BP and urine protein at every visit due to prior history.",
    "PREV_GDM": "Request a glucose screening test early in this pregnancy.",
    "PLURALITY": "Multiple pregnancies require more frequent monitoring.",
    "FHR_HIGH": "Abnormal fetal heart rate requires immediate clinical evaluation.",
    "MHR_MOD": "Unusual maternal heart rate noted; inform your doctor.",
    "SYM_DFM": "Decreased fetal movement is an emergency sign - seek care today.",
    "SYM_HEADACHE": "Severe headache or blurred vision may indicate pre-eclampsia.",
    "SYM_PAIN": "Upper abdominal pain can indicate HELLP syndrome - go to a clinic.",
    "SYM_BLEEDING": "Vaginal bleeding requires immediate evaluation.",
    "SYM_FLUID": "Fluid leakage requires immediate clinical assessment.",
    "PE_TRIAD": "Pre-eclampsia triad detected. Go to the hospital now.",
    "AGE_HIGH": "Younger or older maternal age requires closer monitoring.",
    "AGE_MOD": "Age-related risk noted; maintain regular ANC visits.",
}


def _add_rule(fired, severity, rule_id, explanation):
    fired.append(
        {
            "severity": severity,
            "rule_id": rule_id,
            "explanation": explanation,
        }
    )


def _evaluate_rules(patient):
    """Evaluate all rules using the same thresholds as the Flutter engine."""
    fired = []

    age = patient.get("age")

    # ------------------------------------------------------------------
    # DEMOGRAPHIC RULES
    # ------------------------------------------------------------------

    if age is not None:
        if age < 18 or age >= 40:
            _add_rule(
                fired,
                "high",
                "AGE_HIGH",
                f"Maternal age ({age} years) is in the high-risk band.",
            )
        elif age < 20 or age >= 35:
            _add_rule(
                fired,
                "moderate",
                "AGE_MOD",
                f"Maternal age ({age} years) is in the moderate-risk band.",
            )

    # ------------------------------------------------------------------
    # VITAL SIGNS
    # ------------------------------------------------------------------

    systolic_bp = patient.get("systolic_bp")

    if systolic_bp is not None:
        if systolic_bp >= 140:
            _add_rule(
                fired,
                "high",
                "SBP_HIGH",
                f"Systolic BP ({systolic_bp} mmHg) is at or above 140 mmHg.",
            )
        elif systolic_bp >= 130:
            _add_rule(
                fired,
                "moderate",
                "SBP_MOD",
                f"Systolic BP ({systolic_bp} mmHg) is mildly elevated (130-139).",
            )

    diastolic_bp = patient.get("diastolic_bp")

    if diastolic_bp is not None:
        if diastolic_bp >= 90:
            _add_rule(
                fired,
                "high",
                "DBP_HIGH",
                f"Diastolic BP ({diastolic_bp} mmHg) is at or above 90 mmHg.",
            )
        elif diastolic_bp >= 85:
            _add_rule(
                fired,
                "moderate",
                "DBP_MOD",
                f"Diastolic BP ({diastolic_bp} mmHg) is mildly elevated (85-89).",
            )

    maternal_heart_rate = patient.get("maternal_heart_rate")

    if maternal_heart_rate is not None:
        if maternal_heart_rate < 60 or maternal_heart_rate > 100:
            _add_rule(
                fired,
                "moderate",
                "MHR_MOD",
                f"Maternal heart rate ({maternal_heart_rate} bpm) is outside normal range.",
            )

    fetal_heart_rate = patient.get("fetal_heart_rate")

    if fetal_heart_rate is not None:
        if fetal_heart_rate < 110 or fetal_heart_rate > 160:
            _add_rule(
                fired,
                "high",
                "FHR_HIGH",
                f"Fetal heart rate ({fetal_heart_rate} bpm) is outside normal range (110-160).",
            )

    # ------------------------------------------------------------------
    # LABORATORY TESTS
    # ------------------------------------------------------------------

    hemoglobin = patient.get("hemoglobin")

    if hemoglobin is not None:
        if hemoglobin < 9.0:
            _add_rule(
                fired,
                "high",
                "HB_HIGH",
                f"Hemoglobin ({hemoglobin} g/dL) indicates severe anemia (<9.0).",
            )
        elif hemoglobin < 11.0:
            _add_rule(
                fired,
                "moderate",
                "HB_MOD",
                f"Hemoglobin ({hemoglobin} g/dL) is below normal range (9.0-10.9).",
            )

    blood_glucose = patient.get("blood_glucose")

    if blood_glucose is not None:
        glucose_type = str(
            patient.get("blood_glucose_type") or "fasting"
        ).lower()

        moderate_threshold = 96.0
        high_threshold = 126.0

        if glucose_type in ("random", "post_ogtt"):
            moderate_threshold = 140.0
            high_threshold = 200.0

        if blood_glucose >= high_threshold:
            _add_rule(
                fired,
                "high",
                "GLUCOSE_HIGH",
                (
                    f"Blood glucose ({blood_glucose} mg/dL, {glucose_type}) "
                    f"exceeds high threshold (>={int(high_threshold)})."
                ),
            )
        elif blood_glucose >= moderate_threshold:
            _add_rule(
                fired,
                "moderate",
                "GLUCOSE_MOD",
                f"Blood glucose ({blood_glucose} mg/dL, {glucose_type}) is mildly elevated.",
            )

    # ------------------------------------------------------------------
    # URINE PROTEIN
    # ------------------------------------------------------------------

    urine_protein = str(
        patient.get("urine_protein") or "Negative"
    ).lower().replace("+", "").strip()

    protein_level = 0

    if urine_protein == "1":
        protein_level = 1
    elif urine_protein in ("2", "3", "4"):
        protein_level = 2

    if protein_level >= 2:
        _add_rule(
            fired,
            "high",
            "PROTEIN_HIGH",
            (
                f"Significant proteinuria noted "
                f"({patient.get('urine_protein')}) - possible pre-eclampsia."
            ),
        )
    elif protein_level == 1:
        _add_rule(
            fired,
            "moderate",
            "PROTEIN_MOD",
            (
                f"Mild proteinuria noted "
                f"({patient.get('urine_protein')}) - requires monitoring."
            ),
        )

    # ------------------------------------------------------------------
    # OBSTETRIC HISTORY
    # ------------------------------------------------------------------

    if patient.get("prior_preeclampsia", False):
        _add_rule(
            fired,
            "moderate",
            "PREV_PE",
            "Patient has a history of pre-eclampsia - elevated recurrence risk.",
        )

    if patient.get("prior_gestational_diabetes", False):
        _add_rule(
            fired,
            "moderate",
            "PREV_GDM",
            "Patient has a history of gestational diabetes - elevated recurrence risk.",
        )

    plurality = str(patient.get("plurality") or "Singleton").lower()

    if "twin" in plurality or "multiple" in plurality:
        _add_rule(
            fired,
            "moderate",
            "PLURALITY",
            "Multiple pregnancy (twins or more) - inherently higher-risk category.",
        )

    # ------------------------------------------------------------------
    # DANGER SYMPTOMS
    # ------------------------------------------------------------------

    if patient.get("decreased_fetal_movement", False):
        _add_rule(
            fired,
            "high",
            "SYM_DFM",
            "Decreased fetal movement reported - emergency sign requiring urgent evaluation.",
        )

    if patient.get("severe_headache_blurred_vision", False):
        _add_rule(
            fired,
            "high",
            "SYM_HEADACHE",
            "Severe headache or blurred vision reported - possible pre-eclampsia warning.",
        )

    if patient.get("epigastric_ruq_pain", False):
        _add_rule(
            fired,
            "high",
            "SYM_PAIN",
            "Epigastric or right upper quadrant pain reported - possible HELLP syndrome.",
        )

    if patient.get("vaginal_bleeding", False):
        _add_rule(
            fired,
            "high",
            "SYM_BLEEDING",
            "Vaginal bleeding reported - requires immediate evaluation.",
        )

    if patient.get("fluid_leakage", False):
        _add_rule(
            fired,
            "high",
            "SYM_FLUID",
            "Fluid leakage reported - possible premature rupture of membranes.",
        )

    # ------------------------------------------------------------------
    # COMPOUND PATTERN
    # ------------------------------------------------------------------

    if (
        (systolic_bp or 0) >= 140
        and protein_level >= 1
        and patient.get("severe_headache_blurred_vision", False)
    ):
        _add_rule(
            fired,
            "high",
            "PE_TRIAD",
            "Pre-eclampsia triad pattern detected: high BP + proteinuria + headache/vision change.",
        )

    return fired


def calculate_risk(patient):
    """Calculate the final AI risk result.

    Args:
        patient: Dictionary using the AI input contract.

    Returns:
        Dictionary matching AIRiskResult.toJson().
    """

    fired_rules = _evaluate_rules(patient)

    moderate_count = sum(
        1 for rule in fired_rules if rule["severity"] == "moderate"
    )

    high_count = sum(
        1 for rule in fired_rules if rule["severity"] == "high"
    )

    score = (
        moderate_count * MODERATE_WEIGHT
        + high_count * HIGH_WEIGHT
    )

    if high_count > 0 and score < 61:
        score = 61

    if score > 100:
        score = 100

    # Mirrors the current Flutter implementation.
    if high_count > 0:
        risk_level = "High"
    elif moderate_count >= 1:
        risk_level = "Moderate"
    else:
        risk_level = "Low"

    triggered_rules = [
        rule["rule_id"]
        for rule in fired_rules
    ]

    explanations = [
        rule["explanation"]
        for rule in fired_rules
    ]

    recommendations = list(
        BASE_RECOMMENDATIONS.get(risk_level, [])
    )

    for rule in fired_rules:
        recommendation = SPECIFIC_RECOMMENDATIONS.get(
            rule["rule_id"]
        )

        if (
            recommendation is not None
            and recommendation not in recommendations
        ):
            recommendations.append(recommendation)

    flag_for_doctor = (
        high_count > 0
        or moderate_count >= 2
    )

    return {
        "risk_level": risk_level,
        "risk_score": score,
        "triggered_rules": triggered_rules,
        "explanation": explanations,
        "recommendations": recommendations,
        "flag_for_doctor": flag_for_doctor,
    }