import '../models/user_role.dart';

/// A single local/demo login credential.
///
/// IMPORTANT: These are DEMO credentials for this frontend-only
/// prototype. There is no real backend, and passwords are stored and
/// compared in plain text purely for demonstration. This is NOT
/// production-secure authentication.
class DemoAccount {
  final String username;
  final String password;
  final UserRole role;
  final String displayName;

  /// Only set for [UserRole.patient] accounts — links this login to
  /// exactly one [Patient.id] in [DummyData.patients], so a logged-in
  /// patient only ever retrieves their own record. Accounts created
  /// through Sign Up are not linked to an existing patient record.
  final String? patientId;

  const DemoAccount({
    required this.username,
    required this.password,
    required this.role,
    required this.displayName,
    this.patientId,
  });
}

/// Local/demo account directory used in place of a real auth backend.
///
/// Starts with three fixed demo logins (one per role) and also accepts
/// new accounts created through the Sign Up screen. Sign-up accounts
/// are kept in memory only for the current app run — nothing is
/// persisted to disk or a server, consistent with the rest of this
/// frontend-only prototype.
class DemoAccounts {
  DemoAccounts._();

  static final List<DemoAccount> _accounts = [
    const DemoAccount(
      username: 'asha001',
      password: 'asha123',
      role: UserRole.ashaWorker,
      displayName: 'Meena Kamble',
    ),
    const DemoAccount(
      username: 'doctor001',
      password: 'doctor123',
      role: UserRole.doctor,
      displayName: 'Dr. Rohan Kapoor',
    ),
    const DemoAccount(
      username: 'patient001',
      password: 'patient123',
      role: UserRole.patient,
      displayName: 'Anjali Patil',
      patientId: 'P001',
    ),
  ];

  static List<DemoAccount> get all => List.unmodifiable(_accounts);

  /// Returns the matching account, or null if the username/password
  /// combination doesn't match any demo or sign-up account.
  static DemoAccount? authenticate(String username, String password) {
    for (final account in _accounts) {
      if (account.username == username && account.password == password) {
        return account;
      }
    }
    return null;
  }

  static bool isUsernameTaken(String username) {
    return _accounts.any((a) => a.username.toLowerCase() == username.toLowerCase());
  }

  /// Adds a new demo account created through Sign Up. Returns false
  /// (without adding anything) if the username is already in use.
  static bool register(DemoAccount account) {
    if (isUsernameTaken(account.username)) return false;
    _accounts.add(account);
    return true;
  }
}
