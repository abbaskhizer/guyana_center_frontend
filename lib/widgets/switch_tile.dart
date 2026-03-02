import 'package:flutter/material.dart';

class SwitchTile extends StatelessWidget {
  SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.showTopDivider = true,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showTopDivider;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ✅ Divider on TOP
        if (showTopDivider)
          Divider(height: 1, thickness: 1, color: cs.outlineVariant),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,

                // ✅ Figma Primary Green Track
                activeTrackColor: cs.primary,
                activeColor: Colors.white,

                inactiveTrackColor: cs.outlineVariant,
                inactiveThumbColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
