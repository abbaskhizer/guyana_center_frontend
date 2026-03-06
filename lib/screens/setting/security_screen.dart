import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/setting/security_controller.dart';
import 'package:guyana_center_frontend/widgets/section_card.dart';
import 'package:guyana_center_frontend/widgets/switch_tile.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SecurityController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SafeArea(
        child: SingleChildScrollView(child: SecurityContent(showTopBar: true)),
      ),
    );
  }
}

class SecurityContent extends StatelessWidget {
  final bool showTopBar;
  const SecurityContent({super.key, this.showTopBar = false});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<SecurityController>()
        ? Get.find<SecurityController>()
        : Get.put(SecurityController());

    final cs = Theme.of(context).colorScheme;

    final content = Column(
      children: [
        SectionCard(
          title: "Password",
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "••••••••",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Changed 3 months ago",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: cs.errorContainer.withOpacity(.55),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Change",
                      style: TextStyle(
                        color: cs.error,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        SectionCard(
          title: "Two-Factor Auth",
          children: [
            Obx(
              () => SwitchTile(
                title: "Extra login verification",
                value: c.twoFactorEnabled.value,
                onChanged: c.toggle2FA,
                showTopDivider: false,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SectionCard(
          title: "Active Sessions",
          children: [
            SessionTile(
              icon: Icons.computer_outlined,
              title: "MacBook Pro",
              subtitle: "Chrome",
              status: "Now",
              isCurrent: true,
            ),
            SessionTile(
              icon: Icons.phone_iphone_outlined,
              title: "iPhone 15",
              subtitle: "Safari",
              status: "2h ago",
            ),
            SessionTile(
              icon: Icons.desktop_windows_outlined,
              title: "Windows PC",
              subtitle: "Firefox",
              status: "3d ago",
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Icon(Icons.logout, color: cs.error, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Sign out all others",
                    style: TextStyle(
                      color: cs.error,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SectionCard(
          title: "Login History",
          children: [
            _HistoryTile(
              title: "Today, 9:42 AM",
              subtitle: "Chrome · Mac",
              success: true,
            ),
            Divider(color: cs.outlineVariant.withOpacity(.8)),
            _HistoryTile(
              title: "Yesterday",
              subtitle: "Safari · iOS",
              success: true,
            ),
            Divider(color: cs.outlineVariant.withOpacity(.8)),
            _HistoryTile(
              title: "Jan 8",
              subtitle: "Firefox · Win",
              success: true,
            ),
            Divider(color: cs.outlineVariant.withOpacity(.8)),
            _HistoryTile(
              title: "Jan 7",
              subtitle: "Unknown · Linux",
              success: false,
            ),
          ],
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTopBar)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
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
                  "Security",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),

        if (!kIsWeb)
          ColoredBox(
            color: cs.surface,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
              child: content,
            ),
          )
        else
          content,
      ],
    );
  }
}

class SessionTile extends StatelessWidget {
  const SessionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    this.isCurrent = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tileBg = cs.surface;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: cs.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
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
            if (isCurrent)
              Row(
                children: [
                  Icon(Icons.circle, size: 8, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    "Now",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              )
            else
              Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.title,
    required this.subtitle,
    required this.success,
  });

  final String title;
  final String subtitle;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
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
          Icon(
            success ? Icons.check_rounded : Icons.shield_outlined,
            color: success ? cs.primary : cs.error,
            size: 18,
          ),
        ],
      ),
    );
  }
}
