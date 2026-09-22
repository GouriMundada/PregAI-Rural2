import 'package:flutter/material.dart';
import '../session/user_session.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/logout_helper.dart';
import '../widgets/section_header.dart';
import 'sync_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _language = 'English';

  void _pickLanguage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppMetrics.spaceL),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Language', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppMetrics.spaceM),
            for (final lang in ['English', 'Hindi', 'Marathi'])
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(lang),
                trailing: _language == lang
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _language = lang);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() => confirmLogout(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          children: [
            const SectionHeader(title: 'Account', icon: Icons.account_circle_outlined),
            _SettingsCard(children: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: UserSession.currentUserId.isNotEmpty ? UserSession.currentUserId : 'Profile',
                subtitle: UserSession.currentRole?.label ?? 'Account details',
                onTap: () => _showInfoDialog('Profile', 'Profile management is a demo placeholder.'),
              ),
            ]),

            const SizedBox(height: AppMetrics.spaceL),
            const SectionHeader(title: 'Preferences', icon: Icons.tune_outlined),
            _SettingsCard(children: [
              _SettingsTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: _language,
                onTap: _pickLanguage,
              ),
              _SwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Reminders for ANC visits and follow-ups',
                value: _notificationsEnabled,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
              ),
            ]),

            const SizedBox(height: AppMetrics.spaceL),
            const SectionHeader(title: 'Data', icon: Icons.storage_outlined),
            _SettingsCard(children: [
              _SettingsTile(
                icon: Icons.sync_rounded,
                title: 'Data Synchronization',
                subtitle: 'Manage offline & online sync',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SyncScreen()),
                ),
              ),
              _SettingsTile(
                icon: Icons.backup_outlined,
                title: 'Backup',
                subtitle: 'Backup patient data locally',
                onTap: () => _showInfoDialog('Backup', 'Backup functionality is a demo placeholder.'),
              ),
            ]),

            const SizedBox(height: AppMetrics.spaceL),
            const SectionHeader(title: 'Privacy', icon: Icons.privacy_tip_outlined),
            _SettingsCard(children: [
              _SettingsTile(
                icon: Icons.shield_outlined,
                title: 'Privacy Information',
                subtitle: 'How patient data is handled',
                onTap: () => _showInfoDialog(
                  'Privacy Information',
                  'PregAI is currently a frontend demo. No patient data is stored, transmitted, or shared.',
                ),
              ),
            ]),

            const SizedBox(height: AppMetrics.spaceL),
            const SectionHeader(title: 'About', icon: Icons.info_outline_rounded),
            _SettingsCard(children: [
              _SettingsTile(
                icon: Icons.favorite_border_rounded,
                title: 'About PregAI',
                subtitle: 'Maternal Care Assistant',
                onTap: () => _showInfoDialog(
                  'About PregAI',
                  'PregAI is a maternal healthcare assistant concept, designed to support health workers '
                      'with patient registration, ANC tracking, and risk awareness.',
                ),
              ),
              const _SettingsTile(
                icon: Icons.tag_outlined,
                title: 'Version',
                subtitle: '1.0.0 (Frontend Demo)',
              ),
            ]),

            const SizedBox(height: AppMetrics.spaceL),
            const SectionHeader(title: 'Session', icon: Icons.logout_rounded),
            _SettingsCard(children: [
              _SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Log Out',
                subtitle: 'End this session and return to Sign In',
                onTap: _confirmLogout,
              ),
            ]),
            const SizedBox(height: AppMetrics.spaceL),
          ],
        ),
      ),
      // The Patient role has no staff tabs (Patients/Risk browsing),
      // so it doesn't get this shared bottom nav — see
      // PatientDashboardScreen, which reuses this Settings screen via
      // a plain pushNamed('/settings') instead.
      bottomNavigationBar: UserSession.isPatient
          ? null
          : AppBottomNavigation(
              currentIndex: 4,
              onTap: (index) => handleTabTap(context, index, 4),
            ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) const Divider(height: 1, indent: 56),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.lightPink, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right_rounded, color: AppColors.greyText)
          : null,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.lightPink, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      trailing: Switch(
        value: value,
        activeThumbColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}
