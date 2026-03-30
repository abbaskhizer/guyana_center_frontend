import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:guyana_center_frontend/services/auth_service.dart';

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
                const TextSpan(
                  text: 'GUYANA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(
                  text: 'CENTRAL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFF5A623),
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

          // ── Dark/Light Mode Toggle ──
          IconButton(
            onPressed: () {
              Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
            },
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),

          Obx(() {
            if (AuthService.to.isLoggedIn.value) {
              return Row(
                children: [
                  // Favorite Icon
                  IconButton(
                    onPressed: () => Get.toNamed('/favorites'),
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Notification Icon
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5A3A),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // User Dropdown
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'settings') {
                        Get.toNamed('/settings');
                      } else if (value == 'logout') {
                        AuthService.to.logout();
                      }
                    },
                    offset: const Offset(0, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings_outlined, size: 18, color: Colors.grey[700]),
                            const SizedBox(width: 10),
                            const Text('Settings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            const Icon(Icons.logout_rounded, size: 18, color: Colors.redAccent),
                            const SizedBox(width: 10),
                            const Text('Logout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                    Obx(() {
                      final photoUrl = AuthService.to.userPhotoUrl.value;
                      String? fullPhotoUrl;
                      if (photoUrl != null && photoUrl.isNotEmpty) {
                        if (photoUrl.startsWith('http')) {
                          fullPhotoUrl = photoUrl;
                        } else {
                          fullPhotoUrl = 'http://localhost:3000$photoUrl';
                        }
                      }
                      if (fullPhotoUrl != null && fullPhotoUrl.isNotEmpty) {
                        return CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(fullPhotoUrl),
                          onBackgroundImageError: (_, __) {},
                        );
                      }
                      return CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Text(
                          (AuthService.to.userName.value ?? "U").isNotEmpty
                              ? AuthService.to.userName.value!.substring(0, 1).toUpperCase()
                              : "U",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      );
                    }),
                          const SizedBox(width: 8),
                          Text(
                            AuthService.to.userName.value ?? "User",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return TextButton(
              onPressed: () {
                Get.toNamed('/login');
              },
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
            );
          }),

          const SizedBox(width: 16),

          // ── Post Free Ad Button ──
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                if (AuthService.to.isLoggedIn.value) {
                  Get.toNamed('/sell');
                } else {
                  AuthService.to.showLoginPrompt();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5A623),
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
