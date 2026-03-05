import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/auth/login_signup_controller.dart';
import 'package:guyana_center_frontend/widgets/auth_input_field.dart';
import 'package:guyana_center_frontend/widgets/auth_web_footer.dart';
import 'package:guyana_center_frontend/widgets/social_auth_button.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';

class LoginSignupScreen extends StatelessWidget {
  const LoginSignupScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LoginSignupController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _isWebDesktop(context)
          ? const Color(0xFFF3F4F6)
          : theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebAuthLayout(controller: c)
            : _MobileAuthLayout(controller: c),
      ),
    );
  }
}

class _MobileAuthLayout extends StatelessWidget {
  final LoginSignupController controller;
  const _MobileAuthLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: _AuthForm(
        controller: controller,
        showBack: true,
        horizontalFormPadding: 45,
      ),
    );
  }
}

class _WebAuthLayout extends StatelessWidget {
  final LoginSignupController controller;
  const _WebAuthLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WebHeader(),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                28,
                                26,
                                28,
                                26,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 26,
                                    offset: const Offset(0, 14),
                                  ),
                                ],
                              ),
                              child: _AuthForm(
                                controller: controller,
                                showBack: false,
                                horizontalFormPadding: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const AuthWebFooter(),
      ],
    );
  }
}

class _AuthForm extends StatelessWidget {
  final LoginSignupController controller;
  final bool showBack;
  final double horizontalFormPadding;

  const _AuthForm({
    required this.controller,
    required this.showBack,
    required this.horizontalFormPadding,
  });

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showBack) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            ),
          ),
          const SizedBox(height: 10),
        ],

        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalFormPadding),
          child: Column(
            children: [
              Center(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "GUYANA",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: "CENTRAL",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFA43A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Obx(() {
                return Text(
                  c.isLogin.value
                      ? "Welcome back! Sign in to your account."
                      : "Create your account to start buying & selling.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                );
              }),
              const SizedBox(height: 18),
              Obx(() {
                return _AuthToggle(
                  isLogin: c.isLogin.value,
                  onChanged: c.toggleMode,
                );
              }),
              const SizedBox(height: 16),
              SocialAuthButton(
                text: "Continue with Google",
                leading: Text(
                  "G",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFEA4335),
                  ),
                ),
                onPressed: c.continueWithGoogle,
              ),
              const SizedBox(height: 10),
              SocialAuthButton(
                text: "Continue with Facebook",
                leading: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
                onPressed: c.continueWithFacebook,
              ),
            ],
          ),
        ),

        const SizedBox(height: 35),

        Obx(() {
          if (c.isLogin.value) return const SizedBox.shrink();
          return Column(
            children: [
              AuthInputField(
                label: "Full Name",
                hint: "Enter your full name",
                controller: c.fullNameCtrl,
                prefixIcon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
            ],
          );
        }),

        AuthInputField(
          label: "Email Address",
          hint: "you@example.com",
          controller: c.emailCtrl,
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Text(
                "Password",
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Obx(() {
              final show = c.isLogin.value;
              return IgnorePointer(
                ignoring: !show,
                child: Opacity(
                  opacity: show ? 1 : 0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: c.forgotPassword,
                    child: const Text("Forgot password?"),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 8),

        Obx(() {
          final hidden = c.isPasswordHidden.value;
          return AuthInputField(
            controller: c.passCtrl,
            hint: "Enter your password",
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: hidden,
            textInputAction: TextInputAction.next,
            suffixIcon: IconButton(
              onPressed: c.togglePassword,
              icon: Icon(
                hidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          );
        }),

        Obx(() {
          if (c.isLogin.value) return const SizedBox.shrink();
          return Column(
            children: [
              const SizedBox(height: 14),
              Obx(() {
                final hidden = c.isConfirmHidden.value;
                return AuthInputField(
                  label: "Confirm Password",
                  hint: "Confirm your password",
                  controller: c.confirmCtrl,
                  obscureText: hidden,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    onPressed: c.toggleConfirm,
                    icon: Icon(
                      hidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                );
              }),
            ],
          );
        }),

        Obx(() {
          if (c.isLogin.value) return const SizedBox.shrink();
          return Column(
            children: [
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Checkbox(
                      value: c.agreedToTerms.value,
                      onChanged: c.toggleTerms,
                    );
                  }),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        "I agree to the Terms of Service and Privacy Policy",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),

        const SizedBox(height: 30),

        Obx(() {
          final isLogin = c.isLogin.value;
          return SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: c.submit,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? "Log In" : "Create Account",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 25),

        Center(
          child: Obx(() {
            final isLogin = c.isLogin.value;
            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  isLogin
                      ? "Don't have an account? "
                      : "Already have an account? ",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () => c.toggleMode(!isLogin),
                  child: Text(
                    isLogin ? "Sign Up" : "Log In",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _AuthToggle extends StatelessWidget {
  const _AuthToggle({required this.isLogin, required this.onChanged});

  final bool isLogin;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth - 8) / 2;

          return Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  alignment: isLogin
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    width: tabWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? cs.surfaceContainerHighest : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                      ],
                    ),
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => onChanged(true),
                        child: Center(
                          child: Text(
                            "Log In",
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isLogin
                                  ? cs.onSurface
                                  : cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => onChanged(false),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: !isLogin
                                  ? cs.onSurface
                                  : cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
