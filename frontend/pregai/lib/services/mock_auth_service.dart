import '../session/app_session.dart';

/// Result of a login attempt. Kept as its own type (rather than a bare
/// bool) so a future real API integration can add fields — a token, an
/// error code, etc. — without changing every call site.
class AuthResult {
  final bool success;
  final String? errorMessage;

  const AuthResult.success() : success = true, errorMessage = null;
  const AuthResult.failure(this.errorMessage) : success = false;
}

/// Local/mock authentication only — NOT a real backend.
///
/// Demo credentials:
///   ASHA / Health Worker  → username "asha",   password "1234"
///   Doctor                → username "doctor", password "1234"
///
/// To wire this up to a real API later, replace the body of [login]
/// with an HTTP/API call that returns the same [AuthResult] shape —
/// LoginScreen doesn't need to change.
class MockAuthService {
  MockAuthService._();

  static const Map<UserRole, ({String username, String password})> _demoCredentials = {
    UserRole.asha: (username: 'asha', password: '1234'),
    UserRole.doctor: (username: 'doctor', password: '1234'),
  };

  static AuthResult login({
    required String username,
    required String password,
    required UserRole mode,
  }) {
    final expected = _demoCredentials[mode];
    final matches = expected != null &&
        username.trim().toLowerCase() == expected.username &&
        password == expected.password;

    if (matches) {
      return const AuthResult.success();
    }
    return const AuthResult.failure('Invalid username, password, or selected mode.');
  }
}
