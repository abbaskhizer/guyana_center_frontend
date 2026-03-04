import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/setting/privacy_controller.dart';
import 'package:guyana_center_frontend/widgets/section_card.dart';
import 'package:guyana_center_frontend/widgets/switch_tile.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PrivacyController());
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
                    "Privacy",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Profile Visibility
              SectionCard(
                title: "Profile Visibility",
                children: [
                  const SizedBox(height: 6),
                  Obx(() {
                    return _VisibilitySegment(
                      isPublic: c.isPublic.value,
                      onChanged: c.setVisibility,
                      cs: cs,
                    );
                  }),
                ],
              ),

              const SizedBox(height: 16),

              // Activity & Content
              SectionCard(
                title: "Activity & Content",
                children: [
                  Obx(
                    () => SwitchTile(
                      title: "Show activity status",
                      value: c.showActivityStatus.value,
                      onChanged: (v) => c.showActivityStatus.value = v,
                      showTopDivider: false,
                    ),
                  ),
                  Obx(
                    () => SwitchTile(
                      title: "Show saved boards",
                      value: c.showSavedBoards.value,
                      onChanged: (v) => c.showSavedBoards.value = v,
                    ),
                  ),
                  Obx(
                    () => SwitchTile(
                      title: "Search engine indexing",
                      value: c.searchEngineIndexing.value,
                      onChanged: (v) => c.searchEngineIndexing.value = v,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisibilitySegment extends StatelessWidget {
  const _VisibilitySegment({
    required this.isPublic,
    required this.onChanged,
    required this.cs,
  });

  final bool isPublic;
  final ValueChanged<bool> onChanged;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    // ✅ Figma-like grey using theme
    final inactiveBg = cs.surfaceContainerHighest.withOpacity(.75);
    final inactiveFg = cs.onSurfaceVariant;

    return Row(
      children: [
        Expanded(
          child: _SegItem(
            active: isPublic,
            label: "Public",
            icon: Icons.public,
            onTap: () => onChanged(true),
            cs: cs,
            inactiveBg: inactiveBg,
            inactiveFg: inactiveFg,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SegItem(
            active: !isPublic,
            label: "Private",
            icon: Icons.lock_outline,
            onTap: () => onChanged(false),
            cs: cs,
            inactiveBg: inactiveBg,
            inactiveFg: inactiveFg,
          ),
        ),
      ],
    );
  }
}

class _SegItem extends StatelessWidget {
  const _SegItem({
    required this.active,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.cs,
    required this.inactiveBg,
    required this.inactiveFg,
  });

  final bool active;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme cs;
  final Color inactiveBg;
  final Color inactiveFg;

  @override
  Widget build(BuildContext context) {
    final bg = active ? cs.primary : inactiveBg;
    final fg = active ? cs.onPrimary : inactiveFg;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? Colors.transparent : cs.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
