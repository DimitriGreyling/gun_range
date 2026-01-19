import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/core/constants/app_details.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/models/popup_position.dart';

class LoginRegisterScreen extends ConsumerStatefulWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginRegisterScreen> createState() =>
      _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends ConsumerState<LoginRegisterScreen> {
  bool isLogin = true;
  bool showPassword = false;

  // Add focus nodes for proper keyboard management
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  // Controllers for login
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controllers for registration
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //theme provider
    final theme = Theme.of(context);

    //auth view model
    final authViewModelState = ref.watch(authViewModelProvider.notifier);
    final authViewModel = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/indoor_range.png'
                : 'assets/outdoor_range.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Icon(Icons.zoom_out,
                          color: theme.primaryColor, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppDetails.appName,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: theme.colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _emailController.clear();
                                _passwordController.clear();
                                setState(() => isLogin = true);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isLogin
                                      ? theme.primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: isLogin
                                      ? [
                                          BoxShadow(
                                              color: theme.primaryColor
                                                  .withOpacity(0.4),
                                              blurRadius: 8)
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isLogin
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _emailController.clear();
                                _passwordController.clear();
                                setState(() => isLogin = false);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isLogin
                                      ? theme.primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: !isLogin
                                      ? [
                                          BoxShadow(
                                              color: theme.primaryColor
                                                  .withOpacity(0.4),
                                              blurRadius: 8)
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  'Register',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !isLogin
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isLogin) _buildLoginFields(),
                    if (!isLogin) _buildRegisterFields(),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Forgot Password?',
                            style: TextStyle(color: theme.primaryColor)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        onPressed: authViewModel.isLoading
                            ? null
                            : () async {
                                if (isLogin) {
                                  await authViewModelState.signIn(
                                      _emailController.text,
                                      _passwordController.text);

                                  if (authViewModel.userId != null) {
                                    GlobalPopupService.showSuccess(
                                      title: 'Login Successful',
                                      message:
                                          'You have been logged in successfully.',
                                      position: PopupPosition.bottomRight,
                                    );
                                    GoRouter.of(context).go('/login');

                                    return;
                                  }
                                } else {
                                  if (_passwordController.text !=
                                      _confirmPasswordController.text) {
                                    GlobalPopupService.showWarning(
                                      title: 'Password Mismatch',
                                      message:
                                          'Passwords do not match. Please make sure to enter the same password in both fields.',
                                      position: PopupPosition.center,
                                    );
                                    _confirmPasswordController.clear();
                                    _passwordController.clear();
                                    return;
                                  }

                                  await authViewModelState.register(
                                      _emailController.text,
                                      _passwordController.text, {
                                    'first_name': _firstNameController.text,
                                    'last_name': _lastNameController.text,
                                  });

                                  if (authViewModel.error != null) {
                                    GlobalPopupService.showSuccess(
                                      title: 'Registration Successful',
                                      message:
                                          'Your account has been created successfully. You can now log in with your credentials.',
                                      position: PopupPosition.center,
                                    );
                                    setState(() {
                                      isLogin = true;
                                    });
                                    _firstNameController.clear();
                                    _lastNameController.clear();
                                    _confirmPasswordController.clear();
                                    _passwordController.clear();
                                  }
                                }
                              },
                        child: Text(isLogin ? 'Login' : 'Register'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: Divider()),
                        Expanded(
                          child: Center(
                            child: Text('OR'),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSocialButton(
                      icon: Image.asset(
                        'assets/google_logo.png',
                        width: 24,
                        height: 24,
                      ),
                      text: isLogin
                          ? 'Sign in with Google'
                          : 'Register with Google',
                      background: Theme.of(context).colorScheme.surface,
                      textColor: Theme.of(context).colorScheme.onSurface,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginFields() {
    return Column(
      children: [
        _buildTextField(
          label: 'Email',
          hint: 'Enter your email',
          controller: _emailController,
          focusNode: _emailFocusNode,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_passwordFocusNode),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Password',
          hint: 'Enter your password',
          obscure: !showPassword,
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          suffix: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterFields() {
    return Column(
      children: [
        _buildTextField(
          label: 'Name',
          hint: 'Enter your name',
          controller: _firstNameController,
          focusNode: _firstNameFocusNode,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_passwordFocusNode),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Surname',
          hint: 'Enter your surname',
          controller: _lastNameController,
          focusNode: _lastNameFocusNode,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_passwordFocusNode),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Email',
          hint: 'Enter your email',
          controller: _emailController,
          focusNode: _emailFocusNode,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_passwordFocusNode),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Password',
          hint: 'Create a password',
          obscure: !showPassword,
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          suffix: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Confirm Password',
          hint: 'Confirm your password',
          obscure: !showPassword,
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          suffix: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    bool obscure = false,
    Widget? suffix,
    FocusNode? focusNode,
    Function(String)? onSubmitted,
    TextEditingController? controller,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          focusNode: focusNode,
          obscureText: obscure,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
          style: TextStyle(color: theme.colorScheme.onBackground),
          controller: controller,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String text,
    required Color background,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
            foregroundColor: textColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(text, style: TextStyle(color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
