import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/auth/verification_code_controller.dart';
import 'package:pinput/pinput.dart';

class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(VerificationCodeController());
    final cs = Theme.of(context).colorScheme;

    final defaultPinTheme = PinTheme(
      width: 46,
      height: 52,
      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: cs.onSurface, // ✅ text color theme
      ),
      decoration: BoxDecoration(
        color: cs.surface, // ✅ background theme
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outlineVariant, // ✅ default border
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: cs.primary, // ✅ focus border
          width: 1.6,
        ),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: cs.error, // ✅ error border
          width: 1.6,
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

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
                const SizedBox(height: 18),

                // shield icon circle
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.primary),
                      color: cs.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.verified_user_rounded, color: cs.primary),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "Enter verification code",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "We've sent a 6-digit code to",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Center(
                  child: Text(
                    c.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Pinput(
                    length: 6,
                    controller: c.pinCtrl,
                    focusNode: c.focusNode,
                    defaultPinTheme: defaultPinTheme,

                    focusedPinTheme: focusedPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 10),
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }
                    return TextButton(
                      onPressed: c.resendCode,
                      child: Text(
                        "Resend code",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: c.verifyCode,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Verify code",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 150),

                Row(
                  children: [
                    Expanded(child: Divider(color: cs.onSurfaceVariant)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider(color: cs.onSurfaceVariant)),
                  ],
                ),

                const SizedBox(height: 18),

                Center(
                  child: TextButton.icon(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      weight: 700,
                      color: cs.onSurfaceVariant,
                    ),
                    label: Text(
                      "Back to log in",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
