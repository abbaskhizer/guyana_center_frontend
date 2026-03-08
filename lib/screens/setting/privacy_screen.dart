import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/setting/privacy_controller.dart';
import 'package:guyana_center_frontend/widgets/section_card.dart';
import 'package:guyana_center_frontend/widgets/switch_tile.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PrivacyController>()) {
      Get.put(PrivacyController());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SafeArea(
        child: SingleChildScrollView(child: PrivacyContent(showTopBar: true)),
      ),
    );
  }
}

class PrivacyContent extends StatelessWidget {
  final bool showTopBar;
  const PrivacyContent({super.key, this.showTopBar = false});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<PrivacyController>()
        ? Get.find<PrivacyController>()
        : Get.put(PrivacyController());

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final content = Column(
      children: [
        SectionCard(
          title: "Profile Visibility",
          children: [
            const SizedBox(height: 6),
            Obx(
              () => _VisibilitySegment(
                isPublic: c.isPublic.value,
                onChanged: c.setVisibility,
                cs: cs,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
                  "Privacy",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        if (!kIsWeb)
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            width: double.infinity,
            decoration: BoxDecoration(color: cs.surface),
            child: content,
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
    final inactiveBg = Theme.of(context).cardColor;
    final inactiveFg = cs.onSurfaceVariant;

    return Row(
      children: [
        Expanded(
          child: _SegItem(
            active: isPublic,
            label: "Public",
            image: 'assets/public.png',
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
            image: 'assets/lock.png',
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
    required this.image,
    required this.onTap,
    required this.cs,
    required this.inactiveBg,
    required this.inactiveFg,
  });

  final bool active;
  final String label;
  final String image;
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
            Image.asset(
              image,
              height: 18,
              width: 18,
              color: fg,
              fit: BoxFit.contain,
            ),
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
