import 'package:flutter/material.dart';

class SwitchTile extends StatelessWidget {
  const SwitchTile({
    super.key,
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
        if (showTopDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: cs.outlineVariant.withOpacity(.6),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ),

              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: cs.primary,
                inactiveTrackColor: cs.surface,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
