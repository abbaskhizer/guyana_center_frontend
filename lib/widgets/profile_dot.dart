import 'package:flutter/material.dart';

class ProfileDot extends StatelessWidget {
  const ProfileDot({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(Icons.person_rounded, color: cs.onPrimary, size: 16),
      ),
    );
  }
}
