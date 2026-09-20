# PregAI-Rural backend

Flask API layer for PregAI-Rural. It validates requests, exposes REST routes,
and adapts project data to the existing rule-based engine in `AI/`. Its risk
result is decision support, not a medical diagnosis; thresholds and advice
require clinician review before real-world deployment.

## Start

From `backend/`:

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
python app.py
```

Set real `SECRET_KEY` and `JWT_SECRET_KEY` values in `.env`. `AI_RULE_SET_VERSION`
is supplied by the AI team. Restrict `CORS_ORIGINS` to the development frontend
origins; it is not a production wildcard configuration.

`DATABASE_URL` must be the future Supabase PostgreSQL connection string (for
example `postgresql+psycopg://...`). The backend does **not** create tables,
SQLite files, a sync queue, or an in-memory substitute. Until that URL and the
Supabase tables are available, data-dependent routes return `503`; the health
and risk-assessment endpoints remain testable.

## API

| Area | Routes |
| --- | --- |
| Health | `GET /api/health` |
| Patients | `GET, POST /api/patients`; `GET, PUT, DELETE /api/patients/<id>` |
| Pregnancy | `GET, POST /api/patients/<id>/pregnancies`; `GET, PUT /api/pregnancies/<id>` |
| ANC | `GET, POST /api/pregnancies/<id>/visits`; `GET, PUT /api/anc-visits/<id>` |
| Risk | `POST /api/risk-assessment`; `GET /api/patients/<id>/risk-assessments`; `GET /api/risk-assessments/<id>` |
| Reports | `GET /api/patients/<id>/report` |

All success bodies are `{ "status": "success", "data": ... }`; errors are
`{ "status": "error", "message": "..." }`.

### Risk request

`POST /api/risk-assessment` accepts a standalone assessment and does not claim
to persist it:

```json
{
  "patient": {"name": "Asha", "age": 26, "phone": "9999999999", "address": "Village", "preferred_language": "English"},
  "pregnancy": {"gestational_age_weeks": 24, "pregnancy_type": "singleton", "previous_preeclampsia": false, "previous_gestational_diabetes": false, "previous_c_section": false},
  "anc_visit": {"systolic_bp": 118, "diastolic_bp": 76, "hemoglobin": 12.1, "blood_glucose": 88, "blood_glucose_type": "fasting", "urine_protein": "Negative", "decreased_fetal_movement": false, "severe_headache_blurred_vision": false, "epigastric_ruq_pain": false, "vaginal_bleeding": false, "fluid_leakage": false}
}
```

The response returns the unchanged AI contract: `risk_level` (`Low`,
`Moderate`, or `High`), `risk_score`, `triggered_rules`, `explanation`,
`recommendations`, and `flag_for_doctor`. `blood_glucose` is mapped to the AI
engine's `blood_glucose_value`; pregnancy history and symptom field names are
also mapped without adding rules. `Moderate` is never converted to `Medium`.

## Tests

Run from `backend/`:

```powershell
python -m unittest discover -s tests -v
```

The test suite covers health, the unavailable cloud-store boundary, patient
validation, and low/moderate/high risk cases. The existing AI test runner can
also be run from the repository root with `python AI/test_engine.py`.

## Pending dependencies

The database team must provision the documented Supabase schema and provide a
connection URL/credential delivery process. No auth/user table exists in this
repository, so JWT is configured but token issuance is deliberately pending an
approved identity store. `auth/status` reports this state.
