from flask import Blueprint
from utils.responses import error
bp = Blueprint("auth", __name__)
@bp.get("/auth/status")
def auth_status(): return error("Authentication is pending an approved user/auth data source.", 501)
