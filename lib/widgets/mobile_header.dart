import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/screens/side_menu_screen.dart';
import 'package:guyana_center_frontend/widgets/mobile_top_bar.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';

class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Transform.translate(
          offset: const Offset(-4, 0), // Nudge left to account for icon padding
          child: IconButton(
            onPressed: () => Get.to(() => const SideMenuScreen()),
            icon: Icon(
              Icons.menu_rounded,
              size: 28,
              color: cs.onSurface,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 10),

        const Expanded(child: GuyanaCentralLogo()),

        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.5),
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
}
