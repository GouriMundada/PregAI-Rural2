/// The three supported user roles.
///
/// This is intentionally a minimal role marker rather than a full
/// persisted `User` model — there is no backend/database yet, so
/// there is nothing to persist a User record to. [UserSession] below
/// plays the role of "the current User" for this demo.
enum UserRole { ashaWorker, doctor, patient }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.ashaWorker:
        return 'ASHA Worker';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.patient:
        return 'Patient';
    }
  }
}

/// Mock/local session state — NOT real authentication and NOT a
/// substitute for backend-enforced access control.
///
/// Holds who is "logged in" for this demo: their role, their demo
/// username, and — for the Patient role specifically — which
/// [Patient] record (by id) they're allowed to see. Screens and
/// routes read this to decide what to show; see [RoleGate] in
/// widgets/role_gate.dart for how routes are restricted by role.
class UserSession {
  UserSession._();

  static UserRole? currentRole;
  static String currentUserId = '';

  /// Only meaningful when [currentRole] is [UserRole.patient] — the
  /// id of the single Patient record this logged-in patient may view.
  static String? currentPatientId;

  static bool get isLoggedIn => currentRole != null;
  static bool get isAshaWorker => currentRole == UserRole.ashaWorker;
  static bool get isDoctor => currentRole == UserRole.doctor;
  static bool get isPatient => currentRole == UserRole.patient;

  static void logout() {
    currentRole = null;
    currentUserId = '';
    currentPatientId = null;
  }
}
