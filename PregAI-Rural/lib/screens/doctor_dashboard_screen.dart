import 'package:flutter/material.dart';
import '../session/user_session.dart';
import '../theme/app_theme.dart';
import '../widgets/action_card.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/logout_helper.dart';
import 'reports_screen.dart';

/// Doctor's dashboard — a tab-root screen reusing the same
/// PatientRecordsScreen/RiskAssessmentScreen/HealthGuidanceScreen/
/// SettingsScreen as the ASHA dashboard via the shared bottom nav
/// (see widgets/bottom_navigation.dart's handleTabTap), plus a direct
/// Reports quick action. No Doctor-only screens needed to be created
/// beyond this dashboard shell, since the underlying data screens are
/// already shared/generic.
class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.folder_shared_outlined,
        title: 'Patient Records',
        subtitle: 'Patients under your care',
        onTap: () => Navigator.of(context).pushNamed('/patient-records'),
      ),
      _QuickAction(
        icon: Icons.health_and_safety_outlined,
        title: 'Risk Assessment',
        subtitle: 'Vitals, labs, and risk status',
        onTap: () => Navigator.of(context).pushNamed('/risk-assessment'),
      ),
      _QuickAction(
        icon: Icons.analytics_outlined,
        title: 'Reports',
        subtitle: 'Clinical summaries',
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
                child: Text('Quick Actions', style: Theme.of(context).textTheme.headlineMedium),
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
      margin: const EdgeInsets.fromLTRB(AppMetrics.spaceL, AppMetrics.spaceL, AppMetrics.spaceL, 0),
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
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Clinical Monitoring Dashboard',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                if (UserSession.currentUserId.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Signed in as ${UserSession.currentUserId}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
