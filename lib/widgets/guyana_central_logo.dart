import 'package:flutter/material.dart';

class GuyanaCentralLogo extends StatelessWidget {
  const GuyanaCentralLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return RichText(
      text: TextSpan(
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
          color: cs.onSurface,
        ),
        children: [
          const TextSpan(text: "GUYANA"),
          TextSpan(
            text: "CENTRAL",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: const Color(0xFFFF8A00),
            ),
          ),
        ],
      ),
    );
  }
}
