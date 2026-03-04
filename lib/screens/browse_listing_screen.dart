import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:guyana_center_frontend/controller/browse_llisting_controller.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';
import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/widgets/app_drawar.dart';
import 'package:guyana_center_frontend/widgets/guyana_central_logo.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';

class CategoryListingsScreen extends StatefulWidget {
  final BrowseCategoryVM category;
  const CategoryListingsScreen({super.key, required this.category});

  @override
  State<CategoryListingsScreen> createState() => _CategoryListingsScreenState();
}

class _CategoryListingsScreenState extends State<CategoryListingsScreen> {
  late final BrowseListingController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(BrowseListingController());
    c.initWithCategory(widget.category);
  }

  @override
  void dispose() {
    Get.delete<BrowseListingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          children: [
            Row(
              children: [
                Builder(
                  builder: (ctx) => InkWell(
                    onTap: () => Scaffold.of(ctx).openDrawer(),
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
                const Expanded(child: GuyanaCentralLogo()),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search_rounded, color: cs.onSurface),
                ),
                const SizedBox(width: 4),
                ProfileDot(
                  onTap: () {
                    Get.to(AgentProfileScreen());
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            BreadcrumbRow(current: widget.category.title),
            const SizedBox(height: 10),

            Row(
              children: [
                Icon(
                  Icons.directions_car_filled_rounded,
                  size: 18,
                  color: cs.onSurface,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.category.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Obx(() {
              return _StatsStrip(
                listings: c.listingsCount.value,
                newCount: c.updated.value,
                rating: c.rating.value,
              );
            }),

            const SizedBox(height: 20),

            SizedBox(
              height: 44,
              child: Obx(() {
                final tabs = c.chips;
                final active = c.chipIndex.value;

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) => _TabPill(
                    text: tabs[i],
                    active: i == active,
                    onTap: () => c.setChip(i),
                  ),
                );
              }),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: c.setSearch,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          "Search ${widget.category.title.toLowerCase()}...",
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant.withOpacity(.7),
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: cs.onSurfaceVariant,
                      ),
                      filled: true,
                      fillColor: cs.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.primary, width: 1.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.tune_rounded, color: cs.onSurfaceVariant),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Obx(() {
                  return Text(
                    "Showing ${c.totalFilteredCount} results",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(.55),
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }),
                const Spacer(),
                Text(
                  "Newest First",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(.55),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(width: 8),
                Obx(() {
                  final grid = c.isGrid.value;
                  return InkWell(
                    onTap: c.toggleView,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        grid
                            ? Icons.grid_view_rounded
                            : Icons.view_agenda_rounded,
                        color: cs.onPrimary,
                        size: 18,
                      ),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 12),

            Obx(() {
              final list = c.filteredListings;
              final grid = c.isGrid.value;

              if (list.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      "No Listings Found",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface.withOpacity(.55),
                      ),
                    ),
                  ),
                );
              }

              if (!grid) {
                return Column(
                  children: list
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ListingCardList(item: item),
                        ),
                      )
                      .toList(),
                );
              }

              return GridView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (_, i) => ListingCardGrid(item: list[i]),
              );
            }),

            const SizedBox(height: 14),

            Obx(() {
              final p = c.currentPage.value;
              final tp = c.totalPages.value;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => c.goToPage(p - 1),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: cs.onSurface.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ...List.generate(tp, (i) {
                    final page = i + 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: PageDot(
                        text: "$page",
                        active: page == p,
                        onTap: () => c.goToPage(page),
                      ),
                    );
                  }),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () => c.goToPage(p + 1),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: cs.onSurface.withOpacity(.7),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 18),

            Text(
              "Browse Other Categories",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                OtherCategoryIcon(
                  icon: Icons.home_work_outlined,
                  text: "Real Estate",
                ),
                OtherCategoryIcon(
                  icon: Icons.work_outline_rounded,
                  text: "Jobs",
                ),
                OtherCategoryIcon(
                  icon: Icons.electrical_services_outlined,
                  text: "Electronics",
                ),
                OtherCategoryIcon(
                  icon: Icons.chair_outlined,
                  text: "Furniture",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BreadcrumbRow extends StatelessWidget {
  final String current;
  const BreadcrumbRow({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Text(
          "Home  >  ",
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withOpacity(.35),
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
          ),
        ),
        Text(
          current,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w800,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }
}

class _StatsStrip extends StatelessWidget {
  final String listings;
  final String newCount;
  final String rating;

  const _StatsStrip({
    required this.listings,
    required this.newCount,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          listings,
          style: theme.textTheme.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "listings",
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 15,
            color: cs.onSurface.withOpacity(.55),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 14),
        Container(width: 1, height: 18, color: cs.outlineVariant),
        const SizedBox(width: 14),
        Text(
          newCount,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "new",
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 15,
            color: cs.onSurface.withOpacity(.55),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 14),
        Container(width: 1, height: 18, color: cs.outlineVariant),
        const SizedBox(width: 14),
        const Icon(Icons.star_rounded, size: 20, color: Color(0xFFFFB020)),
        const SizedBox(width: 6),
        Text(
          rating,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _TabPill({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: active ? cs.primary : cs.outlineVariant),
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: active ? cs.onPrimary : cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class ListingCardGrid extends StatelessWidget {
  final ListingVM item;
  const ListingCardGrid({super.key, required this.item});

  Color _badgeColor() {
    final t = (item.badge ?? "").toLowerCase();
    if (t == "sale") return const Color(0xFF22C55E);
    if (t == "new") return const Color(0xFF3B82F6);
    return const Color(0xFFFFB020);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 11,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: cs.surfaceVariant,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                if (item.badge != null)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _badgeColor(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.badge!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.price,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(.55),
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.timeAgo,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(.45),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
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

class ListingCardList extends StatelessWidget {
  final ListingVM item;
  const ListingCardList({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(18),
            ),
            child: SizedBox(
              width: 110,
              height: 110,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: cs.surfaceVariant,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.price,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.location,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(.55),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.timeAgo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(.45),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageDot extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const PageDot({
    super.key,
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? cs.primary : cs.outlineVariant),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: active ? cs.onPrimary : cs.onSurface.withOpacity(.65),
          ),
        ),
      ),
    );
  }
}

class OtherCategoryIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  const OtherCategoryIcon({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: cs.onSurface.withOpacity(.65),
          ),
        ),
      ],
    );
  }
}
