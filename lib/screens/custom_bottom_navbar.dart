import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/custom_bottom_nav_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final CustomBottomNavController c = Get.find<CustomBottomNavController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Bar bg: light => background, dark => surface
    final barColor = theme.brightness == Brightness.dark
        ? cs.surface
        : cs.background;

    // Inactive icon/text color: aapki theme ke hisab se
    final inactive = cs.onSurfaceVariant;

    // Shadow: dark mode me thoda soft
    final shadow = theme.brightness == Brightness.dark
        ? Colors.black.withOpacity(0.35)
        : Colors.black.withOpacity(0.08);

    return Obx(() {
      final currentIndex = c.index.value;

      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // ✅ Full-width straight bar (theme based)
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: barColor,
              boxShadow: [
                BoxShadow(
                  color: shadow,
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
                    inactiveColor: inactive,
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.search_rounded,
                    label: "Browse",
                    active: currentIndex == 1,
                    onPressed: () => c.changeTab(1),
                    inactiveColor: inactive,
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
                    inactiveColor: inactive,
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.settings_outlined,
                    label: "Settings",
                    active: currentIndex == 4,
                    onPressed: () => c.changeTab(4),
                    inactiveColor: inactive,
                  ),
                ),
              ],
            ),
          ),

          // ✅ Floating center "Sell" button (theme primary)
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
                      color: cs.primary, // ✅ kPrimaryColor will come here
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withOpacity(
                            theme.brightness == Brightness.dark ? 0.25 : 0.45,
                          ),
                          blurRadius: 26,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: cs.onPrimary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Sell",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
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
  final Color inactiveColor;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onPressed,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: active ? cs.primary : inactiveColor),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? cs.primary : inactiveColor,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
