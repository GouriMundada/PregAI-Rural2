import 'package:flutter/material.dart';
import '../session/app_session.dart';
import '../theme/app_theme.dart';

/// Shows the "Are you sure you want to logout?" confirmation dialog.
/// On confirm, clears the mock session and returns to Login, clearing
/// the back stack so the Back button/gesture can't return to a
/// dashboard that's no longer logged in.
Future<void> showLogoutConfirmation(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightPink,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 28),
      ),
      title: const Text('Log Out', textAlign: TextAlign.center),
      content: const Text(
        'Are you sure you want to logout?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('CANCEL', style: TextStyle(color: AppColors.greyText, fontWeight: FontWeight.w700)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('LOGOUT', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    AppSession.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
