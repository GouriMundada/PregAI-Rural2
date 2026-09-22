# PregAI Rural — AI Rule Engine Design & Architecture
**Author:** Yati (AI Integration Lead)  
**Version:** 1.1 (Updated for AI Input Parameters v2)  
**Target Platform:** Dart / Flutter Integration & Python Backend  

---

## 1. Overview
The PregAI Rule-Based AI Engine is a deterministic clinical decision-support layer designed for high-risk maternal healthcare triage in low-resource rural settings. It evaluates maternal vitals, ANC lab parameters, obstetric history, and acute danger signs against validated clinical thresholds to produce a risk score, risk classification level, actionable clinical guidance, and doctor flag alerts.

---

## 2. Input Parameter Contract Scope (21 Parameters)
The AI engine accepts the following 21 input parameters derived from `AI_Input_Parameters_2.docx`:

1. `age` (Integer, years)
2. `gestational_age_weeks` (Integer, 0–45 weeks)
3. `gravidity` (Integer, total pregnancies)
4. `parity` (Integer, previous births)
5. `prior_preeclampsia` (Boolean, Yes/No)
6. `prior_gestational_diabetes` (Boolean, Yes/No)
7. `prior_c_section` (Boolean, Yes/No)
8. `plurality` (Categorical, Singleton / Twins+)
9. `systolic_bp` (Integer, mmHg)
10. `diastolic_bp` (Integer, mmHg)
11. `maternal_heart_rate` (Integer, bpm)
12. `fetal_heart_rate` (Integer, bpm)
13. `weight` (Float, kg)
14. `hemoglobin` (Float, g/dL)
15. `urine_protein` (Categorical, Negative/Trace/1+/2+/3+/4+)
16. `blood_glucose` (Float, mg/dL)
17. `decreased_fetal_movement` (Boolean, Yes/No)
18. `severe_headache_blurred_vision` (Boolean, Yes/No)
19. `epigastric_ruq_pain` (Boolean, Yes/No)
20. `vaginal_bleeding` (Boolean, Yes/No)
21. `fluid_leakage` (Boolean, Yes/No)

---

## 3. Risk Scoring & Escalation Algorithm

### 3.1 Rule Severity Weights
Every triggered rule assigns a severity tier with an associated score weight:
* **Moderate Risk Trigger:** +10 points
* **High Risk Trigger:** +25 points

$$\text{Raw Score} = \sum (\text{Moderate Triggers} \times 10) + (\sum \text{High Triggers} \times 25)$$
$$\text{Risk Score} = \min(\text{Raw Score}, 100)$$

### 3.2 Risk Level Classification Rules
The overall `risk_level` is determined using the following thresholds and escalation logic:

1. **High Risk (`High`)**:
   * Triggered if **$\ge 1$ High Severity rule** fires, **OR**
   * Total `risk_score` $\ge 61$.
2. **Moderate Risk (`Moderate`)**:
   * Triggered if **$\ge 2$ Moderate Severity rules** fire (*2+ Escalation Rule*), **OR**
   * Total `risk_score` $\ge 26$.
3. **Low Risk (`Low`)**:
   * Default category when no high severity rules fire, $<2$ moderate severity rules fire, and `risk_score` $< 26$.

---

## 4. Clinical Rule Specifications

| Parameter Field Name | Threshold / Condition | Severity | Trigger ID | Explanation |
| :--- | :--- | :--- | :--- | :--- |
| `age` | $<18$ or $\ge 40$ years | High | `AGE_HIGH` | Maternal age is in the high-risk band. |
| `age` | $18-19$ or $35-39$ years | Moderate | `AGE_MOD` | Maternal age is in the moderate-risk band. |
| `systolic_bp` | $\ge 140$ mmHg | High | `SBP_HIGH` | Systolic BP is at or above 140 mmHg. |
| `systolic_bp` | $130-139$ mmHg | Moderate | `SBP_MOD` | Systolic BP is mildly elevated. |
| `diastolic_bp` | $\ge 90$ mmHg | High | `DBP_HIGH` | Diastolic BP is at or above 90 mmHg. |
| `diastolic_bp` | $85-89$ mmHg | Moderate | `DBP_MOD` | Diastolic BP is mildly elevated. |
| `hemoglobin` | $< 9.0$ g/dL | High | `HB_HIGH` | Critically low hemoglobin — severe anemia. |
| `hemoglobin` | $9.0 - 10.9$ g/dL | Moderate | `HB_MOD` | Mild to moderate anemia. |
| `blood_glucose` | Fasting $\ge 126$ / Random $\ge 200$ mg/dL | High | `GLUCOSE_HIGH` | Above high-risk threshold — possible GDM. |
| `blood_glucose` | Fasting $\ge 96$ / Random $\ge 140$ mg/dL | Moderate | `GLUCOSE_MOD` | Mildly elevated blood glucose. |
| `urine_protein` | $2+$, $3+$, or $4+$ | High | `PROTEIN_HIGH` | Significant proteinuria, possible pre-eclampsia. |
| `urine_protein` | $1+$ | Moderate | `PROTEIN_MOD` | Mild proteinuria, requires monitoring. |
| `prior_preeclampsia` | `true` | Moderate | `PREV_PE` | History of pre-eclampsia in prior pregnancy. |
| `prior_gestational_diabetes`| `true` | Moderate | `PREV_GDM` | History of gestational diabetes. |
| `prior_c_section` | `true` | Informational | `PREV_CS` | Prior C-section documented. |
| `plurality` | `Twins+` | Moderate | `PLURALITY` | Multiple pregnancy higher risk category. |
| `fetal_heart_rate` | $<110$ or $>160$ bpm | High | `FHR_HIGH` | Fetal heart rate outside normal range. |
| `maternal_heart_rate` | $<60$ or $>100$ bpm | Moderate | `MHR_MOD` | Maternal heart rate outside normal range. |
| `decreased_fetal_movement` | `true` | High | `SYM_DFM` | Decreased fetal movement reported. |
| `severe_headache_blurred_vision`| `true` | High | `SYM_HEADACHE` | Severe headache or blurred vision reported. |
| `epigastric_ruq_pain` | `true` | High | `SYM_PAIN` | Upper abdominal pain reported. |
| `vaginal_bleeding` | `true` | High | `SYM_BLEEDING` | Vaginal bleeding reported. |
| `fluid_leakage` | `true` | High | `SYM_FLUID` | Fluid leakage reported. |
| **Compound Pattern** | High BP + Proteinuria + Headache | High | `PE_TRIAD` | Pre-eclampsia triad detected. |

---

## 5. Doctor Dashboard Flagging Logic
The boolean flag `flag_for_doctor` is set to `true` whenever:
* `risk_level == 'High'`, **OR**
* `moderate_count >= 2` (escalated moderate cases requiring clinical review).
