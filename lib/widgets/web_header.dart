import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class WebHeader extends StatelessWidget {
  const WebHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Only render on web
    if (!kIsWeb) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : null,
        gradient: isDark
            ? null
            : const LinearGradient(
                colors: [Color(0xFF0D8F42), Color(0xFF12B155)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // ── Logo ──
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'GUYANA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(
                  text: 'CENTRAL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isDark ? const Color(0xFFF5A623) : Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // ── Nav Links ──
          _NavLink(label: 'Explore', isDark: isDark, onTap: () {}),
          const SizedBox(width: 28),
          _NavLink(label: 'Stores', isDark: isDark, onTap: () {}),
          const SizedBox(width: 28),
          _NavLink(label: 'Get the App', isDark: isDark, onTap: () {}),

          const Spacer(),

          // ── Log In ──
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text(
              'Log In',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // ── Post Free Ad Button ──
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFF10B151)
                    : const Color(0xFFE88A1A),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Post Free Ad',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            fontSize: 14,
            fontWeight: _hovering ? FontWeight.w700 : FontWeight.w500,
            color: Colors.white.withOpacity(_hovering ? 1.0 : 0.85),
            decoration: _hovering
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: Colors.white.withOpacity(0.6),
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
