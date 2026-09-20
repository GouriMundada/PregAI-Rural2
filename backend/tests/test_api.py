import sys
from pathlib import Path
import unittest

BACKEND = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(BACKEND))
from app import create_app
from config import TestConfig


def payload(age=26, systolic_bp=118, diastolic_bp=76, hemoglobin=12.1):
    return {
        "patient": {"name": "Test Patient", "age": age, "phone": "9999999999", "address": "Village", "preferred_language": "English"},
        "pregnancy": {"gestational_age_weeks": 24, "pregnancy_type": "singleton", "previous_preeclampsia": False, "previous_gestational_diabetes": False, "previous_c_section": False},
        "anc_visit": {"systolic_bp": systolic_bp, "diastolic_bp": diastolic_bp, "maternal_heart_rate": 78, "fetal_heart_rate": 140, "hemoglobin": hemoglobin, "blood_glucose": 88, "blood_glucose_type": "fasting", "urine_protein": "Negative", "decreased_fetal_movement": False, "severe_headache_blurred_vision": False, "epigastric_ruq_pain": False, "vaginal_bleeding": False, "fluid_leakage": False},
    }


class ApiTests(unittest.TestCase):
    def setUp(self):
        self.client = create_app(TestConfig).test_client()

    def test_health(self):
        response = self.client.get("/api/health")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json["status"], "success")

    def test_patients_requires_configured_cloud_store(self):
        response = self.client.get("/api/patients")
        self.assertEqual(response.status_code, 503)

    def test_valid_patient_is_validated_before_store_boundary(self):
        response = self.client.post("/api/patients", json=payload()["patient"])
        self.assertEqual(response.status_code, 503)

    def test_invalid_patient(self):
        response = self.client.post("/api/patients", json={"age": -1})
        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json["status"], "error")

    def test_low_risk(self):
        response = self.client.post("/api/risk-assessment", json=payload())
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.json["data"]["risk_level"], "Low")

    def test_risk_assessment_accepts_pregnancy_without_gestational_age(self):
        request_payload = payload()
        request_payload["pregnancy"] = {"gravidity": 1, "parity": 0, "pregnancy_type": "single"}
        request_payload["anc_visit"].pop("blood_glucose")
        request_payload["anc_visit"].pop("blood_glucose_type")
        request_payload["anc_visit"].pop("urine_protein")

        response = self.client.post("/api/risk-assessment", json=request_payload)

        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.json["data"]["risk_level"], "Low")

    def test_moderate_risk(self):
        response = self.client.post("/api/risk-assessment", json=payload(systolic_bp=134, diastolic_bp=88))
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.json["data"]["risk_level"], "Moderate")

    def test_high_risk(self):
        response = self.client.post("/api/risk-assessment", json=payload(hemoglobin=8.1))
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.json["data"]["risk_level"], "High")
