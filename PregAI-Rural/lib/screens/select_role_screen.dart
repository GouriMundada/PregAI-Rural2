import 'package:flutter/material.dart';
import '../session/app_session.dart';
import '../theme/app_theme.dart';
import '../widgets/mode_selection_card.dart';
import 'login_screen.dart';

/// Shown right after Splash, before Login. The chosen role is passed
/// into LoginScreen, which then only shows credential fields for that
/// role (see login_screen.dart).
class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  void _openLogin(BuildContext context, UserRole role) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.softPinkGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppMetrics.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppMetrics.spaceL),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 34),
                  ),
                ),
                const SizedBox(height: AppMetrics.spaceL),
                Text(
                  'PregAI Rural',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Select User Mode',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose how you\'d like to continue',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppMetrics.spaceXL),

                ModeSelectionCard(
                  icon: Icons.volunteer_activism_rounded,
                  title: 'ASHA / HEALTH WORKER',
                  description:
                      'Register patients, perform ANC assessments and monitor maternal health.',
                  selected: false,
                  onTap: () => _openLogin(context, UserRole.asha),
                ),
                const SizedBox(height: AppMetrics.spaceM),
                ModeSelectionCard(
                  icon: Icons.medical_services_rounded,
                  title: 'DOCTOR',
                  description:
                      'Review patient records, risk assessments and AI-generated reports.',
                  selected: false,
                  onTap: () => _openLogin(context, UserRole.doctor),
                ),
                const SizedBox(height: AppMetrics.spaceM),
                ModeSelectionCard(
                  icon: Icons.pregnant_woman_rounded,
                  title: 'PATIENT',
                  description:
                      'View your health record, risk status and maternal care guidance.',
                  selected: false,
                  onTap: () => _openLogin(context, UserRole.patient),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
