import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/auth/forgot_password_controller.dart';
import 'package:guyana_center_frontend/widgets/auth_input_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ForgotPasswordController());
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back button
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

                // Logo
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

                const SizedBox(height: 30),

                // Title
                Text(
                  "Forgot password?",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "No worries! Enter your email and we'll send you a link to reset your password.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),

                const SizedBox(height: 25),

                // Email field
                AuthInputField(
                  label: "Email address",
                  hint: "you@example.com",
                  controller: c.emailCtrl,
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 25),

                // Send button
                Obx(() {
                  return SizedBox(
                    height: 54,
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
                          : const Text(
                              "Send reset link",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                    ),
                  );
                }),

                SizedBox(height: 230),

                // OR Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: cs.onSurfaceVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: cs.onSurfaceVariant)),
                  ],
                ),

                const SizedBox(height: 20),

                // Back to login
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
