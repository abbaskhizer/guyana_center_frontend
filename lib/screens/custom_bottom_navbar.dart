import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/custom_bottom_nav_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final CustomBottomNavController c = Get.find<CustomBottomNavController>();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Obx(() {
      final currentIndex = c.index.value;

      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // ✅ Full-width straight bar (NO rounded corners, NO side/bottom gap)
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _NavItem(
                    icon: Icons.home_outlined,
                    label: "Home",
                    active: currentIndex == 0,
                    onPressed: () => c.changeTab(0),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.search_rounded,
                    label: "Browse",
                    active: currentIndex == 1,
                    onPressed: () => c.changeTab(1),
                  ),
                ),

                // ✅ Middle space for floating button
                const Expanded(child: SizedBox()),

                Expanded(
                  child: _NavItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: "Messages",
                    active: currentIndex == 3,
                    onPressed: () => c.changeTab(3),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.settings_outlined,
                    label: "Settings",
                    active: currentIndex == 4,
                    onPressed: () => c.changeTab(4),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Floating center "Sell" button
          Positioned(
            top: -28,
            child: GestureDetector(
              onTap: () => c.changeTab(2),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.45),
                          blurRadius: 26,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Sell",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primary,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onPressed;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final inactive = const Color(0xFF9AA3B2);

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: active ? primary : inactive),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? primary : inactive,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
