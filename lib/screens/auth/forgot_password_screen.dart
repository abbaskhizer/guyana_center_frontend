import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/auth/forgot_password_controller.dart';
import 'package:guyana_center_frontend/widgets/auth_input_field.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ForgotPasswordController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _isWebDesktop(context)
          ? Colors.white
          : theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebForgotLayout(controller: c)
            : _MobileForgotLayout(controller: c),
      ),
    );
  }
}

class _MobileForgotLayout extends StatelessWidget {
  final ForgotPasswordController controller;
  const _MobileForgotLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: _ForgotForm(
        controller: controller,
        showBack: true,
        horizontalFormPadding: 0,
        centerOnWeb: false,
      ),
    );
  }
}

class _WebForgotLayout extends StatelessWidget {
  final ForgotPasswordController controller;
  const _WebForgotLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

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
                        padding: const EdgeInsets.fromLTRB(16, 48, 16, 48),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.4,
                                        color: Colors.black,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: "GUYANA",
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                    TextSpan(
                                      text: "CENTRAL",
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFFFFA43A),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Reset your password to continue pinning",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 28),

                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 420),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                  26,
                                  22,
                                  26,
                                  22,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 18,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: _ForgotForm(
                                  controller: controller,
                                  showBack: false,
                                  horizontalFormPadding: 0,
                                  centerOnWeb: true,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              "By continuing, you agree to pin.it's Terms of Service and Privacy Policy",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant.withOpacity(0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ForgotForm extends StatelessWidget {
  final ForgotPasswordController controller;
  final bool showBack;
  final double horizontalFormPadding;
  final bool centerOnWeb;

  const _ForgotForm({
    required this.controller,
    required this.showBack,
    required this.horizontalFormPadding,
    this.centerOnWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final titleAlign = centerOnWeb ? TextAlign.center : TextAlign.start;
    final crossAlign = centerOnWeb
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.stretch;

    final titleStyle =
        (centerOnWeb
                ? theme.textTheme.titleMedium
                : theme.textTheme.headlineSmall)
            ?.copyWith(fontWeight: FontWeight.w800);

    final descStyle =
        (centerOnWeb ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
            ?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              height: 1.4,
            );

    final sendBtnHeight = centerOnWeb ? 48.0 : 54.0;

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

        if (!centerOnWeb) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalFormPadding),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "GUYANA",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: "CENTRAL",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFA43A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
        ],

        Column(
          crossAxisAlignment: crossAlign,
          children: [
            Text("Forgot password?", textAlign: titleAlign, style: titleStyle),
            const SizedBox(height: 10),
            Text(
              "No worries! Enter your email and we'll send you a link to reset your password.",
              textAlign: titleAlign,
              style: descStyle,
            ),

            SizedBox(height: centerOnWeb ? 18 : 25),

            AuthInputField(
              label: "Email address",
              hint: "you@example.com",
              controller: c.emailCtrl,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),

            SizedBox(height: centerOnWeb ? 18 : 25),

            Obx(() {
              return SizedBox(
                height: sendBtnHeight,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: c.isLoading.value ? null : c.sendResetLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: c.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          "Send reset link",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            }),

            SizedBox(height: centerOnWeb ? 18 : 230),

            Row(
              children: [
                Expanded(child: Divider(color: cs.outlineVariant)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "OR",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: cs.outlineVariant)),
              ],
            ),

            SizedBox(height: centerOnWeb ? 14 : 20),

            if (centerOnWeb)
              SizedBox(
                height: 44,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back, color: cs.onSurfaceVariant),
                  label: Text(
                    "Back to log in",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: TextButton.icon(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: cs.onSurfaceVariant,
                    weight: 700,
                  ),
                  label: Text(
                    "Back to log in",
                    style: theme.textTheme.bodyMedium?.copyWith(
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
  }
}
