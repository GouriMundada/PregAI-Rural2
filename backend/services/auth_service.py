"""Authentication boundary. No user store exists in the current schema.

JWT is initialized by the app, but token issuance is intentionally deferred
until the database/auth team supplies an approved user identity source.
"""
class AuthService:
    def authenticate(self, *_args, **_kwargs):
        raise NotImplementedError("Authentication is pending an approved user/auth data source.")
