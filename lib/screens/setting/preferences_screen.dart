import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/setting/preferences_controller.dart';
import 'package:guyana_center_frontend/widgets/section_card.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PreferencesController>()) {
      Get.put(PreferencesController());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: PreferencesContent(showTopBar: true),
        ),
      ),
    );
  }
}

class PreferencesContent extends StatelessWidget {
  final bool showTopBar;
  const PreferencesContent({super.key, this.showTopBar = false});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<PreferencesController>()
        ? Get.find<PreferencesController>()
        : Get.put(PreferencesController());

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final content = Column(
      children: [
        SectionCard(
          title: "Appearance",
          children: [
            const SizedBox(height: 6),
            Obx(
              () => _ThemeSegment(
                selected: c.themeMode.value,
                onChanged: c.setTheme,
                cs: cs,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: "Language & Region",
          children: [
            const SizedBox(height: 6),
            Text(
              "Language",
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "English (US)",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
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
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "PST (UTC-8)",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
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
                  onPressed: c.back,
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "Preferences",
                  style: theme.textTheme.titleMedium?.copyWith(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: content,
          ),
      ],
    );
  }
}

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
    final inactiveBg = Theme.of(context).cardColor;

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
              color: active ? cs.onPrimary : cs.onSurfaceVariant,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: active ? cs.onPrimary : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
