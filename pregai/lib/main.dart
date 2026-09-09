import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/doctor_dashboard_screen.dart';
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
      title: 'PregAI Rural',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Flow: Splash -> Login (mode selection + mock/local auth, both on
      // one screen) -> ASHA Dashboard ('/home') or Doctor Dashboard
      // ('/doctor-home').
      //
      // Named routes are used for the five bottom-navigation tab roots
      // so switching tabs is a simple, consistent pushReplacementNamed.
      // Screens reached via Quick Actions or drill-down (registration,
      // ANC entry, patient details, risk result, reports, sync) are
      // pushed directly with MaterialPageRoute since they need
      // arguments or a normal back-stack.
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/doctor-home': (context) => const DoctorDashboardScreen(),
        '/patient-records': (context) => const PatientRecordsScreen(),
        '/risk-assessment': (context) => const RiskAssessmentScreen(),
        '/health-guidance': (context) => const HealthGuidanceScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
