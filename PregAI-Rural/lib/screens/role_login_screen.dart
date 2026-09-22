import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../session/user_session.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

/// Login form for a single, already-chosen [role]. One shared,
/// parameterized screen rather than three near-identical files, since
/// the only thing that differs between roles is the icon, copy, demo
/// hint, and destination dashboard.
class RoleLoginScreen extends StatefulWidget {
  final UserRole role;

  const RoleLoginScreen({super.key, required this.role});

  @override
  State<RoleLoginScreen> createState() => _RoleLoginScreenState();
}

class _RoleLoginScreenState extends State<RoleLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSigningIn = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _usernameLabel {
    switch (widget.role) {
      case UserRole.ashaWorker:
        return 'ASHA Worker ID / Username';
      case UserRole.doctor:
        return 'Doctor ID / Username';
      case UserRole.patient:
        return 'Patient ID / Username';
    }
  }

  IconData get _roleIcon {
    switch (widget.role) {
      case UserRole.ashaWorker:
        return Icons.volunteer_activism_rounded;
      case UserRole.doctor:
        return Icons.medical_services_rounded;
      case UserRole.patient:
        return Icons.pregnant_woman_rounded;
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSigningIn = true;
      _errorMessage = null;
    });
    // Mock/local authentication only — no backend call, no token.
    // MockAuthService is structured so this can later be swapped for
    // a real API call returning the same AuthResult shape.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final result = MockAuthService.login(
      username: _usernameController.text,
      password: _passwordController.text,
      role: widget.role,
    );

    setState(() => _isSigningIn = false);

    if (!result.success) {
      setState(() => _errorMessage = result.errorMessage);
      return;
    }

    UserSession.currentRole = widget.role;
    UserSession.currentUserId = _usernameController.text.trim();
    UserSession.currentPatientId = result.patientId;

    final route = switch (widget.role) {
      UserRole.ashaWorker => '/home',
      UserRole.doctor => '/doctor-home',
      UserRole.patient => '/patient-home',
    };
    // Clear Sign In + Role Selection + this login form from the back
    // stack so Back can't return to them once inside a dashboard.
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final demo = MockAuthService.demoCredentialsFor(widget.role);

    return Scaffold(
      appBar: AppBar(title: Text('${widget.role.label} Login')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.softPinkGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppMetrics.spaceL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_roleIcon, color: Colors.white, size: 34),
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceL),
                    Container(
                      padding: const EdgeInsets.all(AppMetrics.spaceL),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            label: _usernameLabel,
                            icon: Icons.person_outline,
                            isRequired: true,
                            controller: _usernameController,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: AppColors.darkText, fontSize: 16),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password *',
                              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: AppColors.greyText,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: AppMetrics.spaceS),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: AppMetrics.spaceM),
                          AppButton(
                            label: 'Login',
                            icon: Icons.login_rounded,
                            isLoading: _isSigningIn,
                            onPressed: _login,
                          ),
                          const SizedBox(height: AppMetrics.spaceS),
                          AppButton(
                            label: 'Back',
                            icon: Icons.arrow_back_rounded,
                            type: AppButtonType.secondary,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceL),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.lightPink,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline_rounded, color: AppColors.accentRed, size: 16),
                              SizedBox(width: 8),
                              Text(
                                'DEMO credentials — not real authentication',
                                style: TextStyle(color: AppColors.accentRed, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.role.label}: ${demo.username} / ${demo.password}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.accentRed, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
