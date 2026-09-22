import '../data/demo_accounts.dart';
import '../models/user_role.dart';

/// Holds the currently authenticated demo account for this app run.
///
/// This is a plain in-memory static holder — appropriate for a
/// frontend-only prototype with no backend, but NOT a substitute for
/// real session/token management. In a production build, the backend
/// (not just this client-side flag) must verify the user's identity
/// and role on every request; a client-side role check like this one
/// can be bypassed by anyone with access to the app's code or network
/// traffic.
class AuthSession {
  AuthSession._();

  static DemoAccount? currentUser;

  static bool get isLoggedIn => currentUser != null;

  static UserRole? get currentRole => currentUser?.role;

  static void login(DemoAccount account) {
    currentUser = account;
  }

  /// Clears the session so the previous user's dashboard/data is no
  /// longer accessible from this point onward.
  static void logout() {
    currentUser = null;
  }

  static bool hasRole(Set<UserRole> allowedRoles) {
    final role = currentUser?.role;
    return role != null && allowedRoles.contains(role);
  }
}
