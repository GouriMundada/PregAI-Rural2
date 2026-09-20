"""Thin cloud-store adapter. It deliberately has no SQLite or memory fallback."""
from datetime import date, datetime, timezone
from flask import current_app
from sqlalchemy.exc import SQLAlchemyError
from models import db


class StorageUnavailable(Exception):
    pass


def require_store():
    if not current_app.config.get("DATABASE_URL"):
        raise StorageUnavailable("Cloud database is not configured. Set DATABASE_URL after Supabase PostgreSQL is available.")


def normalize_for_model(model, data):
    values = {key: value for key, value in data.items() if key in model.__table__.columns}
    for key, column in model.__table__.columns.items():
        if key not in values or values[key] is None:
            continue
        if column.type.python_type is date and isinstance(values[key], str):
            values[key] = date.fromisoformat(values[key])
    return values


def list_items(model, **filters):
    require_store()
    try:
        return [item.to_dict() for item in model.query.filter_by(**filters).all()]
    except SQLAlchemyError as exc:
        raise StorageUnavailable("Cloud database is unavailable.") from exc


def get_item(model, item_id):
    require_store()
    try:
        return model.query.get(item_id)
    except SQLAlchemyError as exc:
        raise StorageUnavailable("Cloud database is unavailable.") from exc


def create_item(model, data):
    require_store()
    try:
        now = datetime.now(timezone.utc)
        values = normalize_for_model(model, data)
        values.setdefault("created_at", now)
        values.setdefault("updated_at", now)
        item = model(**values)
        db.session.add(item)
        db.session.commit()
        return item.to_dict()
    except (SQLAlchemyError, ValueError) as exc:
        db.session.rollback()
        raise StorageUnavailable("Cloud database is unavailable or rejected the supplied data.") from exc


def update_item(model, item_id, data):
    item = get_item(model, item_id)
    if item is None:
        return None
    try:
        for key, value in normalize_for_model(model, data).items():
            if key not in {"id", "created_at"}:
                setattr(item, key, value)
        item.updated_at = datetime.now(timezone.utc)
        db.session.commit()
        return item.to_dict()
    except (SQLAlchemyError, ValueError) as exc:
        db.session.rollback()
        raise StorageUnavailable("Cloud database is unavailable or rejected the supplied data.") from exc


def delete_item(model, item_id):
    item = get_item(model, item_id)
    if item is None:
        return False
    try:
        db.session.delete(item)
        db.session.commit()
        return True
    except SQLAlchemyError as exc:
        db.session.rollback()
        raise StorageUnavailable("Cloud database is unavailable.") from exc
