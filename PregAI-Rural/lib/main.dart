import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'session/user_session.dart';
import 'widgets/role_gate.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/doctor_dashboard_screen.dart';
import 'screens/patient_dashboard_screen.dart';
import 'screens/patient_records_screen.dart';
import 'screens/risk_assessment_screen.dart';
import 'screens/health_guidance_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const PregAIApp());
}

class PregAIApp extends StatelessWidget {
  const PregAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PregAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Flow: Splash -> Login (existing Sign In button) -> Role
      // Selection (ASHA Worker / Doctor / Patient) -> role-specific
      // login form -> role-specific dashboard ('/home', '/doctor-home',
      // or '/patient-home').
      //
      // Role Selection and the role login form aren't named routes
      // since the login form needs a `role` constructor argument —
      // they're reached via direct push from LoginScreen /
      // RoleSelectionScreen instead.
      //
      // Named routes are used for the tab roots so switching tabs is a
      // simple, consistent pushReplacementNamed. The staff-only shared
      // screens are wrapped in RoleGate so a role that shouldn't see
      // them is blocked even if the route is reached directly, not
      // just when there's no button pointing at it (see
      // widgets/role_gate.dart). Screens reached via Quick Actions or
      // drill-down (registration, ANC entry, patient details, risk
      // result, reports, sync) are pushed directly with
      // MaterialPageRoute since they need arguments or a normal
      // back-stack.
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const RoleGate(
              allowedRoles: [UserRole.ashaWorker],
              child: HomeScreen(),
            ),
        '/doctor-home': (context) => const RoleGate(
              allowedRoles: [UserRole.doctor],
              child: DoctorDashboardScreen(),
            ),
        '/patient-home': (context) => const RoleGate(
              allowedRoles: [UserRole.patient],
              child: PatientDashboardScreen(),
            ),
        '/patient-records': (context) => const RoleGate(
              allowedRoles: [UserRole.ashaWorker, UserRole.doctor],
              child: PatientRecordsScreen(),
            ),
        '/risk-assessment': (context) => const RoleGate(
              allowedRoles: [UserRole.ashaWorker, UserRole.doctor],
              child: RiskAssessmentScreen(),
            ),
        '/health-guidance': (context) => const RoleGate(
              allowedRoles: [UserRole.ashaWorker, UserRole.doctor, UserRole.patient],
              child: HealthGuidanceScreen(),
            ),
        '/settings': (context) => const RoleGate(
              allowedRoles: [UserRole.ashaWorker, UserRole.doctor, UserRole.patient],
              child: SettingsScreen(),
            ),
      },
    );
  }
}
