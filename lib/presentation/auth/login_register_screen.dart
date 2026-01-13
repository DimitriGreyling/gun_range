import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';

class LoginRegisterScreen extends ConsumerStatefulWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends ConsumerState<LoginRegisterScreen> {
  bool isLogin = true;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Icon(Icons.zoom_out, color: theme.primaryColor, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'Gun Range Connect',
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
                          onTap: () => setState(() => isLogin = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isLogin ? theme.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isLogin
                                  ? [BoxShadow(color: theme.primaryColor.withOpacity(0.4), blurRadius: 8)]
                                  : [],
                            ),
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isLogin ? Colors.black : theme.colorScheme.onBackground.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isLogin ? theme.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: !isLogin
                                  ? [BoxShadow(color: theme.primaryColor.withOpacity(0.4), blurRadius: 8)]
                                  : [],
                            ),
                            child: Text(
                              'Register',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isLogin ? Colors.black : theme.colorScheme.onBackground.withOpacity(0.7),
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
                _buildTextField(
                  label: 'Email',
                  hint: 'Enter your email address',
                  obscure: false,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  obscure: !showPassword,
                  suffix: IconButton(
                    icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: theme.colorScheme.onBackground.withOpacity(0.4)),
                    onPressed: () => setState(() => showPassword = !showPassword),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?', style: TextStyle(color: theme.primaryColor)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    onPressed: () {},
                    child: Text(isLogin ? 'Login' : 'Register'),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('OR', style: TextStyle(color: Colors.white.withOpacity(0.4))),
                    ),
                    Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  icon: Image.network('https://lh3.googleusercontent.com/aida-public/AB6AXuD51vEe9dfu99ArAitYXUx_uSwEANnrLe0Z0-glat6ENklQoPc2sisog6PP0H_vdMFJdwikbfFNLxHtz9E6ATVOEa-Fdejk1-AgRA1ifdiE1x92I0Lh_VQoAyHbByg7cWlJOGzWh2xAKJ_aHwlQud6fjpZRMY4m5Ygdlpk6IlkGlqKma2S_SbUiHaS3vuK9v3UFDY5AorwzHp6-MScdE-n8dgKCvH9BCM_LMfsUDcJoqMyACCg5MgcniUvP6lvhhCLrZdCqAu1G2V8Q', width: 24, height: 24),
                  text: 'Sign in with Google',
                  background: theme.brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.2),
                  textColor: Colors.white,
                  onPressed: () {},
                ),
                _buildSocialButton(
                  icon: Image.network('https://lh3.googleusercontent.com/aida-public/AB6AXuA0OcbZtpScb-zc4PGhp8MGvBPbmCRFgwFhXXdZw_D6ytOnLSJ1dKIV-4kE0FkBtNde8A3sBxumDRVhpBO8U05q6aJvHxs1bL9eiPIYvgRc0Mu8go4MWq8XNxG5thEj6JUn90UJ_28RlnCKqGon_osx4kcDX7wqRvEnEpdnsfpXkcqzwmiEDFOhTDR1rWY3SeqKM9vyo0sD3PlYEU83_7yZfKTZXs_hs_pKnA0OcpGJ_WtnVIVlXK0IfEToUzGrU6udB38GbMquVqQS', width: 24, height: 24),
                  text: 'Sign in with Apple',
                  background: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {},
                ),
              ],
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
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          style: TextStyle(color: theme.colorScheme.onBackground),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
