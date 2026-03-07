import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/screens/store_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/sell_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/favorites_screen.dart';
import 'package:guyana_center_frontend/screens/bottomNavbar/setting_screen.dart';
import 'package:guyana_center_frontend/screens/edit_profile_screen.dart';
import 'package:guyana_center_frontend/screens/auth/login_signup_screen.dart';

class WebHeader extends StatelessWidget {
  const WebHeader({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : const Color(0xFF228B22),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'GUYANA',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                TextSpan(
                  text: 'CENTRAL',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFBAF16),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _NavLink(label: 'Browse', onTap: () {}),
          const SizedBox(width: 24),
          _NavLink(label: 'Categories', onTap: () {}),
          const SizedBox(width: 24),
          _NavLink(
            label: 'Favorites',
            onTap: () {
              if (Get.currentRoute != '/FavoritesScreen') {
                Get.to(() => const FavoritesScreen());
              }
            },
          ),
          const SizedBox(width: 24),
          _NavLink(
            label: 'Stores',
            onTap: () {
              if (Get.currentRoute != '/StoresScreen') {
                Get.to(() => const StoresScreen());
              }
            },
          ),
          const SizedBox(width: 24),
          _NavLink(label: 'Get the App', onTap: () {}),
          const SizedBox(width: 24),
          _NavLink(
            label: 'Login',
            onTap: () {
              if (Get.currentRoute != '/LoginSignupScreen') {
                Get.to(() => const LoginSignupScreen());
              }
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
            },
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 40),
              color: isDark ? const Color(0xFF111827) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isDark
                      ? Colors.grey.withOpacity(0.2)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              onSelected: (value) {
                if (value == 'settings') {
                  if (Get.currentRoute != '/SettingScreen') {
                    Get.to(() => const SettingScreen());
                  }
                } else if (value == 'profile') {
                  if (Get.currentRoute != '/EditProfileScreen') {
                    Get.to(() => const EditProfileScreen());
                  }
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'aleem',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '781-4385',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const Icon(Icons.star_border, color: Colors.white, size: 24),
          const SizedBox(width: 20),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 24,
              ),
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          InkWell(
            onTap: () {
              Get.to(() => const AgentProfileScreen());
            },
            borderRadius: BorderRadius.circular(20),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFFBAF16),
              child: Icon(Icons.person_outline, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const SellScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBAF16),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Post Free Ad',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 18),
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
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

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
            fontWeight: _hovering ? FontWeight.w600 : FontWeight.w500,
            color: Colors.white.withOpacity(_hovering ? 1.0 : 0.9),
            decoration: _hovering
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: Colors.white,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
