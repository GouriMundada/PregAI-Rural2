import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/patient.dart';
import '../session/app_session.dart';
import '../theme/app_theme.dart';
import '../widgets/action_card.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/logout_dialog.dart';
import 'patient_details_screen.dart';
import 'patient_records_screen.dart';
import 'reports_screen.dart';

/// Doctor's tab-root dashboard — the "Doctor Dashboard" from the
/// required flow. Reuses the same underlying screens as the ASHA
/// dashboard (Patient Records, Patient Details, Risk Assessment,
/// Reports, Health Guidance, Settings) — only the quick-action set
/// and header differ, since both roles work off the same shared
/// patient data. Kept as doctor_dashboard_screen.dart (already
/// created in an earlier pass) rather than adding a duplicate
/// doctor_dashboard.dart file.
class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.folder_shared_outlined,
        title: 'Patient Records',
        subtitle: 'Review all patient records',
        onTap: () => Navigator.of(context).pushNamed('/patient-records'),
      ),
      _QuickAction(
        icon: Icons.person_search_outlined,
        title: 'Patient Details',
        subtitle: 'Open a patient\'s full profile',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PatientDetailsScreen(patient: DummyData.patients.first),
          ),
        ),
      ),
      _QuickAction(
        icon: Icons.dangerous_outlined,
        title: 'High-Risk Patients',
        subtitle: 'Patients flagged as high risk',
        iconColor: AppColors.danger,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const PatientRecordsScreen(initialFilter: RiskLevel.high),
          ),
        ),
      ),
      _QuickAction(
        icon: Icons.health_and_safety_outlined,
        title: 'Risk Assessment',
        subtitle: 'Review maternal health risk',
        onTap: () => Navigator.of(context).pushNamed('/risk-assessment'),
      ),
      _QuickAction(
        icon: Icons.analytics_outlined,
        title: 'Risk Reports',
        subtitle: 'View health summaries',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ReportsScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.menu_book_outlined,
        title: 'Health Guidance',
        subtitle: 'Maternal health information',
        onTap: () => Navigator.of(context).pushNamed('/health-guidance'),
      ),
      _QuickAction(
        icon: Icons.settings_outlined,
        title: 'Settings',
        subtitle: 'App preferences & account',
        onTap: () => Navigator.of(context).pushNamed('/settings'),
      ),
      _QuickAction(
        icon: Icons.logout_rounded,
        title: 'Logout',
        subtitle: 'Sign out of this session',
        iconColor: AppColors.danger,
        onTap: () => showLogoutConfirmation(context),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppMetrics.spaceL,
                AppMetrics.spaceL,
                AppMetrics.spaceL,
                AppMetrics.spaceL,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppMetrics.spaceL,
                0,
                AppMetrics.spaceL,
                AppMetrics.spaceL,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppMetrics.spaceM,
                  crossAxisSpacing: AppMetrics.spaceM,
                  childAspectRatio: 0.92,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final action = actions[index];
                    return ActionCard(
                      icon: action.icon,
                      title: action.title,
                      subtitle: action.subtitle,
                      iconColor: action.iconColor,
                      onTap: action.onTap,
                    );
                  },
                  childCount: actions.length,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0,
        onTap: (index) => handleTabTap(context, index, 0),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppMetrics.spaceL,
        AppMetrics.spaceL,
        AppMetrics.spaceL,
        0,
      ),
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
                const Text(
                  'Welcome, Doctor 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Clinical Monitoring Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (AppSession.userName.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Signed in as Dr. ${AppSession.userName.trim()}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            onPressed: () => showLogoutConfirmation(context),
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
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
  final Color? iconColor;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });
}
