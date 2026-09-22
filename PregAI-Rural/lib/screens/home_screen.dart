import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/action_card.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/logout_helper.dart';
import 'patient_registration_screen.dart';
import 'anc_entry_screen.dart';
import 'patient_records_screen.dart';
import 'risk_assessment_screen.dart';
import 'health_guidance_screen.dart';
import 'reports_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.person_add_alt_1_rounded,
        title: 'Patient Registration',
        subtitle: 'Register a new patient',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PatientRegistrationScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.medical_services_outlined,
        title: 'ANC Entry',
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
        icon: Icons.analytics_outlined,
        title: 'Reports',
        subtitle: 'View health summaries',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ReportsScreen()),
        ),
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
                  'Hello! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Welcome to PregAI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Maternal Care Assistant',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            onPressed: () => confirmLogout(context),
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
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
