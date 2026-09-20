from functools import wraps
from flask import request
from services.storage import StorageUnavailable
from utils.responses import error


def json_body():
    data = request.get_json(silent=True)
    return data if isinstance(data, dict) else None


def storage_errors(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        try:
            return view(*args, **kwargs)
        except StorageUnavailable as exc:
            return error(str(exc), 503)
    return wrapped
