import 'package:flutter/material.dart';
import '../session/user_session.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';

/// Wraps a screen so it only renders for an allowed [UserRole]. Used
/// on the shared named routes in main.dart (e.g. '/patient-records',
/// '/home') so that even a direct route navigation — not just an
/// absent button — can't reach a screen the current role shouldn't
/// see.
///
/// This is still a client-side/demo check: it stops the UI from
/// showing the wrong screen, but a real deployment must also enforce
/// this on the backend, since a modified client could skip it
/// entirely.
class RoleGate extends StatelessWidget {
  final List<UserRole> allowedRoles;
  final Widget child;

  const RoleGate({super.key, required this.allowedRoles, required this.child});

  @override
  Widget build(BuildContext context) {
    final role = UserSession.currentRole;
    if (role != null && allowedRoles.contains(role)) {
      return child;
    }
    return _AccessRestrictedScreen(currentRole: role);
  }
}

class _AccessRestrictedScreen extends StatelessWidget {
  final UserRole? currentRole;
  const _AccessRestrictedScreen({required this.currentRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppMetrics.spaceXL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: AppColors.lightPink, shape: BoxShape.circle),
                  child: const Icon(Icons.lock_outline_rounded, size: 40, color: AppColors.accentRed),
                ),
                const SizedBox(height: AppMetrics.spaceM),
                Text(
                  'Access Restricted',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  currentRole == null
                      ? 'Please sign in to continue.'
                      : "This screen isn't available for the ${currentRole!.label} role.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppMetrics.spaceXL),
                AppButton(
                  label: 'Back to Sign In',
                  icon: Icons.login_rounded,
                  onPressed: () {
                    UserSession.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
