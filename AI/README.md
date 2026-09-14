# PregAI Rural — AI Engine

**Author:** Yati (AI Integration Lead)  
**Module:** `ai_engine/`

---

## What this module does

Takes a pregnant woman's health data as input and returns:
- A **risk level** (Low / Moderate / High)
- A **risk score** (0–100)
- A list of **triggered rules** (which parameters were out of range)
- A plain-language **explanation** of why the risk level was assigned
- **Recommendations** tailored to the risk level and triggered parameters
- A **flag_for_doctor** boolean (auto-alerts the doctor dashboard)

No ML model. No black box. Pure rule-based logic — every output traces back to a clinical threshold.

---

## File structure

```
ai_engine/
├── __init__.py          # exposes calculate_risk()
├── rules.py             # all clinical threshold rules (one function per parameter)
├── scorer.py            # runs all rules, calculates score, determines risk level
├── recommendations.py   # maps risk level + rules → actionable guidance
├── test_engine.py       # 5 sample patient test cases (from Week 1 report)
└── README.md
```

---

## Quick usage

```python
from ai_engine import calculate_risk

patient = {
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
    "prior_c_section": False,
    "plurality": "Singleton",
    "decreased_fetal_movement": False,
    "severe_headache_blurred_vision": False,
    "epigastric_ruq_pain": False,
    "vaginal_bleeding": False,
    "fluid_leakage": False,
}

result = calculate_risk(patient)
print(result["risk_level"])       # "Moderate"
print(result["risk_score"])       # 30
print(result["explanation"])      # ["Systolic BP (134 mmHg) is mildly elevated...", ...]
print(result["recommendations"])  # ["Schedule a follow-up within 1 week...", ...]
print(result["flag_for_doctor"])  # True
```

---

## Running tests

```bash
python ai_engine/test_engine.py
```

All 5 sample cases from the Week 1 AI Rule Document are validated here.

---

## How to add a new rule

1. Open `rules.py`
2. Write a new function following the pattern:
```python
def rule_my_parameter(data):
    value = data.get("my_parameter")
    if value is None:
        return None
    if value > HIGH_THRESHOLD:
        return ("high", "MY_RULE_ID", "Plain language explanation.")
    if value > MOD_THRESHOLD:
        return ("moderate", "MY_RULE_ID_MOD", "Plain language explanation.")
    return None
```
3. Add the function to `ALL_RULES` list at the bottom of `rules.py`
4. Add a recommendation string for your rule ID in `recommendations.py → SPECIFIC`
5. Add a test case in `test_engine.py`
