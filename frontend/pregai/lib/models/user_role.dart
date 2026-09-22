/// The three account types supported by PregAI Rural's login flow.
/// Every authenticated session has exactly one role, and that role
/// determines which dashboard and data the user can access.
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

  String get idFieldLabel {
    switch (this) {
      case UserRole.ashaWorker:
        return 'ASHA Worker ID / Username';
      case UserRole.doctor:
        return 'Doctor ID / Username';
      case UserRole.patient:
        return 'Patient ID / Username';
    }
  }
}
