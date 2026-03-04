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
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: cs.surface, // ✅ theme surface
          side: BorderSide(color: cs.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BrandCircle(child: leading),
            const SizedBox(width: 10),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface, // ✅ theme text color
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
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(.7), // ✅ soft grey
        shape: BoxShape.circle,
        border: Border.all(color: cs.outlineVariant),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
