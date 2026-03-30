import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/auth/reset_password_controller.dart';
import 'package:guyana_center_frontend/screens/auth/login_signup_screen.dart';
import 'package:guyana_center_frontend/widgets/auth_input_field.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordController c;

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  void initState() {
    super.initState();
    c = Get.put(ResetPasswordController());
  }

  @override
  void dispose() {
    Get.delete<ResetPasswordController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebResetLayout(controller: c)
            : _MobileResetLayout(controller: c),
      ),
    );
  }
}

class _MobileResetLayout extends StatelessWidget {
  final ResetPasswordController controller;
  const _MobileResetLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: _ResetForm(
        controller: controller,
        showBack: true,
        horizontalFormPadding: 0,
        centerOnWeb: false,
      ),
    );
  }
}

class _WebResetLayout extends StatelessWidget {
  final ResetPasswordController controller;
  const _WebResetLayout({required this.controller});

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
                              "Update your password to continue",
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
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 18,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: _ResetForm(
                                  controller: controller,
                                  showBack: false,
                                  horizontalFormPadding: 0,
                                  centerOnWeb: true,
                                ),
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

class _ResetForm extends StatelessWidget {
  final ResetPasswordController controller;
  final bool showBack;
  final double horizontalFormPadding;
  final bool centerOnWeb;

  const _ResetForm({
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
            Text("Update Password", textAlign: titleAlign, style: titleStyle),
            const SizedBox(height: 10),
            Text(
              "Almost there! Enter a secure new password for your account.",
              textAlign: titleAlign,
              style: descStyle,
            ),

            SizedBox(height: centerOnWeb ? 18 : 25),

            Obx(() {
              final hidden = c.isPasswordHidden.value;
              return AuthInputField(
                controller: c.passCtrl,
                hint: "Enter new password",
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: hidden,
                textInputAction: TextInputAction.next,
                suffixIcon: IconButton(
                  onPressed: c.togglePassword,
                  icon: Icon(
                    hidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              );
            }),

            const SizedBox(height: 14),

            Obx(() {
              final hidden = c.isConfirmHidden.value;
              return AuthInputField(
                hint: "Confirm new password",
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
                    color: cs.onSurfaceVariant,
                  ),
                ),
              );
            }),

            SizedBox(height: centerOnWeb ? 18 : 25),

            Obx(() {
              return SizedBox(
                height: sendBtnHeight,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: c.isLoading.value ? null : c.updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
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
                          "Save Password",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            }),
            
            SizedBox(height: centerOnWeb ? 18 : 30),
            
            if (centerOnWeb)
              SizedBox(
                height: 44,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.offAll(() => LoginSignupScreen()),
                  icon: Icon(Icons.close, color: cs.onSurfaceVariant),
                  label: Text(
                    "Cancel",
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
                  onPressed: () => Get.offAll(() => LoginSignupScreen()),
                  icon: Icon(
                    Icons.close,
                    color: cs.onSurfaceVariant,
                    weight: 700,
                  ),
                  label: Text(
                    "Cancel",
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
