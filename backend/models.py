"""ORM mappings for the existing cloud schema.

These mappings never call create_all(): schema ownership remains with the
database/Supabase team. They are used only when DATABASE_URL is configured.
"""
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class SerializableMixin:
    def to_dict(self):
        result = {}
        for column in self.__table__.columns:
            value = getattr(self, column.name)
            result[column.name] = value.isoformat() if hasattr(value, "isoformat") else value
        return result


class Patient(SerializableMixin, db.Model):
    __tablename__ = "patients"
    id = db.Column(db.Text, primary_key=True)
    name = db.Column(db.Text, nullable=False)
    age = db.Column(db.Integer, nullable=False)
    phone = db.Column(db.Text, nullable=False)
    address = db.Column(db.Text, nullable=False)
    preferred_language = db.Column(db.Text, nullable=False)
    emergency_contact_name = db.Column(db.Text)
    emergency_contact_phone = db.Column(db.Text)
    emergency_contact_relationship = db.Column(db.Text)
    notes = db.Column(db.Text)
    created_at = db.Column(db.DateTime)
    updated_at = db.Column(db.DateTime)
    sync_status = db.Column(db.Text)


class PregnancyRecord(SerializableMixin, db.Model):
    __tablename__ = "pregnancy_records"
    id = db.Column(db.Text, primary_key=True)
    patient_id = db.Column(db.Text, nullable=False)
    lmp = db.Column(db.Date)
    gestational_age_weeks = db.Column(db.Integer)
    edd = db.Column(db.Date)
    gravidity = db.Column(db.Integer)
    parity = db.Column(db.Integer)
    pregnancy_type = db.Column(db.Text)
    previous_preeclampsia = db.Column(db.Integer)
    previous_gestational_diabetes = db.Column(db.Integer)
    previous_c_section = db.Column(db.Integer)
    created_at = db.Column(db.DateTime)
    updated_at = db.Column(db.DateTime)
    sync_status = db.Column(db.Text)


class AncVisit(SerializableMixin, db.Model):
    __tablename__ = "anc_visits"
    id = db.Column(db.Text, primary_key=True)
    patient_id = db.Column(db.Text, nullable=False)
    pregnancy_id = db.Column(db.Text, nullable=False)
    visit_date = db.Column(db.Date)
    visit_number = db.Column(db.Integer)
    gestational_age_weeks = db.Column(db.Integer)
    systolic_bp = db.Column(db.Integer)
    diastolic_bp = db.Column(db.Integer)
    maternal_heart_rate = db.Column(db.Integer)
    fetal_heart_rate = db.Column(db.Integer)
    weight = db.Column(db.Float)
    temperature = db.Column(db.Float)
    hemoglobin = db.Column(db.Float)
    urine_protein = db.Column(db.Text)
    blood_glucose = db.Column(db.Float)
    blood_glucose_type = db.Column(db.Text)
    symptoms = db.Column(db.Text)
    decreased_fetal_movement = db.Column(db.Integer)
    severe_headache_blurred_vision = db.Column(db.Integer)
    epigastric_ruq_pain = db.Column(db.Integer)
    vaginal_bleeding = db.Column(db.Integer)
    fluid_leakage = db.Column(db.Integer)
    created_at = db.Column(db.DateTime)
    updated_at = db.Column(db.DateTime)
    sync_status = db.Column(db.Text)


class RiskAssessment(SerializableMixin, db.Model):
    __tablename__ = "risk_assessments"
    id = db.Column(db.Text, primary_key=True)
    patient_id = db.Column(db.Text)
    pregnancy_id = db.Column(db.Text)
    anc_visit_id = db.Column(db.Text)
    risk_level = db.Column(db.Text)
    risk_reason = db.Column(db.Text)
    recommendation = db.Column(db.Text)
    rule_set_version = db.Column(db.Text)
    rules_applied = db.Column(db.Text)
    assessed_at = db.Column(db.DateTime)
    created_at = db.Column(db.DateTime)
    updated_at = db.Column(db.DateTime)
    sync_status = db.Column(db.Text)
