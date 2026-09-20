from flask import Blueprint, current_app
from models import RiskAssessment
from services.risk_service import assess
from services.storage import get_item, list_items
from utils.responses import error, success
from utils.validation import validate_risk_payload
from .common import json_body, storage_errors

bp = Blueprint("risk", __name__)
@bp.post("/risk-assessment")
def risk_assessment():
    data = json_body()
    errors = validate_risk_payload(data)
    if errors: return error(errors[0])
    result = assess(data["patient"], data["pregnancy"], data["anc_visit"])
    result["rule_set_version"] = current_app.config.get("AI_RULE_SET_VERSION")
    result["persistence"] = "not_attempted"
    return success(result, 201)
@bp.get("/patients/<patient_id>/risk-assessments")
@storage_errors
def list_risk_assessments(patient_id): return success(list_items(RiskAssessment, patient_id=patient_id))
@bp.get("/risk-assessments/<assessment_id>")
@storage_errors
def get_risk_assessment(assessment_id):
    item = get_item(RiskAssessment, assessment_id)
    return success(item.to_dict()) if item else error("Risk assessment not found", 404)
