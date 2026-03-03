import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:guyana_center_frontend/controller/bottomNavbar/all_category_controller.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/screens/browse_listing_screen.dart';
import 'package:guyana_center_frontend/widgets/guyana_central_logo.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';

class AllCategoryScreen extends StatelessWidget {
  final List<BrowseCategoryVM> categories;
  const AllCategoryScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AllCategoryController());
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (c.categories.isEmpty) {
      final list = categories
          .where((e) => e.id.toLowerCase() != "all")
          .toList();
      c.setCategories(list);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.menu_rounded,
                          color: cs.onSurface,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: GuyanaCentralLogo()),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ProfileDot(
                    onTap: () {
                      Get.to(AgentProfileScreen());
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ✅ Breadcrumb
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Text(
                    "Home  > Categories  ",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(.35),
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                  ),
                  Text(
                    "All Categories",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ✅ Title
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: Text(
                "All Categories",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ✅ Subtitle
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: Obx(() {
                final count = c.categories.length;
                return Text(
                  "Browse $count categories with 55,000+ listings across\nvehicles, real estate, electronics & more.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(.55),
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
            ),

            const SizedBox(height: 14),

            // ✅ Collage row (same as figma)
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: const _CollageRow(),
            ),

            const SizedBox(height: 12),

            // ✅ Stats row (same as figma)
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      value: "55,000+",
                      label: "Active Listings",
                      valueColor: Color(0xFFFF0000),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      value: "1,100+",
                      label: "New Daily",
                      valueColor: Color(0xFFFF0000),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      value: "10K+",
                      label: "Happy Users",
                      valueColor: Color(0xFFFF0000),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ✅ Search

            // ✅ List header row
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: Obx(() {
                final count = c.filtered.length;
                return Row(
                  children: [
                    Text(
                      "All Categories",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "$count categories",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(.55),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 10),

            // ✅ Categories list (same tile design)
            Obx(() {
              final list = c.filtered;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,

                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  children: List.generate(list.length, (i) {
                    final item = list[i];
                    final expanded = c.isExpanded(item.id);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _CategoryTile(
                        item: item,
                        expanded: expanded,
                        onChevronTap: () => c.toggleExpanded(item.id),
                        onTap: () => Get.to(
                          () => CategoryListingsScreen(category: item),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CollageRow extends StatelessWidget {
  const _CollageRow();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget frame({required String imageUrl, double? h, double? w}) {
      return Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: cs.surface,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: cs.primary,
                ),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              color: cs.surface,
              alignment: Alignment.center,
              child: Icon(
                Icons.broken_image_outlined,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: frame(
            h: 140,
            imageUrl:
                "https://images.pexels.com/photos/373912/pexels-photo-373912.jpeg?auto=compress&cs=tinysrgb&w=900",
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            frame(
              w: 120,
              h: 65,
              imageUrl:
                  "https://images.pexels.com/photos/3760067/pexels-photo-3760067.jpeg?auto=compress&cs=tinysrgb&w=800",
            ),
            const SizedBox(height: 10),
            frame(
              w: 120,
              h: 65,
              imageUrl:
                  "https://images.pexels.com/photos/3184292/pexels-photo-3184292.jpeg?auto=compress&cs=tinysrgb&w=800",
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: valueColor,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.5,
              color: cs.onSurface.withOpacity(.55),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final BrowseCategoryVM item;
  final bool expanded;
  final VoidCallback onChevronTap;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.item,
    required this.expanded,
    required this.onChevronTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: item.tint ?? cs.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        item.assetImage ?? "assets/vehicle.png",
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.broken_image_outlined,
                          color: cs.onSurface.withOpacity(.35),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: cs.onSurface,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withOpacity(.55),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: onChevronTap,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: cs.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        alignment: Alignment.center,
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 180),
                          turns: expanded ? 0.5 : 0,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: cs.onSurface.withOpacity(.45),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox(height: 0),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.onSurface.withOpacity(.03),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Text(
                        "Subcategories / filters can be shown here.",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
