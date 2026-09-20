from uuid import uuid4
from flask import Blueprint
from models import AncVisit, PregnancyRecord
from services.storage import create_item, get_item, list_items, update_item
from utils.responses import error, success
from utils.validation import validate_anc
from .common import json_body, storage_errors

bp = Blueprint("anc", __name__)
@bp.get("/pregnancies/<pregnancy_id>/visits")
@storage_errors
def list_visits(pregnancy_id): return success(list_items(AncVisit, pregnancy_id=pregnancy_id))
@bp.get("/anc-visits/<visit_id>")
@storage_errors
def get_visit(visit_id):
    item = get_item(AncVisit, visit_id)
    return success(item.to_dict()) if item else error("ANC visit not found", 404)
@bp.post("/pregnancies/<pregnancy_id>/visits")
@storage_errors
def create_visit(pregnancy_id):
    data = json_body()
    if data is None: return error("Request body must be a JSON object")
    errors = validate_anc(data)
    if errors: return error(errors[0])
    pregnancy = get_item(PregnancyRecord, pregnancy_id)
    if pregnancy is None: return error("Pregnancy record not found", 404)
    data.update({"id": data.get("id", str(uuid4())), "pregnancy_id": pregnancy_id, "patient_id": pregnancy.patient_id})
    return success(create_item(AncVisit, data), 201)
@bp.put("/anc-visits/<visit_id>")
@storage_errors
def update_visit(visit_id):
    data = json_body()
    if data is None: return error("Request body must be a JSON object")
    errors = validate_anc(data, partial=True)
    if errors: return error(errors[0])
    item = update_item(AncVisit, visit_id, data)
    return success(item) if item else error("ANC visit not found", 404)
