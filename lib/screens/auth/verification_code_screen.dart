import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/auth/verification_code_controller.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';
import 'package:pinput/pinput.dart';

class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(VerificationCodeController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebVerificationLayout(controller: c)
            : _MobileVerificationLayout(controller: c),
      ),
    );
  }
}

class _MobileVerificationLayout extends StatelessWidget {
  final VerificationCodeController controller;
  const _MobileVerificationLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: _VerificationForm(
              controller: controller,
              showBack: true,
              centerOnWeb: false,
            ),
          ),
        );
      },
    );
  }
}

class _WebVerificationLayout extends StatelessWidget {
  final VerificationCodeController controller;
  const _WebVerificationLayout({required this.controller});

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
                                        color: cs.onSurface,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: "GUYANA",
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: cs.onSurface,
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
                              "Verify your identity",
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
                                  color: theme.cardColor,
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
                                child: _VerificationForm(
                                  controller: controller,
                                  showBack: false,
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

class _VerificationForm extends StatelessWidget {
  final VerificationCodeController controller;
  final bool showBack;
  final bool centerOnWeb;

  const _VerificationForm({
    required this.controller,
    required this.showBack,
    required this.centerOnWeb,
  });

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final pinSize = centerOnWeb ? 44.0 : 56.0;
    final buttonHeight = centerOnWeb ? 48.0 : 54.0;

    final defaultPinTheme = PinTheme(
      width: pinSize,
      height: pinSize,
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: cs.onSurface,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: cs.primary, width: 1.6),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: cs.error, width: 1.6),
      ),
    );

    final titleAlign = TextAlign.center;
    final crossAlign = CrossAxisAlignment.center;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showBack) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: cs.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.4,
                  color: cs.onSurface,
                ),
                children: [
                  TextSpan(
                    text: "GUYANA",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
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
          const SizedBox(height: 18),
        ],
        Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Color(0xFF16A34A),
              size: 26,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Column(
          crossAxisAlignment: crossAlign,
          children: [
            Text(
              "Enter verification code",
              textAlign: titleAlign,
              style:
                  (centerOnWeb
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.titleLarge)
                      ?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
            ),
            const SizedBox(height: 10),
            Text(
              "We've sent a 6-digit code to",
              textAlign: titleAlign,
              style:
                  (centerOnWeb
                          ? theme.textTheme.bodySmall
                          : theme.textTheme.bodyMedium)
                      ?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
            ),
            const SizedBox(height: 4),
            Text(
              c.email,
              textAlign: titleAlign,
              style:
                  (centerOnWeb
                          ? theme.textTheme.bodySmall
                          : theme.textTheme.bodyMedium)
                      ?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
            ),
          ],
        ),
        SizedBox(height: centerOnWeb ? 18 : 20),
        Center(
          child: Pinput(
            length: 6,
            controller: c.pinCtrl,
            focusNode: c.focusNode,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            errorPinTheme: errorPinTheme,
            separatorBuilder: (_) => const SizedBox(width: 10),
            keyboardType: TextInputType.number,
            mainAxisAlignment: MainAxisAlignment.center,
            onCompleted: (_) => c.verifyCode(),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Obx(() {
            final s = c.secondsLeft.value;
            if (s > 0) {
              return Text(
                "Resend code in ${s}s",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              );
            }
            return TextButton(
              onPressed: c.resendCode,
              child: Text(
                "Resend code",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: centerOnWeb ? 18 : 22),
        SizedBox(
          height: buttonHeight,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: c.verifyCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Verify code",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onPrimary,
              ),
            ),
          ),
        ),
        SizedBox(height: centerOnWeb ? 18 : 150),
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
        SizedBox(height: centerOnWeb ? 14 : 18),
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
                backgroundColor: theme.cardColor,
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
              icon: Icon(Icons.arrow_back, color: cs.onSurfaceVariant),
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
    );
  }
}
