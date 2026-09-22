import 'package:flutter/material.dart';
import '../data/demo_accounts.dart';
import '../models/user_role.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import 'role_login_screen.dart';
import 'role_selection_screen.dart';

/// New-account registration form, reached from the "Sign In" button on
/// the welcome screen (and from the "Sign Up" link on the Login form).
///
/// This is a local/demo sign-up: the account is kept in memory for the
/// current app run only (via [DemoAccounts.register]) — nothing is
/// sent to, or persisted by, a real backend. A Patient account created
/// here is not linked to any existing pregnancy/ANC record in this
/// demo, so its dashboard will show that no record is linked yet.
class SignUpScreen extends StatefulWidget {
  final UserRole? initialRole;
  const SignUpScreen({super.key, this.initialRole});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late UserRole _role = widget.initialRole ?? UserRole.ashaWorker;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _errorText = null);
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    if (DemoAccounts.isUsernameTaken(username)) {
      setState(() => _errorText = 'That username is already taken. Please choose another.');
      return;
    }

    setState(() => _isSubmitting = true);
    // Demo-only delay to simulate a network round trip.
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    DemoAccounts.register(DemoAccount(
      username: username,
      password: _passwordController.text,
      role: _role,
      displayName: _nameController.text.trim(),
    ));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    // Take the person straight to the matching Login form with their
    // new username pre-filled, so they just enter their password.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RoleLoginScreen(role: _role, initialUsername: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.spaceL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'This is a local demo — accounts you create here only exist for this session.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppMetrics.spaceL),

                Text('I am a...', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppMetrics.spaceS),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: UserRole.values.map((role) {
                    final selected = _role == role;
                    return ChoiceChip(
                      label: Text(role.label),
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: selected ? AppColors.white : AppColors.darkText,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => setState(() => _role = role),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppMetrics.spaceM),

                AppTextField(
                  label: 'Full Name',
                  icon: Icons.badge_outlined,
                  isRequired: true,
                  controller: _nameController,
                ),
                AppTextField(
                  label: _role.idFieldLabel,
                  icon: Icons.person_outline_rounded,
                  isRequired: true,
                  controller: _usernameController,
                ),
                AppTextField(
                  label: 'Password',
                  icon: Icons.lock_outline_rounded,
                  isRequired: true,
                  obscureText: true,
                  controller: _passwordController,
                ),
                AppTextField(
                  label: 'Confirm Password',
                  icon: Icons.lock_outline_rounded,
                  isRequired: true,
                  obscureText: true,
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please confirm your password';
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),

                if (_role == UserRole.patient) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Note: new patient accounts in this demo are not yet linked to a '
                    'pregnancy/ANC record.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],

                if (_errorText != null) ...[
                  const SizedBox(height: AppMetrics.spaceS),
                  Text(
                    _errorText!,
                    style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
                  ),
                ],

                const SizedBox(height: AppMetrics.spaceL),
                AppButton(
                  label: 'Create Account',
                  icon: Icons.person_add_alt_1_rounded,
                  isLoading: _isSubmitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppMetrics.spaceM),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                    ),
                    child: const Text(
                      'Already have an account? Please Login',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: AppMetrics.spaceL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
