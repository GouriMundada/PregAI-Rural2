import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../session/app_session.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/mode_selection_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole? _selectedMode;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isSigningIn = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _errorMessage = null);

    if (_selectedMode == null) {
      setState(() => _errorMessage = 'Please select ASHA / Health Worker or Doctor to continue.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSigningIn = true);
    // Mock/local authentication only — no backend call, no token.
    // MockAuthService is structured so this can later be swapped for
    // a real API call that returns the same AuthResult shape.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final result = MockAuthService.login(
      username: _usernameController.text,
      password: _passwordController.text,
      mode: _selectedMode!,
    );

    setState(() => _isSigningIn = false);

    if (!result.success) {
      setState(() => _errorMessage = result.errorMessage);
      return;
    }

    AppSession.currentRole = _selectedMode;
    AppSession.userName = _usernameController.text.trim();
    AppSession.userId = _usernameController.text.trim();

    final route = _selectedMode == UserRole.doctor ? '/doctor-home' : '/home';
    // Clear Login from the back stack so Back can't return to it once
    // the user is inside a dashboard.
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const SizedBox(height: AppMetrics.spaceM),
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 38),
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    const Text(
                      'PregAI Rural',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'AI-Powered Maternal Healthcare',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.accentRed, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppMetrics.spaceL),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Select your role and sign in to continue',
                      style: TextStyle(fontSize: 14, color: AppColors.greyText),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),

                    ModeSelectionCard(
                      icon: Icons.volunteer_activism_rounded,
                      title: 'ASHA / HEALTH WORKER',
                      description: 'Register patients, perform ANC assessments and monitor maternal health.',
                      selected: _selectedMode == UserRole.asha,
                      onTap: () => setState(() {
                        _selectedMode = UserRole.asha;
                        _errorMessage = null;
                      }),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    ModeSelectionCard(
                      icon: Icons.medical_services_rounded,
                      title: 'DOCTOR',
                      description: 'Review patient records, risk assessments and AI-generated reports.',
                      selected: _selectedMode == UserRole.doctor,
                      onTap: () => setState(() {
                        _selectedMode = UserRole.doctor;
                        _errorMessage = null;
                      }),
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
                          TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(color: AppColors.darkText, fontSize: 16),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username / Phone Number is required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Username / Phone Number *',
                              prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: AppMetrics.spaceM),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => setState(() => _rememberMe = !_rememberMe),
                                borderRadius: BorderRadius.circular(8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      activeColor: AppColors.primary,
                                      onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                    ),
                                    const Text('Remember Me', style: TextStyle(color: AppColors.darkText)),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Password reset is a demo placeholder.')),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: AppColors.accentRed, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
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
                      child: const Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline_rounded, color: AppColors.accentRed, size: 16),
                              SizedBox(width: 8),
                              Text(
                                'Demo mode — mock sign-in only',
                                style: TextStyle(color: AppColors.accentRed, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ASHA: asha / 1234    •    Doctor: doctor / 1234',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.accentRed, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceL),
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
