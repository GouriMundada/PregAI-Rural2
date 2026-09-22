import 'package:flutter/material.dart';
import '../session/user_session.dart';
import '../theme/app_theme.dart';

/// Shows the "Are you sure you want to log out?" confirmation dialog.
/// On confirm, clears the mock session and returns to the Sign In
/// screen, clearing the back stack so Back/gesture-back can't return
/// to a dashboard that's no longer logged in — the previous user's
/// data becomes unreachable.
Future<void> confirmLogout(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Log Out'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel', style: TextStyle(color: AppColors.greyText)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Log Out', style: TextStyle(color: AppColors.danger)),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    UserSession.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
