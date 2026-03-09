import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.text,
    required this.leading,
    required this.onPressed,
  });

  final String text;
  final Widget leading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: theme.cardColor,
          side: BorderSide(color: cs.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BrandCircle(child: leading),
            const SizedBox(width: 10),
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandCircle extends StatelessWidget {
  const _BrandCircle({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(.5),
        shape: BoxShape.circle,
        border: Border.all(color: cs.outlineVariant),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
