"""
PregAI Rural — AI Engine: Recommendations
-------------------------------------------
Author : Yati (AI Integration Lead)
Purpose: Map risk level + triggered rule IDs to actionable guidance.
         Structure: base recommendations per risk level +
                    parameter-specific additions when rules fire.
"""

# ---------------------------------------------------------------------------
# BASE RECOMMENDATIONS  (always included, matched to overall risk level)
# ---------------------------------------------------------------------------

BASE = {
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
        "Do not delay — this case has been flagged on the doctor dashboard.",
        "If you feel acutely unwell, go to an emergency facility immediately.",
    ],
}

# ---------------------------------------------------------------------------
# PARAMETER-SPECIFIC RECOMMENDATIONS
# (added on top of base if the corresponding rule fires)
# ---------------------------------------------------------------------------

SPECIFIC = {
    "SBP_HIGH":    "Monitor blood pressure closely; avoid salt and stress.",
    "SBP_MOD":     "Reduce salt intake and check BP at home if possible.",
    "DBP_HIGH":    "High diastolic BP requires prompt clinical review.",
    "DBP_MOD":     "Monitor blood pressure at home if a cuff is available.",
    "HB_HIGH":     "Begin iron and folic acid supplementation as prescribed; avoid strenuous activity.",
    "HB_MOD":      "Increase iron-rich food intake (leafy greens, lentils, meat). Ask your doctor about supplements.",
    "GLUCOSE_HIGH":"Seek immediate assessment for gestational diabetes management.",
    "GLUCOSE_MOD": "Reduce refined sugar and carbohydrate intake; a glucose-tolerance test may be needed.",
    "PROTEIN_HIGH":"High proteinuria combined with elevated BP may indicate pre-eclampsia — urgent review needed.",
    "PROTEIN_MOD": "Mild proteinuria noted; ensure adequate hydration and follow up promptly.",
    "PREV_PE":     "Given prior pre-eclampsia history, monitor BP and urine protein at every visit.",
    "PREV_GDM":    "Given prior gestational diabetes, request a glucose screening test early in this pregnancy.",
    "PLURALITY":   "Multiple pregnancies require more frequent monitoring — discuss a closer ANC schedule with your doctor.",
    "FHR_HIGH":    "Abnormal fetal heart rate requires immediate clinical evaluation — do not delay.",
    "MHR_MOD":     "Unusual maternal heart rate noted; inform your doctor at the next visit.",
    "SYM_DFM":     "Decreased fetal movement is an emergency sign — seek evaluation today.",
    "SYM_HEADACHE":"Severe headache or blurred vision may indicate pre-eclampsia — seek care immediately.",
    "SYM_PAIN":    "Upper abdominal pain in pregnancy can indicate a serious condition — go to a clinic today.",
    "SYM_BLEEDING":"Vaginal bleeding requires immediate evaluation — go to the nearest health facility now.",
    "SYM_FLUID":   "Fluid leakage may mean the waters have broken — seek clinical assessment immediately.",
    "PE_TRIAD":    "Multiple signs of pre-eclampsia detected. This is an emergency — go to hospital now.",
    "AGE_HIGH":    "Younger or older maternal age increases pregnancy risk; closer monitoring is essential.",
    "AGE_MOD":     "Age-related risk noted; maintain regular ANC visits.",
}


def get_recommendations(risk_level: str, triggered_rules: list) -> list:
    """
    Combine base recommendations (for the risk level) with
    specific recommendations for each triggered rule.
    Returns a deduplicated, ordered list of strings.
    """
    result = list(BASE.get(risk_level, []))

    for rule_id in triggered_rules:
        specific = SPECIFIC.get(rule_id)
        if specific and specific not in result:
            result.append(specific)

    return result
