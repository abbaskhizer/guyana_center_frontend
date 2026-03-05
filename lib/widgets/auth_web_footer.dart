import 'package:flutter/material.dart';

class AuthWebFooter extends StatelessWidget {
  const AuthWebFooter({
    super.key,
    this.onTerms,
    this.onPrivacy,
    this.onContact,
  });

  final VoidCallback? onTerms;
  final VoidCallback? onPrivacy;
  final VoidCallback? onContact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isSmall = MediaQuery.of(context).size.width < 720;

    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    Widget link(String label, VoidCallback? onTap) {
      return InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(6),
        hoverColor: cs.primary.withOpacity(.06), // web hover
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            label,
            style: textStyle?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    Widget brand() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.copyright_rounded, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),

          Text("2026", style: textStyle),

          const SizedBox(width: 10),

          RichText(
            text: TextSpan(
              style: textStyle,
              children: [
                TextSpan(
                  text: "Guyana",
                  style: textStyle?.copyWith(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: "Center",
                  style: textStyle?.copyWith(
                    color: Color(0xFFFFA43A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget links() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          link("Terms", onTerms),
          const SizedBox(width: 6),
          link("Privacy", onPrivacy),
          const SizedBox(width: 6),
          link("Contact", onContact),
        ],
      );
    }

    return Material(
      color: cs.surface,
      child: Column(
        children: [
          Divider(height: 1, thickness: 1, color: cs.outlineVariant),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: isSmall
                    ? Column(
                        children: [
                          brand(),
                          const SizedBox(height: 10),
                          links(),
                        ],
                      )
                    : Row(children: [brand(), const Spacer(), links()]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
