import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/auth/login_signup_controller.dart';
import 'package:guyana_center_frontend/widgets/auth_input_field.dart';
import 'package:guyana_center_frontend/widgets/social_auth_button.dart';

class LoginSignupScreen extends StatelessWidget {
  const LoginSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LoginSignupController());
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  style: IconButton.styleFrom(),
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                                color: Colors.black,
                              ),
                          children: [
                            TextSpan(
                              text: "GUYANA",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            TextSpan(
                              text: "CENTRAL",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFFFA43A),
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFEA4335),
                            ),
                      ),
                      onPressed: c.continueWithGoogle,
                    ),
                    const SizedBox(height: 10),
                    SocialAuthButton(
                      text: "Continue with Facebook",
                      leading: const Icon(
                        Icons.facebook,
                        color: Color(0xFF1877F2),
                      ),
                      onPressed: c.continueWithFacebook,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // Signup-only: Full name
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

              // Email
              AuthInputField(
                label: "Email Address",
                hint: "you@example.com",
                controller: c.emailCtrl,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 14),

              // Password label + forgot (spacing fixed)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Password",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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

              // Password field
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

              // Signup-only: Confirm password
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

              // Signup-only: Terms
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
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
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

              // Primary button
              Obx(() {
                final isLogin = c.isLogin.value;
                return SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: c.submit,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isLogin ? "Log In" : "Create Account"),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 25),

              // Bottom switch
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          // color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => c.toggleMode(!isLogin),
                        child: Text(
                          isLogin ? "Sign Up" : "Log In",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
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
          ),
        ),
      ),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        const double containerPadding = 8; // 4 left + 4 right
        const double reduce = 10; // reduce selected pill width a bit

        final inner = w - containerPadding;
        final pillWidth = (inner / 2) - (reduce / 2);

        return Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            //  color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                alignment: isLogin
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: pillWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onChanged(true),
                      child: Center(
                        child: Text(
                          "Log In",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            //  color: isLogin ? Colors.black : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onChanged(false),
                      child: Center(
                        child: Text(
                          "Sign Up",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            //   color: !isLogin ? Colors.black : Colors.black54,
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
    );
  }
}
