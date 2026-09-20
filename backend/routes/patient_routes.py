from uuid import uuid4
from flask import Blueprint
from models import Patient
from services.storage import create_item, delete_item, get_item, list_items, update_item
from utils.responses import error, success
from utils.validation import validate_patient
from .common import json_body, storage_errors

bp = Blueprint("patients", __name__)

@bp.get("/patients")
@storage_errors
def list_patients(): return success(list_items(Patient))

@bp.get("/patients/<patient_id>")
@storage_errors
def get_patient(patient_id):
    item = get_item(Patient, patient_id)
    return success(item.to_dict()) if item else error("Patient not found", 404)

@bp.post("/patients")
@storage_errors
def create_patient():
    data = json_body()
    if data is None: return error("Request body must be a JSON object")
    errors = validate_patient(data)
    if errors: return error(errors[0])
    data.setdefault("id", str(uuid4()))
    return success(create_item(Patient, data), 201)

@bp.put("/patients/<patient_id>")
@storage_errors
def update_patient(patient_id):
    data = json_body()
    if data is None: return error("Request body must be a JSON object")
    errors = validate_patient(data, partial=True)
    if errors: return error(errors[0])
    item = update_item(Patient, patient_id, data)
    return success(item) if item else error("Patient not found", 404)

@bp.delete("/patients/<patient_id>")
@storage_errors
def remove_patient(patient_id):
    return ("", 204) if delete_item(Patient, patient_id) else error("Patient not found", 404)
