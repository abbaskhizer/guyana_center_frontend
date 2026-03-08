import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/browse_search_listing_controller.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';

class BrowseSearchesListingScreen extends StatelessWidget {
  const BrowseSearchesListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final controller = Get.isRegistered<BrowseSearchesListingController>()
        ? Get.find<BrowseSearchesListingController>()
        : Get.put(BrowseSearchesListingController());

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: cs.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: cs.surfaceVariant,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.notifications_none_rounded,
                                size: 18,
                                color: cs.onSurfaceVariant,
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
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Favorite Searches",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(
                        () => Text(
                          "${controller.searches.length} saved searches",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 36,
                child: Obx(
                  () => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final item = controller.categories[index];
                      final label = item["label"] as String;
                      final icon = item["icon"] as IconData;
                      final active = controller.selectedCategory.value == label;

                      return GestureDetector(
                        onTap: () => controller.setCategory(label),
                        child: _Mini(text: label, icon: icon, active: active),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              color: cs.surface,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Obx(
                      () => Column(
                        children: List.generate(controller.searches.length, (
                          index,
                        ) {
                          final item = controller.searches[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == controller.searches.length - 1
                                  ? 0
                                  : 20,
                            ),
                            child: Obx(
                              () => _SavedSearchCard(
                                title: item.title,
                                icon: item.icon,
                                alertsOn: item.alertsOn.value,
                                onToggleAlerts: () =>
                                    controller.toggleAlerts(index),
                                onDelete: () => controller.removeSearch(index),
                                onView: () => controller.viewSearch(item),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Find more deals",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Search & save instantly",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 38,
                            child: ElevatedButton.icon(
                              onPressed: controller.searchMore,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF5B301),
                                foregroundColor: const Color(0xFF1F2937),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              icon: const Icon(Icons.search_rounded, size: 16),
                              label: const Text(
                                "search",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final String text;
  final bool active;
  final IconData icon;

  const _Mini({required this.text, required this.icon, this.active = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF179C2E) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: active ? Colors.white : cs.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedSearchCard extends StatelessWidget {
  final String title;
  final String icon;
  final bool alertsOn;
  final VoidCallback onToggleAlerts;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const _SavedSearchCard({
    required this.title,
    required this.icon,
    required this.alertsOn,
    required this.onToggleAlerts,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    icon,
                    height: 20,
                    width: 20,
                    color: cs.primary,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onToggleAlerts,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 20,
                          color: alertsOn ? cs.primary : cs.surface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Divider(color: cs.outlineVariant),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 45,
                width: 150,
                child: ElevatedButton(
                  onPressed: onView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "View",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 17),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFE3F0E4),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Row(
              children: [
                const Text("🔔", style: TextStyle(fontSize: 11)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    alertsOn
                        ? "Alerts active — you'll be notified of new listings"
                        : "Alerts off — notifications disabled",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: alertsOn
                          ? const Color(0xFF2E7D32)
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
