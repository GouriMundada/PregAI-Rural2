import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import 'role_selection_screen.dart';
import 'sign_in_form_screen.dart';

/// Shown right after the splash screen. This is a static/mock login
/// screen — there is no auth backend yet — with two entry points:
///   - "Sign In" opens a UI-only sign-in form (sign_in_form_screen.dart)
///     for someone setting up their details for the first time.
///   - "Login" goes straight to role selection (ASHA Worker / Doctor /
///     Patient) for someone who already has one of the demo accounts.
/// Both eventually lead into the same role selection + role login flow.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.veryLightPink, AppColors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppMetrics.spaceXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.white,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: AppMetrics.spaceL),
                  const Text(
                    'Welcome to PregAI Rural',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Maternal Care Assistant for ASHA / Health Workers',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: AppColors.greyText),
                  ),
                  const SizedBox(height: AppMetrics.spaceXL),
                  AppButton(
                    label: 'Sign In',
                    icon: Icons.login_rounded,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignInFormScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: AppMetrics.spaceM),
                  AppButton(
                    label: 'Login',
                    icon: Icons.arrow_forward_rounded,
                    type: AppButtonType.secondary,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
