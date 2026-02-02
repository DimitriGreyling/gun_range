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

  //Forms
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
                constraints: const BoxConstraints(maxWidth: 600),
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
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        'assets/logo/logo_no_buffer.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppDetails.appName,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: authViewModel.isLoading
                                  ? null
                                  : () {
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
                              onTap: authViewModel.isLoading
                                  ? null
                                  : () {
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
                    if (isLogin)
                      Form(
                          key: _loginFormKey,
                          child: _buildLoginFields(authViewModel.isLoading)),
                    if (!isLogin)
                      Form(
                          key: _registerFormKey,
                          child: _buildRegisterFields(authViewModel.isLoading)),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: authViewModel.isLoading ? null : () {},
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
                                  if (_loginFormKey.currentState?.validate() !=
                                      true) {
                                    return;
                                  }

                                  await authViewModelState.signIn(
                                      context,
                                      _emailController.text,
                                      _passwordController.text);
                                } else {
                                  if (_registerFormKey.currentState
                                          ?.validate() !=
                                      true) {
                                    return;
                                  }

                                  await authViewModelState.register(
                                      _emailController.text,
                                      _passwordController.text, {
                                    'first_name': _firstNameController.text,
                                    'last_name': _lastNameController.text,
                                    'full_name':
                                        '${_firstNameController.text} ${_lastNameController.text}',
                                  });

                                  if (authViewModel.error == null) {
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
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
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
                                context.go('/home');
                              },
                        child: const Text('Go to Home'),
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
                      onPressed: authViewModel.isLoading ? null : () {
                        authViewModelState.signInWithGoogle();
                      },
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

  Widget _buildLoginFields(bool isLoading) {
    return Column(
      children: [
        _buildTextField(
          isLoading: isLoading,
          label: 'Email*',
          hint: 'Enter your email',
          controller: _emailController,
          focusNode: _emailFocusNode,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_passwordFocusNode),
          validator: (v) {
            final value = (v ?? '').trim();
            if (value.isEmpty) return 'Email is required';
            final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
            if (!ok) return 'Enter a valid email address';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          isLoading: isLoading,
          label: 'Password*',
          hint: 'Enter your password',
          obscure: !showPassword,
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          suffix: _buildSufficBuilder(),
          validator: (v) {
            final value = v ?? '';
            if (value.isEmpty) return 'Password is required';
            if (value.length < 8)
              return 'Password must be at least 8 characters';
            return null;
          },
        ),
      ],
    );
  }

  Builder _buildSufficBuilder() {
    return Builder(
      builder: (context) {
        final iconColor =
            Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

        return IconButton(
          onPressed: () => setState(() => showPassword = !showPassword),
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(iconColor),
            overlayColor: WidgetStatePropertyAll(iconColor.withOpacity(0.10)),
          ),
        );
      },
    );
  }

  Widget _buildRegisterFields(bool isLoading) {
    return Column(
      children: [
        Row(children: [
          Expanded(
            child: _buildTextField(
              isLoading: isLoading,
              label: 'Name',
              hint: 'Enter your name',
              controller: _firstNameController,
              focusNode: _firstNameFocusNode,
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_passwordFocusNode),
              validator: (v) {
                final value = v ?? '';
                if (value.isEmpty) return 'Name is required';
                if (value.length < 2)
                  return 'Name must be at least 3 characters';
                return null;
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              isLoading: isLoading,
              label: 'Surname',
              hint: 'Enter your surname',
              controller: _lastNameController,
              focusNode: _lastNameFocusNode,
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_emailFocusNode),
              validator: (v) {
                final value = v ?? '';
                if (value.isEmpty) return 'Surname is required';
                if (value.length < 2)
                  return 'Surname must be at least 3 characters';
                return null;
              },
            ),
          ),
        ]),
        const SizedBox(height: 16),
        _buildTextField(
          isLoading: isLoading,
          label: 'Email',
          hint: 'Enter your email',
          controller: _emailController,
          focusNode: _emailFocusNode,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_passwordFocusNode),
          validator: (v) {
            final value = (v ?? '').trim();
            if (value.isEmpty) return 'Email is required';
            final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
            if (!ok) return 'Enter a valid email address';
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                isLoading: isLoading,
                label: 'Password',
                hint: 'Create a password',
                obscure: !showPassword,
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                suffix: _buildSufficBuilder(),
                validator: (v) {
                  final value = v ?? '';
                  if (value.isEmpty) return 'Password is required';
                  if (value.length < 8)
                    return 'Password must be at least 8 characters';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                isLoading: isLoading,
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                obscure: !showPassword,
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                suffix: _buildSufficBuilder(),
                validator: (v) {
                  final value = v ?? '';
                  if (value.isEmpty) return 'Please confirm your password';
                  if (value != _passwordController.text)
                    return 'Passwords do not match';
                  return null;
                },
              ),
            ),
          ],
        )
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
    String? Function(String?)? validator,
    required bool isLoading,
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
        TextFormField(
          enabled: !isLoading,
          validator: validator,
          focusNode: focusNode,
          obscureText: obscure,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            fillColor: isLoading
                ? theme.disabledColor.withOpacity(0.1)
                : theme.cardColor,
          ),
          style: TextStyle(color: theme.colorScheme.onSurface),
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
    VoidCallback? onPressed,
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
