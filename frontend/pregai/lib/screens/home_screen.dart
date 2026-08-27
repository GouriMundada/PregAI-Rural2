import 'package:flutter/material.dart';
import '../session/app_session.dart';
import '../theme/app_theme.dart';
import '../widgets/action_card.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/logout_dialog.dart';
import 'patient_registration_screen.dart';
import 'anc_entry_screen.dart';
import 'patient_records_screen.dart';
import 'risk_assessment_screen.dart';
import 'health_guidance_screen.dart';
import 'sync_screen.dart';
import 'settings_screen.dart';

/// ASHA / Health Worker dashboard. This is the "ASHA Dashboard" from
/// the required flow — kept as HomeScreen/home_screen.dart since that
/// file already served exactly this purpose before the login/role
/// changes; no separate asha_dashboard.dart was created to avoid a
/// duplicate screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.person_add_alt_1_rounded,
        title: 'Register Patient',
        subtitle: 'Register a new patient',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PatientRegistrationScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.medical_services_outlined,
        title: 'ANC Assessment',
        subtitle: 'Enter antenatal care details',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AncEntryScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.folder_shared_outlined,
        title: 'Patient Records',
        subtitle: 'View saved patient information',
        onTap: () => Navigator.of(context).pushNamed('/patient-records'),
      ),
      _QuickAction(
        icon: Icons.health_and_safety_outlined,
        title: 'Risk Assessment',
        subtitle: 'Assess maternal health risk',
        onTap: () => Navigator.of(context).pushNamed('/risk-assessment'),
      ),
      _QuickAction(
        icon: Icons.menu_book_outlined,
        title: 'Health Guidance',
        subtitle: 'Maternal health information',
        onTap: () => Navigator.of(context).pushNamed('/health-guidance'),
      ),
      _QuickAction(
        icon: Icons.sync_rounded,
        title: 'Sync Data',
        subtitle: 'Sync records when online',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SyncScreen()),
        ),
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
                  'Hello, ASHA Worker 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Maternal Healthcare Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (AppSession.userName.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Signed in as ${AppSession.userName.trim()}',
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
