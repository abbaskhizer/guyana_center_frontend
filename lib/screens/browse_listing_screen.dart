import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:guyana_center_frontend/controller/browse_llisting_controller.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';

import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';

import 'package:guyana_center_frontend/widgets/app_drawar.dart';
import 'package:guyana_center_frontend/widgets/mobile_top_bar.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';

import 'package:guyana_center_frontend/widgets/web_footer.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';

class CategoryListingsScreen extends StatefulWidget {
  final BrowseCategoryVM category;
  const CategoryListingsScreen({super.key, required this.category});

  @override
  State<CategoryListingsScreen> createState() => _CategoryListingsScreenState();
}

class _CategoryListingsScreenState extends State<CategoryListingsScreen> {
  late final BrowseListingController c;

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  void initState() {
    super.initState();
    c = Get.put(BrowseListingController(), permanent: false);
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
    final isWeb = _isWebDesktop(context);

    return Scaffold(
      backgroundColor: isWeb ? Colors.white : theme.scaffoldBackgroundColor,
      drawer: isWeb ? null : const AppDrawer(),
      bottomNavigationBar: isWeb ? null : CustomBottomNavBar(),
      body: SafeArea(
        child: isWeb
            ? _WebLayout(category: widget.category, controller: c)
            : _MobileLayout(category: widget.category, controller: c),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final BrowseCategoryVM category;
  final BrowseListingController controller;
  const _MobileLayout({required this.category, required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      // ✅ bottom nav overlap fix (pagination hide hoti thi)
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
      children: [
        _MobileTopBar(),
        const SizedBox(height: 10),

        _BreadcrumbRow(current: category.title),
        const SizedBox(height: 10),

        _TitleRow(category: category),
        const SizedBox(height: 14),

        Obx(
          () => _StatsStrip(
            listings: controller.listingsCount.value,
            newCount: controller.updated.value,
            rating: controller.rating.value,
          ),
        ),
        const SizedBox(height: 16),

        _ChipRow(controller: controller),
        const SizedBox(height: 12),

        _SearchAndFilterRow(
          controller: controller,
          hint: "Search ${category.title.toLowerCase()}...",
          isWeb: false,
        ),
        const SizedBox(height: 12),

        _ResultsHeaderRow(controller: controller),
        const SizedBox(height: 12),

        _ListingsSection(controller: controller, isWeb: false),
        const SizedBox(height: 14),

        // ✅ screenshot wali pagination (mobile)
        _PaginationBar(controller: controller),
        const SizedBox(height: 18),

        Text(
          "Browse Other Categories",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        const _OtherCategoriesRow(),
      ],
    );
  }
}

class _WebLayout extends StatelessWidget {
  final BrowseCategoryVM category;
  final BrowseListingController controller;
  const _WebLayout({required this.category, required this.controller});

  double _contentMaxWidth(double w) {
    if (w >= 1440) return 1120;
    if (w >= 1200) return 1120;
    return w - 48;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = _contentMaxWidth(constraints.maxWidth);

        Widget centered(Widget child, {EdgeInsets padding = EdgeInsets.zero}) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Padding(padding: padding, child: child),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: WebHeader()),

            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(
                        0xFF161616,
                      ) // Match Figma Dark header specifically like All categories
                    : Colors.white,
                child: centered(
                  Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 0),
                    child: _WebPageHeader(
                      category: category,
                      controller: controller,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).scaffoldBackgroundColor
                    : const Color(0xFFFAFAFA),
                child: centered(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      _SearchAndFilterRow(
                        controller: controller,
                        hint: "Search in ${category.title}...",
                        isWeb: true,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        "Showing ${controller.totalFilteredCount} results",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(.45),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _ListingsSection(controller: controller, isWeb: true),
                      const SizedBox(height: 48),

                      // ✅ screenshot wali pagination (web)
                      _PaginationBar(controller: controller),
                      const SizedBox(height: 64),

                      Text(
                        "Browse Other Categories",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const _OtherCategoriesRowWeb(),
                      const SizedBox(height: 32),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(color: cs.surface, child: WebFooter()),
            ),
          ],
        );
      },
    );
  }
}

class _MobileTopBar extends StatelessWidget {
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
              child: Icon(Icons.menu_rounded, color: cs.onSurface, size: 22),
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
        ProfileDot(onTap: () => Get.to(() => AgentProfileScreen())),
      ],
    );
  }
}

class _BreadcrumbRow extends StatelessWidget {
  final String current;
  const _BreadcrumbRow({required this.current});

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
          "All Categories  >  ",
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

class _TitleRow extends StatelessWidget {
  final BrowseCategoryVM category;
  const _TitleRow({required this.category});

  IconData _iconForCategory(String title) {
    final t = title.toLowerCase();
    if (t.contains("vehicle") || t.contains("car")) return Icons.directions_car;
    if (t.contains("job")) return Icons.work_outline_rounded;
    if (t.contains("real")) return Icons.home_work_outlined;
    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Icon(_iconForCategory(category.title), size: 18, color: cs.onSurface),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            category.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _WebPageHeader extends StatelessWidget {
  final BrowseCategoryVM category;
  final BrowseListingController controller;
  const _WebPageHeader({required this.category, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Home",
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(.45),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: cs.onSurface.withOpacity(.35),
            ),
            const SizedBox(width: 8),
            Text(
              "Categories",
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(.45),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: cs.onSurface.withOpacity(.35),
            ),
            const SizedBox(width: 8),
            Text(
              category.title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(.8),
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: category.assetImage != null
                  ? Image.asset(
                      category.assetImage!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      "assets/vehicle.png",
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                      fontSize: 30, // big and bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Cars, trucks, motorcycles & more",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withOpacity(.4),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => _StatsStrip(
                listings: controller.listingsCount.value,
                newCount: controller.updated.value,
                rating: controller.rating.value,
                dense: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        const SizedBox(height: 16),
        _ChipRow(controller: controller),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _StatsStrip extends StatelessWidget {
  final String listings;
  final String newCount;
  final String rating;
  final bool dense;

  const _StatsStrip({
    required this.listings,
    required this.newCount,
    required this.rating,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final valueStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w900,
      fontSize: dense ? 14 : 20,
      color: cs.onSurface,
    );

    if (dense) {
      Widget columnStat(String val, String lbl, Color valueColor) {
        return Column(
          children: [
            Text(
              val,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: valueColor,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              lbl,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: cs.onSurface.withOpacity(.4),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            columnStat(listings, "Total Ads", const Color(0xFF16A34A)),
            const SizedBox(width: 42),
            columnStat(newCount, "New Today", cs.onSurface),
            const SizedBox(width: 42),
            columnStat(rating, "Avg. Rating", const Color(0xFFD97706)),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(listings, style: valueStyle?.copyWith(color: cs.primary)),
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
        Text(newCount, style: valueStyle),
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
        const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFB020)),
        const SizedBox(width: 6),
        Text(
          rating,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ChipRow extends StatelessWidget {
  final BrowseListingController controller;
  const _ChipRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Obx(() {
        final tabs = controller.chips;
        final active = controller.chipIndex.value;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 20),
          itemBuilder: (_, i) => Center(
            child: _TabPill(
              text: tabs[i],
              active: i == active,
              onTap: () => controller.setChip(i),
            ),
          ),
        );
      }),
    );
  }
}

class _SearchAndFilterRow extends StatelessWidget {
  final BrowseListingController controller;
  final String hint;
  final bool isWeb;

  const _SearchAndFilterRow({
    required this.controller,
    required this.hint,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final field = TextField(
      onChanged: controller.setSearch,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: cs.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: cs.onSurfaceVariant.withOpacity(.7),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant),
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
    );

    final filterBtn = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.tune_rounded, color: cs.onSurfaceVariant),
    );

    if (!isWeb) {
      return Row(
        children: [
          Expanded(child: field),
          const SizedBox(width: 10),
          filterBtn,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 4, child: SizedBox(height: 48, child: field)),
        const SizedBox(width: 16),
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? cs.surface
                  : Colors.white,
              foregroundColor: cs.onSurface,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.transparent
                      : cs.outlineVariant,
                ),
              ),
              textStyle: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: const Text("Filters"),
          ),
        ),
        const Spacer(flex: 2),
        const Spacer(flex: 3),
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? cs.surface
                  : Colors.white,
              foregroundColor: cs.onSurface,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.transparent
                      : cs.outlineVariant,
                ),
              ),
              textStyle: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            icon: Icon(
              Icons.swap_vert_rounded,
              size: 18,
              color: cs.onSurface.withOpacity(.6),
            ),
            label: const Text("Newest First"),
          ),
        ),
        const SizedBox(width: 16),
        Obx(() {
          final grid = controller.isGrid.value;
          return Container(
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? cs.surface
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : cs.outlineVariant,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => controller.toggleView(),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: grid
                          ? cs.surfaceVariant.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.grid_view_rounded,
                      size: 18,
                      color: grid ? cs.onSurface : cs.onSurface.withOpacity(.4),
                    ),
                  ),
                ),
                Container(width: 1, height: 48, color: cs.outlineVariant),
                InkWell(
                  onTap: () => controller.toggleView(),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: !grid
                          ? cs.surfaceVariant.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.format_list_bulleted_rounded,
                      size: 18,
                      color: !grid
                          ? cs.onSurface
                          : cs.onSurface.withOpacity(.4),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ResultsHeaderRow extends StatelessWidget {
  final BrowseListingController controller;
  const _ResultsHeaderRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Obx(() {
          return Text(
            "Showing ${controller.totalFilteredCount} results",
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
        const SizedBox(width: 10),
        Obx(() {
          final grid = controller.isGrid.value;
          return InkWell(
            onTap: controller.toggleView,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                grid ? Icons.grid_view_rounded : Icons.view_agenda_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 18,
              ),
            ),
          );
        }),
      ],
    );
  }
}

/// ✅ FIXED: grid card height (web + mobile)
class _ListingsSection extends StatelessWidget {
  final BrowseListingController controller;
  final bool isWeb;
  const _ListingsSection({required this.controller, required this.isWeb});

  int _colsForWidth(double w) {
    if (!isWeb) return 2;
    if (w >= 980) return 4;
    if (w >= 760) return 3;
    if (w >= 520) return 2;
    return 1;
  }

  double _extentForCols(int cols) {
    if (!isWeb) return 280;
    if (cols >= 4) return 305;
    if (cols == 3) return 330;
    if (cols == 2) return 350;
    return 370;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final list = controller.filteredListings;
      final grid = controller.isGrid.value;

      if (list.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Text(
              "No Listings Found",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

      return LayoutBuilder(
        builder: (context, constraints) {
          final cols = _colsForWidth(constraints.maxWidth);
          const spacing = 12.0;

          return GridView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              mainAxisExtent: _extentForCols(cols),
            ),
            itemBuilder: (_, i) => ListingCardGrid(item: list[i]),
          );
        },
      );
    });
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF16A34A) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : cs.onSurface.withOpacity(.65),
          ),
        ),
      ),
    );
  }
}

/// ✅ Pagination bar (‹ 1 2 3 … 24 ›)
class _PaginationBar extends StatelessWidget {
  final BrowseListingController controller;
  const _PaginationBar({required this.controller});

  List<int> _visiblePages(int current, int total) {
    if (total <= 5) return List.generate(total, (i) => i + 1);

    final out = <int>{1, 2, 3, total};

    if (current >= total - 2) {
      out.addAll({total - 2, total - 1});
    }
    if (current > 3 && current < total) out.add(current);

    final list = out.where((p) => p >= 1 && p <= total).toList()..sort();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final p = controller.currentPage.value;
      final tp = controller.totalPages.value;

      final tpSafe = tp < 1 ? 1 : tp;
      final pSafe = p.clamp(1, tpSafe);

      // ✅ show only when pages > 1
      if (tpSafe <= 1) return const SizedBox.shrink();

      final pages = _visiblePages(pSafe, tpSafe);

      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PagerArrow(
              icon: Icons.chevron_left_rounded,
              enabled: pSafe > 1,
              onTap: () => controller.goToPage(pSafe - 1),
            ),
            const SizedBox(width: 8),
            for (int i = 0; i < pages.length; i++) ...[
              if (i > 0 && pages[i] - pages[i - 1] > 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    "…",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              _PagePill(
                text: "${pages[i]}",
                active: pages[i] == pSafe,
                onTap: () => controller.goToPage(pages[i]),
                activeColor: const Color(0xFF16A34A),
                inactiveBorder: cs.outlineVariant,
              ),
              const SizedBox(width: 6),
            ],
            _PagerArrow(
              icon: Icons.chevron_right_rounded,
              enabled: pSafe < tpSafe,
              onTap: () => controller.goToPage(pSafe + 1),
            ),
          ],
        ),
      );
    });
  }
}

class _PagerArrow extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PagerArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).colorScheme.outlineVariant;
    final iconColor = const Color(0xFF9CA3AF);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Opacity(
        opacity: enabled ? 1 : 0.35,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.surface
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: iconColor),
        ),
      ),
    );
  }
}

class _PagePill extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveBorder;

  const _PagePill({
    required this.text,
    required this.active,
    required this.onTap,
    required this.activeColor,
    required this.inactiveBorder,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? activeColor
              : (Theme.of(context).brightness == Brightness.dark
                    ? cs.surface
                    : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? activeColor : inactiveBorder),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            fontSize: 12,
            color: active ? Colors.white : cs.onSurface.withOpacity(.45),
          ),
        ),
      ),
    );
  }
}

class _OtherCategoriesRow extends StatelessWidget {
  const _OtherCategoriesRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OtherCategoryIcon(icon: Icons.home_work_outlined, text: "Real Estate"),
        OtherCategoryIcon(icon: Icons.work_outline_rounded, text: "Jobs"),
        OtherCategoryIcon(
          icon: Icons.electrical_services_outlined,
          text: "Electronics",
        ),
        OtherCategoryIcon(icon: Icons.chair_outlined, text: "Furniture"),
      ],
    );
  }
}

class _OtherCategoriesRowWeb extends StatelessWidget {
  const _OtherCategoriesRowWeb();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StandaloneCategoryCard(
          image: "assets/realestate.png",
          text: "Real Estate",
        ),
        const SizedBox(width: 14),
        _StandaloneCategoryCard(image: "assets/jobs.png", text: "Jobs"),
        const SizedBox(width: 14),
        _StandaloneCategoryCard(
          image: "assets/electronics.png",
          text: "Electronics",
        ),
        const SizedBox(width: 14),
        _StandaloneCategoryCard(image: "assets/fashion.png", text: "Fashion"),
        const SizedBox(width: 14),
        _StandaloneCategoryCard(
          image: "assets/home&gardan.png",
          text: "Home & Furniture",
        ),
        const SizedBox(width: 14),
        _StandaloneCategoryCard(
          image: "assets/sports&hobbies.png",
          text: "Sports & Hobbies",
        ),
      ],
    );
  }
}

class _StandaloneCategoryCard extends StatelessWidget {
  final String image;
  final String text;

  const _StandaloneCategoryCard({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? cs.surface
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.transparent
                : cs.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFF0FDF4),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                image,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtherCategoryIcon extends StatelessWidget {
  final IconData? icon;
  final String text;
  final String? image;

  const OtherCategoryIcon({
    super.key,
    this.icon,
    required this.text,
    this.image,
  });

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
          child: image != null
              ? Image.asset(image!, width: 24, height: 24, fit: BoxFit.contain)
              : Icon(icon ?? Icons.category, color: cs.onSurfaceVariant),
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

class ListingCardGrid extends StatelessWidget {
  final ListingVM item;
  const ListingCardGrid({super.key, required this.item});

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
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAB308), // Figma: Orange yellow
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.whatshot_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.badge!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "7",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.favorite_border_rounded,
                          color: cs.onSurfaceVariant,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7), // light green
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Used",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF16A34A),
                            fontWeight: FontWeight.w800,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.subType.isEmpty ? "Cars for Sale" : item.subType,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(.4),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.price,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF16A34A), // Deep green like design
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(flex: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: cs.onSurface.withOpacity(.4),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurface.withOpacity(.5),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: cs.onSurface.withOpacity(.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.timeAgo,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withOpacity(.5),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
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
