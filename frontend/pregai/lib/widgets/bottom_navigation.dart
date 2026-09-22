import 'package:flutter/material.dart';
import '../session/user_session.dart';
import '../theme/app_theme.dart';

/// Persistent bottom navigation used by the five main tab screens.
/// Screens that are pushed on top of the tab flow (e.g. Patient
/// Details, Risk Result) simply don't include this widget.
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.people_alt_rounded, label: 'Patients'),
    _NavItem(icon: Icons.health_and_safety_rounded, label: 'Risk'),
    _NavItem(icon: Icons.menu_book_rounded, label: 'Guidance'),
    _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 66,
          child: Row(
            children: List.generate(_items.length, (index) {
              final selected = index == currentIndex;
              final item = _items[index];
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.lightPink : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          color: selected ? AppColors.primary : AppColors.greyText,
                          size: 24,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected ? AppColors.primary : AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

/// Central place that maps a bottom-nav index to its root screen route.
/// Every tab-root screen calls this so switching tabs behaves the same
/// way everywhere (replace, so the back stack doesn't pile up).
void handleTabTap(BuildContext context, int index, int currentIndex) {
  if (index == currentIndex) return;
  final homeRoute = UserSession.isDoctor ? '/doctor-home' : '/home';
  final routes = [
    homeRoute,
    '/patient-records',
    '/risk-assessment',
    '/health-guidance',
    '/settings',
  ];
  Navigator.of(context).pushReplacementNamed(routes[index]);
}
