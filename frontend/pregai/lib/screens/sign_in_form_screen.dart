import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import 'role_selection_screen.dart';

/// Reached by tapping "Sign In" on the first screen. This is a
/// UI-only form — there is still no backend/account storage, so
/// submitting it doesn't create a real account. It exists as the
/// "new here?" counterpart to the "Login" button, which goes straight
/// to the existing role-based login flow (role_selection_screen.dart)
/// for people who already have one of the demo accounts.
class SignInFormScreen extends StatefulWidget {
  const SignInFormScreen({super.key});

  @override
  State<SignInFormScreen> createState() => _SignInFormScreenState();
}

class _SignInFormScreenState extends State<SignInFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    // UI-only — there is no backend/account storage yet, so this
    // doesn't persist anything. It hands off to the same role-based
    // login flow everyone else uses.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Details saved (demo). Choose your role to continue.')),
    );
    _goToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.veryLightPink, AppColors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppMetrics.spaceL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppMetrics.spaceM),
                  Text(
                    'Create your details',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This is a demo form — no account is actually stored yet.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppMetrics.spaceXL),
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
                          label: 'Full Name',
                          icon: Icons.person_outline,
                          isRequired: true,
                          controller: _nameController,
                        ),
                        AppTextField(
                          label: 'Email / Phone Number',
                          icon: Icons.alternate_email_rounded,
                          isRequired: true,
                          controller: _contactController,
                        ),
                        _PasswordField(
                          label: 'Password',
                          controller: _passwordController,
                        ),
                        _PasswordField(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                        ),
                        const SizedBox(height: AppMetrics.spaceM),
                        AppButton(
                          label: 'Sign In',
                          icon: Icons.login_rounded,
                          isLoading: _isSubmitting,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppMetrics.spaceL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: _goToLogin,
                        child: const Text(
                          'Login',
                          style: TextStyle(color: AppColors.accentRed, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
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

class _PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const _PasswordField({required this.label, required this.controller});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppMetrics.spaceM),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscure,
        style: const TextStyle(color: AppColors.darkText, fontSize: 16),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${widget.label} is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: '${widget.label} *',
          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.greyText,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
    );
  }
}
