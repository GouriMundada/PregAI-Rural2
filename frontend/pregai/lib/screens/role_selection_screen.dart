import 'package:flutter/material.dart';
import '../session/user_session.dart';
import '../theme/app_theme.dart';
import 'role_login_screen.dart';

/// Shown when the user taps the existing "Sign In" button on
/// LoginScreen. Presents the three roles; tapping one opens
/// [RoleLoginScreen] pre-set to that role.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _openRoleLogin(BuildContext context, UserRole role) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RoleLoginScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.softPinkGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppMetrics.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppMetrics.spaceM),
                Text(
                  'How would you like to sign in?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose your role to continue',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppMetrics.spaceXL),
                _RoleCard(
                  icon: Icons.volunteer_activism_rounded,
                  title: 'ASHA WORKER',
                  description: 'Manage assigned patients, ANC visits, and risk follow-ups.',
                  onTap: () => _openRoleLogin(context, UserRole.ashaWorker),
                ),
                const SizedBox(height: AppMetrics.spaceM),
                _RoleCard(
                  icon: Icons.medical_services_rounded,
                  title: 'DOCTOR',
                  description: 'Review patient records, vitals, and risk assessments.',
                  onTap: () => _openRoleLogin(context, UserRole.doctor),
                ),
                const SizedBox(height: AppMetrics.spaceM),
                _RoleCard(
                  icon: Icons.pregnant_woman_rounded,
                  title: 'PATIENT',
                  description: 'View your own health record, visits, and risk status.',
                  onTap: () => _openRoleLogin(context, UserRole.patient),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
        splashColor: AppColors.lightPink,
        child: Container(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: AppMetrics.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(description, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.greyText),
            ],
          ),
        ),
      ),
    );
  }
}
