import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:gun_range_app/presentation/widgets/radar_background.dart';
import 'package:gun_range_app/viewmodels/auth_vm.dart';

class LoginRegisterDesktop extends ConsumerStatefulWidget {
  const LoginRegisterDesktop({super.key});

  @override
  ConsumerState<LoginRegisterDesktop> createState() =>
      _LoginRegisterDesktopState();
}

class _LoginRegisterDesktopState extends ConsumerState<LoginRegisterDesktop> {
  // Controllers and FocusNodes
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    //auth view model
    final authModel = ref.watch(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);

    //Form key
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Row(
        children: [
          _buildImageSection(),
          Form(
              key: _formKey,
              child: _buildLoginForm(authModel, authState, _formKey)),
        ],
      ),
    );
  }

  Widget _buildLoginFields(AuthViewModel authViewModel, AuthState state) {
    return Column(
      children: [
        _buildTextField(
          isLoading: state.isLoading,
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
          isLoading: state.isLoading,
          label: 'Password*',
          hint: 'Enter your password',
          obscure: !showPassword,
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          suffix: _buildSufficBuilder(),
          validator: (v) {
            final value = v ?? '';
            if (value.isEmpty) return 'Password is required';
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
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

  Widget _buildLoginForm(
    AuthViewModel authViewModel,
    AuthState authViewModelState,
    GlobalKey<FormState> _formKey,
  ) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login or Register',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildLoginFields(authViewModel, authViewModelState),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: authViewModelState.isLoading ? null : () {},
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: authViewModelState.isLoading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              authViewModel.signInForDesktop(
                                context,
                                _emailController.text.trim(),
                                _passwordController.text,
                              );
                            },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
                color: theme.colorScheme.onSurface,
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

  Widget _buildImageSection() {
    final theme = Theme.of(context);

    return Expanded(
      child: Card(
        clipBehavior: Clip.antiAlias, // important so the swoosh clips correctly
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Stack(
          children: [
            // Radar-themed background
            const Positioned.fill(
              child: RadarBackground(),
            ),

            // Tint layer to keep it aligned with your theme
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.20),
                      theme.colorScheme.primaryContainer.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // Big swoosh layer
            Positioned.fill(
              top: 500,
              left: 150,
              child: Opacity(
                opacity: 0.35,
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 2,
                    heightFactor: 2,
                    child: SvgPicture.asset(
                      'assets/maps/za4.svg',
                    ),
                  ),
                ),
              ),
            ),

            // Optional smaller swoosh (second layer)
            Positioned.fill(
              child: Opacity(
                opacity: 0.20,
                child: ClipPath(
                  clipper: _SwooshClipper2(),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Content on top
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome to Gun Connect',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwooshClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();

    // Start near top-left
    p.moveTo(0, size.height * 0.25);

    // Curve across the screen
    p.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.05,
      size.width * 0.75,
      size.height * 0.22,
    );

    // Continue down with another curve
    p.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.32,
      size.width,
      size.height * 0.55,
    );

    // Close shape around the edges
    p.lineTo(size.width, 0);
    p.lineTo(0, 0);
    p.close();

    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _SwooshClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();

    p.moveTo(0, size.height * 0.60);

    p.cubicTo(
      size.width * 0.25,
      size.height * 0.45,
      size.width * 0.55,
      size.height * 0.80,
      size.width,
      size.height * 0.65,
    );

    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    p.close();

    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
