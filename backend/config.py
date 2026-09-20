"""Runtime configuration; secrets are supplied only through environment variables."""
import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    SECRET_KEY = os.getenv("SECRET_KEY")
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")
    DATABASE_URL = os.getenv("DATABASE_URL")
    SQLALCHEMY_DATABASE_URI = DATABASE_URL
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    AI_RULE_SET_VERSION = os.getenv("AI_RULE_SET_VERSION")
    CORS_ORIGINS = os.getenv("CORS_ORIGINS", "http://localhost,http://127.0.0.1")


class TestConfig(Config):
    TESTING = True
