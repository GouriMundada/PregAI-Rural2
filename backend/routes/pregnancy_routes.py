from uuid import uuid4
from flask import Blueprint
from models import PregnancyRecord
from services.storage import create_item, get_item, list_items, update_item
from utils.responses import error, success
from utils.validation import validate_pregnancy
from .common import json_body, storage_errors

bp = Blueprint("pregnancies", __name__)

@bp.get("/patients/<patient_id>/pregnancies")
@storage_errors
def list_pregnancies(patient_id): return success(list_items(PregnancyRecord, patient_id=patient_id))
@bp.get("/pregnancies/<pregnancy_id>")
@storage_errors
def get_pregnancy(pregnancy_id):
    item = get_item(PregnancyRecord, pregnancy_id)
    return success(item.to_dict()) if item else error("Pregnancy record not found", 404)
@bp.post("/patients/<patient_id>/pregnancies")
@storage_errors
def create_pregnancy(patient_id):
    data = json_body()
    if data is None: return error("Request body must be a JSON object")
    errors = validate_pregnancy(data)
    if errors: return error(errors[0])
    data.update({"id": data.get("id", str(uuid4())), "patient_id": patient_id})
    return success(create_item(PregnancyRecord, data), 201)
@bp.put("/pregnancies/<pregnancy_id>")
@storage_errors
def update_pregnancy(pregnancy_id):
    data = json_body()
    if data is None: return error("Request body must be a JSON object")
    errors = validate_pregnancy(data, partial=True)
    if errors: return error(errors[0])
    item = update_item(PregnancyRecord, pregnancy_id, data)
    return success(item) if item else error("Pregnancy record not found", 404)
