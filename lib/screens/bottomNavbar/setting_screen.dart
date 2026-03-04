import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/setting_controller.dart';
import 'package:guyana_center_frontend/screens/setting/account_information_screen.dart';
import 'package:guyana_center_frontend/screens/setting/billing_screen.dart';
import 'package:guyana_center_frontend/screens/setting/notification_screen.dart';
import 'package:guyana_center_frontend/screens/setting/preferences_screen.dart';
import 'package:guyana_center_frontend/screens/setting/privacy_screen.dart';
import 'package:guyana_center_frontend/screens/setting/security_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SettingController());
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Settings",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Manage your preferences",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),

              /// Profile card (theme based)
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withOpacity(.55),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: cs.primary,
                        child: Text(
                          c.initials.value,
                          style: TextStyle(
                            color: cs.onPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.userName.value,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: cs.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              c.userEmail.value,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: cs.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: cs.onSurfaceVariant,
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              _tile(
                context,
                icon: Icons.person_outline_rounded,
                title: "Account",
                subtitle: "Personal info & details",
                onTap: () => Get.to(() => const AccountScreen()),
              ),
              _tile(
                context,
                icon: Icons.notifications_none_rounded,
                title: "Notifications",
                subtitle: "Alerts & email preferences",
                onTap: () => Get.to(() => const NotificationsScreen()),
              ),
              _tile(
                context,
                icon: Icons.shield_outlined,
                title: "Privacy",
                subtitle: "Visibility & data control",
                onTap: () => Get.to(() => const PrivacyScreen()),
              ),
              _tile(
                context,
                icon: Icons.lock_outline_rounded,
                title: "Security",
                subtitle: "Password & 2FA",
                onTap: () => Get.to(() => const SecurityScreen()),
              ),

              const SizedBox(height: 10),

              _tile(
                context,
                icon: Icons.tune_rounded,
                title: "Preferences",
                subtitle: "Theme, language & display",
                onTap: () => Get.to(() => const PreferencesScreen()),
              ),
              _tile(
                context,
                icon: Icons.credit_card_outlined,
                title: "Billing",
                subtitle: "Plan, payments & invoices",
                onTap: () => Get.to(() => const BillingScreen()),
              ),

              const SizedBox(height: 18),

              /// Sign out (theme friendly)
              Container(
                decoration: BoxDecoration(
                  color: cs.errorContainer.withOpacity(.45),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: TextButton(
                  onPressed: c.signOut,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    foregroundColor: cs.error,
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  child: const Text("Sign Out"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withOpacity(.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Icon(icon, size: 20, color: cs.onSurface),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant, // ✅ gray from theme
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: cs.onSurfaceVariant, // ✅ gray from theme
        ),
      ),
    );
  }
}
