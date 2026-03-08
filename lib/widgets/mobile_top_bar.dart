import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/auth/login_signup_screen.dart';
import 'package:guyana_center_frontend/screens/side_menu_screen.dart';

class MobileTopBar extends StatelessWidget {
  const MobileTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 60,
      // padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => InkWell(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              borderRadius: BorderRadius.circular(12),
              child: IconButton(
                onPressed: () => Get.to(SideMenuScreen()),
                icon: Icon(
                  Icons.menu_rounded,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  size: 24,
                ),
              ),
            ),
          ),

          const Expanded(child: GuyanaCentralLogo()),
          const SizedBox(width: 8),
          SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: () => Get.to(const LoginSignupScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                "Login",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class GuyanaCentralLogo extends StatelessWidget {
  const GuyanaCentralLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RichText(
      text: TextSpan(
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          color: isDark ? Colors.white : const Color(0xFF111827),
          fontSize: 17,
        ),
        children: [
          const TextSpan(text: "GUYANA"),
          const TextSpan(
            text: "CENTRAL",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFFFFA43A),
            ),
          ),
        ],
      ),
    );
  }
}
