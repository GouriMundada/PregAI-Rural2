from flask import Flask, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from config import Config
from models import db
from routes.patient_routes import bp as patient_bp
from routes.pregnancy_routes import bp as pregnancy_bp
from routes.anc_routes import bp as anc_bp
from routes.risk_routes import bp as risk_bp
from routes.report_routes import bp as report_bp
from routes.auth_routes import bp as auth_bp


def create_app(config_object=Config):
    app = Flask(__name__)
    app.config.from_object(config_object)

    origins = [origin.strip() for origin in app.config["CORS_ORIGINS"].split(",") if origin.strip()]
    CORS(app, resources={r"/api/*": {"origins": origins}})
    JWTManager(app)

    if app.config.get("DATABASE_URL"):
        db.init_app(app)

    for blueprint in (patient_bp, pregnancy_bp, anc_bp, risk_bp, report_bp, auth_bp):
        app.register_blueprint(blueprint, url_prefix="/api")

    @app.get("/")
    def home(): return jsonify({"status": "success", "data": {"message": "PregAI-Rural Backend is running"}})

    @app.get("/api/health")
    def health():
        return jsonify({"status": "success", "data": {"message": "Backend is healthy", "database_configured": bool(app.config.get("DATABASE_URL")), "ai_rule_set_version": app.config.get("AI_RULE_SET_VERSION")}})

    @app.errorhandler(404)
    def not_found(_error): return jsonify({"status": "error", "message": "Resource not found"}), 404
    @app.errorhandler(500)
    def unexpected_error(_error): return jsonify({"status": "error", "message": "An unexpected server error occurred"}), 500
    return app


app = create_app()

if __name__ == "__main__":
    app.run(debug=False)
