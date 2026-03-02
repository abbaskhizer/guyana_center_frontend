import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/setting/account_infromation_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AccountController());
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top bar
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Account",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Account Information
              _SectionCard(
                title: "Account Information",
                children: [
                  const SizedBox(height: 6),
                  Obx(
                    () => _InfoRow(
                      title: "Full Name",
                      value: c.fullName.value,
                      trailingText: "Edit",
                      onTapTrailing: () => c.editField(
                        title: "Full Name",
                        field: c.fullName,
                        currentValue: c.fullName.value,
                      ),
                    ),
                  ),
                  _divider(context),

                  Obx(
                    () => _InfoRow(
                      title: "Email",
                      value: c.email.value,
                      verified: c.emailVerified.value,
                    ),
                  ),
                  _divider(context),

                  Obx(
                    () => _InfoRow(
                      title: "Phone",
                      value: c.phone.value,
                      verified: c.phoneVerified.value,
                    ),
                  ),
                  _divider(context),

                  Obx(
                    () => _InfoRow(
                      title: "License",
                      value: c.license.value,
                      trailingText: "Edit",
                      onTapTrailing: () => c.editField(
                        title: "License",
                        field: c.license,
                        currentValue: c.license.value,
                      ),
                    ),
                  ),
                  _divider(context),

                  Obx(
                    () => _InfoRow(
                      title: "Location",
                      value: c.location.value,
                      trailingText: "Edit",
                      onTapTrailing: () => c.editField(
                        title: "Location",
                        field: c.location,
                        currentValue: c.location.value,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Connected Accounts
              _SectionCard(
                title: "Connected Accounts",
                children: [
                  const SizedBox(height: 6),
                  Obx(
                    () => _ConnectedRow(
                      iconBg: cs.surfaceContainerHighest,
                      iconColor: cs.onSurfaceVariant,
                      icon: Icons.g_mobiledata_rounded,
                      title: "Google",
                      subtitle: c.googleEmail.value,
                      connected: c.googleConnected.value,
                      onConnect: c.connectGoogle,
                      onDisconnect: c.disconnectGoogle,
                    ),
                  ),
                  _divider(context),
                  Obx(
                    () => _ConnectedRow(
                      iconBg: cs.surfaceContainerHighest,
                      iconColor: cs.onSurfaceVariant,
                      icon: Icons.facebook,
                      title: "Facebook",
                      subtitle: c.facebookConnected.value
                          ? "Connected"
                          : "Not connected",
                      connected: c.facebookConnected.value,
                      onConnect: c.connectFacebook,
                      onDisconnect: c.disconnectFacebook,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Membership
              _SectionCard(
                title: "Membership",
                children: [
                  const SizedBox(height: 6),
                  Obx(
                    () => Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B), // figma-like gold
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.planName.value,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: cs.onSurface,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c.planDesc.value,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: cs.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          c.planPrice.value,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: cs.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Delete Account (Figma style)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.errorContainer.withOpacity(.55),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: cs.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Once deleted, all your data will be permanently lost.",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: c.deleteAccount,
                        icon: Icon(Icons.delete_outline, color: cs.error),
                        label: Text(
                          "Delete Account",
                          style: TextStyle(
                            color: cs.error,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: cs.error.withOpacity(.55)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: cs.surface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _divider(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: cs.outlineVariant.withOpacity(.8)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        // Figma look = subtle border (not heavy)
        border: Border.all(color: cs.outlineVariant.withOpacity(.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.title,
    required this.value,
    this.trailingText,
    this.onTapTrailing,
    this.verified = false,
  });

  final String title;
  final String value;
  final String? trailingText;
  final VoidCallback? onTapTrailing;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (verified)
          _VerifiedPill(color: cs.primary)
        else if (trailingText != null)
          InkWell(
            onTap: onTapTrailing,
            child: Text(
              trailingText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant, // figma "Edit" looks grey
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            "Verified",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectedRow extends StatelessWidget {
  const _ConnectedRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.connected,
    required this.onConnect,
    required this.onDisconnect,
    required this.iconBg,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool connected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final Color iconBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Figma: Google shows "Connected" text, Facebook shows "Connect" button
        connected
            ? Text(
                "Connected",
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                ),
              )
            : SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: onConnect,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: Text(
                    "Connect",
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
