import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/auth/login_signup_screen.dart';
import 'package:guyana_center_frontend/screens/side_menu_screen.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';
import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/controller/message_controller.dart';

class MobileTopBar extends StatelessWidget {
  const MobileTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 60,
      // padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
        Transform.translate(
          offset: const Offset(-4, 0),
          child: Stack(
            children: [
              IconButton(
                onPressed: () => Get.to(() => const SideMenuScreen()),
                icon: Icon(
                  Icons.menu_rounded,
                  size: 28,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Obx(() {
                final msgController = Get.isRegistered<MessagesController>() 
                    ? Get.find<MessagesController>() 
                    : Get.put(MessagesController(), permanent: true);
                if (msgController.totalUnreadCount > 0) {
                  return Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
        const SizedBox(width: 10),

          const Expanded(child: GuyanaCentralLogo()),
          const SizedBox(width: 8),
          Obx(() {
            if (AuthService.to.isLoggedIn.value) {
              return Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          size: 18,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Positioned(
                        right: 2,
                        top: 3,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF7A2F),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  ProfileDot(
                    onTap: () {
                      Get.to(() => const AgentProfileScreen());
                    },
                  ),
                ],
              );
            }

            return SizedBox(
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
            );
          }),
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
