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
        Builder(
          builder: (ctx) => InkWell(
            onTap: () => Scaffold.of(ctx).openDrawer(),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: IconButton(
                onPressed: () => Get.to(SideMenuScreen()),
                icon: Icon(Icons.menu_rounded, size: 22),
                color: cs.onSurface,
              ),
            ),
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
