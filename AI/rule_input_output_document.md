# PregAI Rural — AI Engine Data Input/Output Contract
**Author:** Yati (AI Integration Lead)  
**Version:** 1.0  

---

## 1. Data Contract Overview
This document defines the strict parameter interface between the Flutter UI / Database and the AI Rule Engine.

---

## 2. Input Parameters (`PatientData`)

| Parameter | Type | Valid Values / Range | Description |
| :--- | :--- | :--- | :--- |
| `age` | `Integer` | $12 - 55$ years | Patient maternal age |
| `gestational_age_weeks` | `Integer` | $0 - 45$ weeks | Current gestational age |
| `gravidity` | `Integer` | $\ge 1$ | Total number of pregnancies |
| `parity` | `Integer` | $\ge 0$ | Total prior births |
| `prior_preeclampsia` | `Boolean` | `true` / `false` | History of pre-eclampsia |
| `prior_gestational_diabetes`| `Boolean` | `true` / `false` | History of GDM |
| `prior_c_section` | `Boolean` | `true` / `false` | History of C-section |
| `plurality` | `String` | `'Singleton'`, `'Twins+'` | Single vs multiple fetus |
| `systolic_bp` | `Integer` | $70 - 220$ mmHg | Systolic blood pressure |
| `diastolic_bp` | `Integer` | $40 - 140$ mmHg | Diastolic blood pressure |
| `maternal_heart_rate` | `Integer` | $40 - 180$ bpm | Maternal heart rate |
| `fetal_heart_rate` | `Integer` | $80 - 220$ bpm | Fetal heart rate |
| `weight` | `Float` | $30 - 150$ kg | Patient weight |
| `hemoglobin` | `Float` | $3.0 - 18.0$ g/dL | Hemoglobin concentration |
| `urine_protein` | `String` | `'Negative'`, `'Trace'`, `'1+'`, `'2+'`, `'3+'`, `'4+'` | Urine protein dipstick level |
| `blood_glucose` | `Float` | $40 - 400$ mg/dL | Blood glucose reading |
| `blood_glucose_type` | `String` | `'fasting'`, `'random'`, `'post_ogtt'` | Glucose measurement type |
| `decreased_fetal_movement` | `Boolean` | `true` / `false` | Symptom flag |
| `severe_headache_blurred_vision`| `Boolean`| `true` / `false` | Symptom flag |
| `epigastric_ruq_pain` | `Boolean` | `true` / `false` | Symptom flag |
| `vaginal_bleeding` | `Boolean` | `true` / `false` | Symptom flag |
| `fluid_leakage` | `Boolean` | `true` / `false` | Symptom flag |

---

## 3. Output Contract (`AIRiskResult`)

### 3.1 JSON Output Schema
```json
{
  "risk_level": "High",
  "risk_score": 50,
  "triggered_rules": [
    "HB_HIGH",
    "SYM_FLUID"
  ],
  "explanation": [
    "Hemoglobin (8.1 g/dL) is critically low — severe anemia.",
    "Fluid leakage reported — possible premature rupture of membranes."
  ],
  "recommendations": [
    "Seek in-person clinical evaluation as soon as possible.",
    "Contact your linked doctor or visit the nearest health facility today.",
    "Do not delay — this case has been flagged on the doctor dashboard.",
    "If you feel acutely unwell, go to an emergency facility immediately.",
    "Begin iron and folic acid supplementation as prescribed; avoid strenuous activity.",
    "Fluid leakage may mean the waters have broken — seek clinical assessment immediately."
  ],
  "flag_for_doctor": true
}
