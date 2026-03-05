import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/auth/login_signup_screen.dart';
import 'package:guyana_center_frontend/widgets/app_drawar.dart';

class MobileTopBar extends StatelessWidget {
  const MobileTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(12),
          child: IconButton(
            onPressed: () => AppDrawer(),
            icon: Icon(Icons.menu_rounded, color: cs.onSurface, size: 22),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: GuyanaCentralLogo()),
        SizedBox(
          height: 34,
          child: ElevatedButton(
            onPressed: () => Get.to(LoginSignupScreen()),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              "Login",
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
