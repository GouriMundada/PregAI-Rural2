import 'package:flutter/material.dart';
import '../models/user_role.dart';
import '../screens/login_screen.dart';
import 'auth_session.dart';

/// A light-weight, client-side navigation guard used by every
/// role-restricted screen.
///
/// NOTE: This only prevents *casual* in-app navigation to a screen the
/// current role shouldn't see (e.g. deep-linking, or a shared widget
/// exposing a route it shouldn't). It is NOT a substitute for real
/// authorization — in a production app, the backend must independently
/// verify the user's identity and role before returning any data,
/// since a client-side check like this one can always be bypassed.
class RoleGuard {
  RoleGuard._();

  /// Call from a guarded screen's [State.initState]. If the current
  /// session doesn't have one of [allowedRoles] (including "not logged
  /// in at all"), the user is redirected to the Sign In page and the
  /// entire navigation history is cleared, so they cannot use the back
  /// button to return to the protected screen or a previous session's
  /// dashboard.
  static void ensure(BuildContext context, Set<UserRole> allowedRoles) {
    if (AuthSession.hasRole(allowedRoles)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    });
  }
}
