import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/setting_controller.dart';
import 'package:guyana_center_frontend/screens/setting/account_information_screen.dart';
import 'package:guyana_center_frontend/screens/setting/billing_screen.dart';
import 'package:guyana_center_frontend/screens/setting/notification_screen.dart';
import 'package:guyana_center_frontend/screens/setting/preferences_screen.dart';
import 'package:guyana_center_frontend/screens/setting/privacy_screen.dart';
import 'package:guyana_center_frontend/screens/setting/security_screen.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<SettingController>()
        ? Get.find<SettingController>()
        : Get.put(SettingController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _isWebDesktop(context)
          ? theme.colorScheme.surface
          : theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebSettingsLayout(controller: c)
            : _MobileSettingsLayout(controller: c),
      ),
    );
  }
}

class _MobileSettingsLayout extends StatelessWidget {
  final SettingController controller;
  const _MobileSettingsLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _SettingsMobileContent(controller: controller);
  }
}

class _WebSettingsLayout extends StatelessWidget {
  final SettingController controller;
  const _WebSettingsLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 27),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _WebSettingsPageHeader(),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SettingsSidebar(controller: controller),
                        const SizedBox(width: 18),
                        Expanded(
                          child: _WebContentPanel(controller: controller),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 45),
          const WebFooter(),
        ],
      ),
    );
  }
}

class _SettingsMobileContent extends StatelessWidget {
  final SettingController controller;
  const _SettingsMobileContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Settings",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Manage your preferences",
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Obx(() {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.08),
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
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c.userEmail.value,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 30,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          _mobileTile(
            context,
            image: 'assets/person.png',
            title: "Account",
            subtitle: "Personal info & details",
            onTap: () => Get.to(() => const AccountScreen()),
          ),
          _mobileTile(
            context,
            image: 'assets/notification.png',
            title: "Notifications",
            subtitle: "Alerts & email preferences",
            onTap: () => Get.to(() => const NotificationsScreen()),
          ),
          _mobileTile(
            context,
            image: 'assets/privcy.png',
            title: "Privacy",
            subtitle: "Visibility & data control",
            onTap: () => Get.to(() => const PrivacyScreen()),
          ),
          _mobileTile(
            context,
            image: 'assets/lock.png',
            title: "Security",
            subtitle: "Password & 2FA",
            onTap: () => Get.to(() => const SecurityScreen()),
          ),
          _mobileTile(
            context,
            image: 'assets/pref.png',
            title: "Preferences",
            subtitle: "Theme, language & display",
            onTap: () => Get.to(() => const PreferencesScreen()),
          ),
          _mobileTile(
            context,
            image: 'assets/billing.png',
            title: "Billing",
            subtitle: "Plan, payments & invoices",
            onTap: () => Get.to(() => const BillingScreen()),
          ),
          const SizedBox(height: 18),
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
    );
  }

  Widget _mobileTile(
    BuildContext context, {
    required String image,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant.withOpacity(.5)),
          ),
          child: Center(
            child: Image.asset(
              image,
              height: 22,
              width: 22,
              color: cs.onSurface,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
      ),
    );
  }
}

class _SettingsSidebar extends StatelessWidget {
  final SettingController controller;
  const _SettingsSidebar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      width: 220,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withOpacity(.55)),
              ),
              child: Column(
                children: [
                  _sidebarItem(
                    context,
                    icon: Icons.person_outline_rounded,
                    title: "Account",
                    active: controller.selectedTab.value == SettingsTab.account,
                    onTap: () => controller.changeTab(SettingsTab.account),
                  ),
                  _sidebarItem(
                    context,
                    icon: Icons.notifications_none_rounded,
                    title: "Notifications",
                    active:
                        controller.selectedTab.value ==
                        SettingsTab.notifications,
                    onTap: () =>
                        controller.changeTab(SettingsTab.notifications),
                  ),
                  _sidebarItem(
                    context,
                    icon: Icons.lock_outline_rounded,
                    title: "Privacy",
                    active: controller.selectedTab.value == SettingsTab.privacy,
                    onTap: () => controller.changeTab(SettingsTab.privacy),
                  ),
                  _sidebarItem(
                    context,
                    icon: Icons.shield_outlined,
                    title: "Security",
                    active:
                        controller.selectedTab.value == SettingsTab.security,
                    onTap: () => controller.changeTab(SettingsTab.security),
                  ),
                  _sidebarItem(
                    context,
                    icon: Icons.tune_rounded,
                    title: "Preferences",
                    active:
                        controller.selectedTab.value == SettingsTab.preferences,
                    onTap: () => controller.changeTab(SettingsTab.preferences),
                  ),
                  _sidebarItem(
                    context,
                    icon: Icons.credit_card_outlined,
                    title: "Billing",
                    active: controller.selectedTab.value == SettingsTab.billing,
                    onTap: () => controller.changeTab(SettingsTab.billing),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Obx(() {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.outlineVariant.withOpacity(.55)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: cs.primary.withOpacity(.15),
                          child: Text(
                            controller.initials.value,
                            style: TextStyle(
                              color: cs.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.userName.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                controller.userEmail.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: controller.signOut,
                        style: TextButton.styleFrom(
                          foregroundColor: cs.error,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(0, 0),
                        ),
                        icon: const Icon(Icons.logout_rounded, size: 16),
                        label: const Text(
                          "Sign Out",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _WebContentPanel extends StatelessWidget {
  final SettingController controller;
  const _WebContentPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.selectedTab.value) {
        case SettingsTab.account:
          return AccountContent();
        case SettingsTab.notifications:
          return NotificationsContent();
        case SettingsTab.privacy:
          return PrivacyContent();
        case SettingsTab.security:
          return SecurityContent();
        case SettingsTab.preferences:
          return PreferencesContent();
        case SettingsTab.billing:
          return BillingContent();
      }
    });
  }
}

class _WebSettingsPageHeader extends StatelessWidget {
  const _WebSettingsPageHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cs.outlineVariant.withOpacity(.55)),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 16,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Manage your account preferences and security",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _sidebarItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool active = false,
}) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;

  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    decoration: BoxDecoration(
      color: active ? cs.primary.withOpacity(.08) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      onTap: onTap,
      dense: true,
      horizontalTitleGap: 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      leading: Icon(
        icon,
        size: 18,
        color: active ? cs.primary : cs.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: active ? FontWeight.w800 : FontWeight.w700,
          color: active ? cs.primary : cs.onSurface,
        ),
      ),
    ),
  );
}
