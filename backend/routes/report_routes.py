from flask import Blueprint
from models import AncVisit, Patient, PregnancyRecord, RiskAssessment
from services.storage import get_item, list_items
from utils.responses import error, success
from .common import storage_errors

bp = Blueprint("reports", __name__)
@bp.get("/patients/<patient_id>/report")
@storage_errors
def patient_report(patient_id):
    patient = get_item(Patient, patient_id)
    if patient is None: return error("Patient not found", 404)
    pregnancies = list_items(PregnancyRecord, patient_id=patient_id)
    visits = [visit for pregnancy in pregnancies for visit in list_items(AncVisit, pregnancy_id=pregnancy["id"])]
    return success({"patient": patient.to_dict(), "pregnancies": pregnancies, "anc_visits": visits, "risk_assessments": list_items(RiskAssessment, patient_id=patient_id)})
