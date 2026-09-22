import '../session/user_session.dart';

/// Result of a login attempt. A dedicated type (rather than a bare
/// bool) so a future real API integration can add fields — a token,
/// an error code, etc. — without changing every call site.
class AuthResult {
  final bool success;
  final String? errorMessage;

  /// For a successful Patient-role login, the id of the Patient
  /// record this account is allowed to see (see UserSession).
  final String? patientId;

  const AuthResult.success({this.patientId}) : success = true, errorMessage = null;
  const AuthResult.failure(this.errorMessage) : success = false, patientId = null;
}

/// Local/mock authentication only — NOT a real backend, and NOT
/// production-secure. Anyone with the app's source can read these
/// demo credentials; real deployments need a real backend/auth
/// service enforcing this instead of the client.
///
/// DEMO credentials:
///   ASHA Worker → username "asha001",   password "asha123"
///   Doctor      → username "doctor001", password "doctor123"
///   Patient     → username "patient001", password "patient123"
///                 (linked to the existing dummy patient "P001" —
///                 Anjali Patil — so the Patient dashboard has a real
///                 record to show)
class MockAuthService {
  MockAuthService._();

  static const Map<UserRole, ({String username, String password})> _demoCredentials = {
    UserRole.ashaWorker: (username: 'asha001', password: 'asha123'),
    UserRole.doctor: (username: 'doctor001', password: 'doctor123'),
    UserRole.patient: (username: 'patient001', password: 'patient123'),
  };

  /// Maps a demo Patient-role username to the Patient record (by id)
  /// they're allowed to see. Only one demo patient account exists for
  /// now; add more entries here if additional demo patient logins are
  /// needed later.
  static const Map<String, String> _patientAccountToPatientId = {
    'patient001': 'P001',
  };

  /// Exposed so the login form can show the correct demo hint for
  /// whichever role tab is currently selected.
  static ({String username, String password}) demoCredentialsFor(UserRole role) =>
      _demoCredentials[role]!;

  static AuthResult login({
    required String username,
    required String password,
    required UserRole role,
  }) {
    final expected = _demoCredentials[role];
    final normalizedUsername = username.trim().toLowerCase();
    final matches = expected != null && normalizedUsername == expected.username && password == expected.password;

    if (!matches) {
      return const AuthResult.failure('Invalid username or password for the selected role.');
    }

    if (role == UserRole.patient) {
      final patientId = _patientAccountToPatientId[normalizedUsername];
      return AuthResult.success(patientId: patientId);
    }
    return const AuthResult.success();
  }
}
