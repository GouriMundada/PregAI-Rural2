import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/patient.dart';
import '../session/user_session.dart';
import '../theme/app_theme.dart';
import '../widgets/action_card.dart';
import '../widgets/logout_helper.dart';
import 'health_guidance_screen.dart';
import 'patient_details_screen.dart';
import 'personalized_diet_plan_screen.dart';
import 'risk_result_screen.dart';

/// Patient's dashboard — the core of the role's data isolation.
///
/// Deliberately does NOT reuse AppBottomNavigation, since that would
/// route into the staff-only, all-patients screens ('/patient-records',
/// tab-root '/risk-assessment'). Instead every action here is scoped
/// to [_myPatient] specifically — this patient can never navigate to
/// another patient's record from this screen. A second layer of
/// protection sits at the route level too: see widgets/role_gate.dart
/// and main.dart, which block '/patient-records' and other staff
/// routes for the Patient role even if reached directly.
class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  Patient get _myPatient {
    final id = UserSession.currentPatientId;
    return DummyData.patients.firstWhere(
      (p) => p.id == id,
      orElse: () => DummyData.patients.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final myPatient = _myPatient;

    final actions = [
      _QuickAction(
        icon: Icons.folder_shared_outlined,
        title: 'My Health Record',
        subtitle: 'Your pregnancy & ANC details',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PatientDetailsScreen(patient: myPatient)),
        ),
      ),
      _QuickAction(
        icon: Icons.health_and_safety_outlined,
        title: 'My Risk Status',
        subtitle: 'Your latest risk assessment',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RiskResultScreen(patient: myPatient)),
        ),
      ),
      _QuickAction(
        icon: Icons.restaurant_menu_rounded,
        title: 'Personalized Diet Plan',
        subtitle: 'Your nutrition guidance',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PersonalizedDietPlanScreen(patient: myPatient)),
        ),
      ),
      _QuickAction(
        icon: Icons.menu_book_outlined,
        title: 'Health Guidance',
        subtitle: 'Maternal health information',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const HealthGuidanceScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.settings_outlined,
        title: 'Settings',
        subtitle: 'App preferences & account',
        onTap: () => Navigator.of(context).pushNamed('/settings'),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(patientName: myPatient.name),
              const SizedBox(height: AppMetrics.spaceL),
              Text('Quick Actions', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppMetrics.spaceM),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppMetrics.spaceM,
                  crossAxisSpacing: AppMetrics.spaceM,
                  childAspectRatio: 0.92,
                ),
                itemCount: actions.length,
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return ActionCard(icon: action.icon, title: action.title, subtitle: action.subtitle, onTap: action.onTap);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String patientName;
  const _Header({required this.patientName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppMetrics.spaceL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hello! 👋', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  patientName,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  'My Health Dashboard',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            onPressed: () => confirmLogout(context),
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
              child: const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _QuickAction({required this.icon, required this.title, required this.subtitle, required this.onTap});
}
