/// The three supported user modes, per the login/role-select flow.
enum UserRole { asha, doctor, patient }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.asha:
        return 'ASHA / Health Worker';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.patient:
        return 'Patient';
    }
  }

  String get shortLabel {
    switch (this) {
      case UserRole.asha:
        return 'ASHA Worker';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.patient:
        return 'Patient';
    }
  }
}

/// Mock/local session state — NOT real authentication.
///
/// There is no backend, no token, and no verification of credentials.
/// Login simply records a display name and a chosen role in memory so
/// the rest of the app (dashboards, settings, bottom nav) can branch
/// on "who is using it" for now. Wiring this up to real auth later
/// only means replacing what happens inside LoginScreen / logout().
class AppSession {
  AppSession._();

  static UserRole? currentRole;
  static String userName = '';
  static String userId = '';

  static bool get isLoggedIn => currentRole != null;
  static bool get isDoctor => currentRole == UserRole.doctor;
  static bool get isAsha => currentRole == UserRole.asha;
  static bool get isPatient => currentRole == UserRole.patient;

  /// Friendly greeting name for dashboards, falling back to the role
  /// label if the user didn't type a name at login.
  static String get displayName =>
      userName.trim().isNotEmpty ? userName.trim() : (currentRole?.shortLabel ?? 'User');

  static void logout() {
    currentRole = null;
    userName = '';
    userId = '';
  }
}
