"""
PregAI Rural — AI Engine: Scorer
----------------------------------
Author : Yati (AI Integration Lead)
Purpose: Run all rules against patient data, calculate risk score,
         determine risk level, and assemble the final AI output.

Output contract (matches AI_Output_Parameters.docx):
    {
        "risk_level":      "Low" | "Moderate" | "High",
        "risk_score":      int (0–100),
        "triggered_rules": [str, ...],
        "explanation":     [str, ...],
        "recommendations": [str, ...],
        "flag_for_doctor": bool
    }
"""

from .rules import ALL_RULES, WEIGHT
from .recommendations import get_recommendations


def calculate_risk(patient_data: dict) -> dict:
    """
    Main entry point.
    Pass in a dict of patient inputs (matching AI_Input_Parameters.docx).
    Returns the full AI output dict.
    """

    # ------------------------------------------------------------------
    # Step 1: Run every rule and collect results
    # ------------------------------------------------------------------
    fired = []   # list of (severity, rule_id, explanation)

    for rule_fn in ALL_RULES:
        result = rule_fn(patient_data)
        if result is not None:
            fired.append(result)

    # ------------------------------------------------------------------
    # Step 2: Calculate raw score
    # ------------------------------------------------------------------
    raw_score = sum(WEIGHT[severity] for severity, _, _ in fired)
    risk_score = min(raw_score, 100)   # cap at 100

    # ------------------------------------------------------------------
    # Step 3: Determine risk level
    # Escalation rule: 2+ moderate triggers → escalate to Moderate
    # even if individual scores are low
    # ------------------------------------------------------------------
    high_count     = sum(1 for s, _, _ in fired if s == "high")
    moderate_count = sum(1 for s, _, _ in fired if s == "moderate")

    if high_count >= 1 or risk_score >= 61:
        risk_level = "High"
    elif moderate_count >= 2 or risk_score >= 26:
        risk_level = "Moderate"
    else:
        risk_level = "Low"

    # ------------------------------------------------------------------
    # Step 4: Assemble output fields
    # ------------------------------------------------------------------
    triggered_rules = [rule_id for _, rule_id, _ in fired]
    explanation     = [text   for _, _, text   in fired]
    recommendations = get_recommendations(risk_level, triggered_rules)
    flag_for_doctor = risk_level == "High" or moderate_count >= 2

    return {
        "risk_level":      risk_level,
        "risk_score":      risk_score,
        "triggered_rules": triggered_rules,
        "explanation":     explanation,
        "recommendations": recommendations,
        "flag_for_doctor": flag_for_doctor,
    }
