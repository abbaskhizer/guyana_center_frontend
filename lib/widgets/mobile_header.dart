import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/notification_controller.dart';
import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/screens/notification_screen.dart';
import 'package:guyana_center_frontend/screens/side_menu_screen.dart';
import 'package:guyana_center_frontend/widgets/mobile_top_bar.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';

class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final notifController = Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put(NotificationController());

    return Row(
      children: [
        Transform.translate(
          offset: const Offset(-4, 0),
          child: IconButton(
            onPressed: () => Get.to(() => const SideMenuScreen()),
            icon: Icon(Icons.menu_rounded, size: 28, color: cs.onSurface),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 10),

        const Expanded(child: GuyanaCentralLogo()),

        const SizedBox(width: 12),

        Obx(() {
          final count = notifController.unreadCount.value;
          return GestureDetector(
            onTap: () {
              print('🔔 Notification bell tapped');
              print('🔔 Current route: ${Get.currentRoute}');
              final result = Get.toNamed('/notifications');
              print('🔔 Navigation result: $result');
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
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
                  child: Icon(
                    Icons.notifications_rounded,
                    size: 18,
                    color: count > 0 ? cs.primary : const Color(0xFF6B7280),
                  ),
                ),
                if (count > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        count > 9 ? '9+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),

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
