import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/setting/preferences_controller.dart';
import 'package:guyana_center_frontend/widgets/section_card.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PreferencesController());
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar
              Row(
                children: [
                  IconButton(
                    onPressed: c.back,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Preferences",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Appearance
              SectionCard(
                title: "Appearance",
                children: [
                  const SizedBox(height: 6),
                  Obx(() {
                    return _ThemeSegment(
                      selected: c.themeMode.value,
                      onChanged: c.setTheme,
                      cs: cs,
                    );
                  }),
                ],
              ),

              const SizedBox(height: 16),

              // Language & Region
              SectionCard(
                title: "Language & Region",
                children: [
                  const SizedBox(height: 6),

                  Text(
                    "Language",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Figma-like dropdown field
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // TODO: open language screen / bottom sheet
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "English (US)",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: cs.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Timezone",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "PST (UTC-8)",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
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

/// Figma style: 3 separate containers (selected=primary, unselected=grey)
class _ThemeSegment extends StatelessWidget {
  const _ThemeSegment({
    required this.selected,
    required this.onChanged,
    required this.cs,
  });

  final ThemeMode selected;
  final ValueChanged<ThemeMode> onChanged;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final inactiveBg = cs.surfaceContainerHighest;

    return Row(
      children: [
        Expanded(
          child: _ThemeItem(
            active: selected == ThemeMode.light,
            label: "Light",
            icon: Icons.wb_sunny_outlined,
            onTap: () => onChanged(ThemeMode.light),
            cs: cs,
            inactiveBg: inactiveBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ThemeItem(
            active: selected == ThemeMode.dark,
            label: "Dark",
            icon: Icons.nightlight_round,
            onTap: () => onChanged(ThemeMode.dark),
            cs: cs,
            inactiveBg: inactiveBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ThemeItem(
            active: selected == ThemeMode.system,
            label: "System",
            icon: Icons.desktop_windows_outlined,
            onTap: () => onChanged(ThemeMode.system),
            cs: cs,
            inactiveBg: inactiveBg,
          ),
        ),
      ],
    );
  }
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem({
    required this.active,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.cs,
    required this.inactiveBg,
  });

  final bool active;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme cs;
  final Color inactiveBg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? cs.primary : inactiveBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? Colors.transparent : cs.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? Colors.white : cs.onSurfaceVariant,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: active ? Colors.white : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
