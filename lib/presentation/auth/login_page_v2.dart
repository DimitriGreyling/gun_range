import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';

class LoginPageV2 extends ConsumerStatefulWidget {
  const LoginPageV2({super.key});

  @override
  ConsumerState<LoginPageV2> createState() => _LoginPageV2State();
}

class _LoginPageV2State extends ConsumerState<LoginPageV2> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _showPassword = false;
  bool _rememberTerminal = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final authState = ref.watch(authViewModelProvider);
    final authVm = ref.read(authViewModelProvider.notifier);
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 640;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _GridBackgroundPainter(
                dotColor: scheme.primaryContainer.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -120,
            child: _GlowOrb(
              color: scheme.primaryContainer.withOpacity(0.18),
              size: 420,
            ),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: _GlowOrb(
              color: scheme.tertiary.withOpacity(0.10),
              size: 320,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    scheme.primaryContainer.withOpacity(0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    children: [
                      _buildBranding(theme),
                      const SizedBox(height: 28),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            padding: EdgeInsets.all(isCompact ? 24 : 32),
                            decoration: BoxDecoration(
                              color:
                                  scheme.surfaceContainerLow.withOpacity(0.82),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: scheme.shadow.withOpacity(0.40),
                                  blurRadius: 40,
                                  offset: const Offset(0, 24),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Operator Authentication',
                                  style:
                                      theme.textTheme.headlineLarge?.copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Enter your credentials to secure the terminal.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      _buildTextField(
                                        context,
                                        label: 'EMAIL',
                                        controller: _emailController,
                                        focusNode: _emailFocusNode,
                                        hint: 'EMAIL',
                                        icon: Icons.person_outline,
                                        enabled: !authState.isLoading,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_passwordFocusNode);
                                        },
                                        validator: (value) {
                                          final text = (value ?? '').trim();

                                          if (text.isEmpty) {
                                            return 'Email is required.';
                                          }

                                          final emailOk = RegExp(
                                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                          ).hasMatch(text);

                                          if (!emailOk) {
                                            return 'Enter a valid email address.';
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      _buildTextField(
                                        context,
                                        label: 'PASSWORD',
                                        controller: _passwordController,
                                        focusNode: _passwordFocusNode,
                                        hint: 'PASSWORD',
                                        icon: Icons.key_outlined,
                                        enabled: !authState.isLoading,
                                        obscureText: !_showPassword,
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (_) =>
                                            _submitLogin(context, authVm),
                                        suffix: IconButton(
                                          onPressed: authState.isLoading
                                              ? null
                                              : () {
                                                  setState(() {
                                                    _showPassword =
                                                        !_showPassword;
                                                  });
                                                },
                                          icon: Icon(
                                            _showPassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                          ),
                                          style: ButtonStyle(
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                              scheme.onSurfaceVariant,
                                            ),
                                            overlayColor:
                                                WidgetStatePropertyAll(
                                              scheme.primary.withOpacity(0.08),
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          final text = value ?? '';
                                          if (text.isEmpty) {
                                            return 'Password is required';
                                          }
                                          if (text.length < 8) {
                                            return 'Password must be at least 8 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                InkWell(
                                  onTap: authState.isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            _rememberTerminal =
                                                !_rememberTerminal;
                                          });
                                        },
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.05,
                                        child: Checkbox(
                                          value: _rememberTerminal,
                                          onChanged: authState.isLoading
                                              ? null
                                              : (value) {},
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Remember this terminal',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            authState.isLoading ? null : () {},
                                        child: Text(
                                          'Forgot Password?',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                            color: scheme.primary,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  child: IgnorePointer(
                                    ignoring: authState.isLoading,
                                    child: Opacity(
                                      opacity: authState.isLoading ? 0.75 : 1,
                                      child: GradientButton(
                                        label: authState.isLoading
                                            ? 'AUTHENTICATING...'
                                            : 'LOGIN',
                                        icon: Icons.verified_user,
                                        large: true,
                                        onPressed: () =>
                                            _submitLogin(context, authVm),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  child: IgnorePointer(
                                    ignoring: authState.isLoading,
                                    child: Opacity(
                                      opacity: authState.isLoading ? 0.75 : 1,
                                      child: GradientButton(
                                        tone: GradientButtonTone.secondary,
                                        label: authState.isLoading
                                            ? 'AUTHENTICATING...'
                                            : 'Home',
                                        icon: Icons.door_back_door_outlined,
                                        large: true,
                                        onPressed: () {
                                          context.goNamed('home');
                                        }
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 26),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: scheme.outlineVariant
                                            .withOpacity(0.30),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      child: Text(
                                        'THIRD PARTY INTEL',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          color: scheme.outlineVariant,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.6,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: scheme.outlineVariant
                                            .withOpacity(0.30),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 22),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _SocialButton(
                                        label: 'Google',
                                        enabled: !authState.isLoading,
                                        leading: Image.asset(
                                          'assets/google_logo.png',
                                          width: 18,
                                          height: 18,
                                        ),
                                        onTap: () {
                                          authVm.signInWithGoogle();
                                        },
                                      ),
                                    ),
                                    // const SizedBox(width: 12),
                                    // Expanded(
                                    //   child: _SocialButton(
                                    //     label: 'Apple',
                                    //     enabled: false,
                                    //     leading: Icon(
                                    //       Icons.branding_watermark_outlined,
                                    //       color: scheme.onSurface,
                                    //       size: 18,
                                    //     ),
                                    //     onTap: () {},
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                          children: [
                            const TextSpan(text: 'New Operator? '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: InkWell(
                                onTap: () {
                                  context.go('/login');
                                },
                                child: Text(
                                  'Join the Network',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
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
          Positioned(
            left: 24,
            right: 24,
            bottom: 18,
            child: IgnorePointer(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: scheme.onSurfaceVariant.withOpacity(0.72),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                child: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: scheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('SYSTEM OPERATIONAL'),
                      ],
                    ),
                    const Spacer(),
                    const Text('VER: 4.2.0-STN'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranding(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(0.28),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            Icons.shield_outlined,
            color: scheme.primaryContainer,
            size: 36,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'SENTINEL TACTICAL',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'PRECISION ACCESS CONTROL',
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.outlineVariant,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.4,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    required bool enabled,
    bool obscureText = false,
    Widget? suffix,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.outline,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          obscureText: obscureText,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: scheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: scheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon: suffix,
            filled: true,
            fillColor: scheme.surfaceContainerLowest,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            errorMaxLines: 2,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: scheme.primaryContainer.withOpacity(0.50),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: scheme.error.withOpacity(0.80),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: scheme.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitLogin(
    BuildContext context,
    dynamic authVm,
  ) async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    await authVm.signIn(
      context,
      _emailController.text.trim(),
      _passwordController.text,
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.leading,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final Widget leading;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: enabled ? 1 : 0.50,
          child: SizedBox(
            height: 50,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  leading,
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
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
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 120,
              spreadRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class _GridBackgroundPainter extends CustomPainter {
  const _GridBackgroundPainter({
    required this.dotColor,
  });

  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 32.0;
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridBackgroundPainter oldDelegate) {
    return oldDelegate.dotColor != dotColor;
  }
}
