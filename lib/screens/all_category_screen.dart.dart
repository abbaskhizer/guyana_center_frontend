import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:guyana_center_frontend/controller/bottomNavbar/all_category_controller.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/screens/browse_listing_screen.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/widgets/mobile_top_bar.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';

class AllCategoryScreen extends StatelessWidget {
  final List<BrowseCategoryVM> categories;
  const AllCategoryScreen({super.key, required this.categories});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllCategoryController(), permanent: true);
    final theme = Theme.of(context);

    if (controller.categories.isEmpty) {
      controller.setCategories(
        categories.where((e) => e.id.toLowerCase() != "all").toList(),
      );
    }

    return Scaffold(
      backgroundColor: _isWebDesktop(context)
          ? theme.colorScheme.background
          : theme.scaffoldBackgroundColor,
      bottomNavigationBar: _isWebDesktop(context) ? null : CustomBottomNavBar(),
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebLayout(controller: controller)
            : _MobileLayout(controller: controller),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final AllCategoryController controller;
  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 15),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MobileTopBar(),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _BreadcrumbTitleBlock(isWeb: false),
        ),
        const SizedBox(height: 14),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _CollageSection(isWeb: false),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _StatsRow(isWeb: false),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _ListHeaderRow(controller: controller),
        ),
        const SizedBox(height: 10),
        _CategoryListMobile(controller: controller),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _WebLayout extends StatelessWidget {
  final AllCategoryController controller;
  const _WebLayout({required this.controller});

  double _contentMaxWidth(double w) {
    if (w >= 1440) return 1120;
    if (w >= 1200) return 1120;
    if (w >= 1000) return 980;
    return w - 32;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = _contentMaxWidth(constraints.maxWidth);

        Widget centered(
          Widget child, {
          EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16),
        }) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Padding(padding: padding, child: child),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const WebHeader(),
                  Container(
                    width: double.infinity,
                    color: theme.colorScheme.background,
                    child: centered(
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 14, 0, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _WebBreadcrumbLine(),
                            const SizedBox(height: 10),
                            _WebTitleAndSearchRow(controller: controller),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: cs.surface,
                child: centered(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),
                      const _WebMostPopularLabel(),
                      const SizedBox(height: 10),
                      const _CollageSection(isWeb: true),
                      const SizedBox(height: 14),
                      const _StatsRow(isWeb: true),
                      const SizedBox(height: 18),
                      _WebCategoriesContainer(controller: controller),
                      const SizedBox(height: 22),
                      const _NeedHelpCta(),
                      const SizedBox(height: 28),
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

class _BreadcrumbTitleBlock extends StatelessWidget {
  final bool isWeb;
  const _BreadcrumbTitleBlock({required this.isWeb});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final c = Get.find<AllCategoryController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isWeb)
          Row(
            children: [
              Text(
                "Home > ",
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
        const SizedBox(height: 8),
        Text(
          "All Categories",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
            fontSize: isWeb ? 28 : null,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() {
          final count = c.categories.length;
          return Text(
            "Browse $count categories with 55,000+ listings across\n"
            "vehicles, real estate, electronics & more.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.55),
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          );
        }),
      ],
    );
  }
}

class _WebBreadcrumbLine extends StatelessWidget {
  const _WebBreadcrumbLine();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Text(
      "All categories",
      style: theme.textTheme.bodySmall?.copyWith(
        color: cs.onSurface.withOpacity(.45),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _WebTitleAndSearchRow extends StatelessWidget {
  final AllCategoryController controller;
  const _WebTitleAndSearchRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: _BreadcrumbTitleBlock(isWeb: true)),
        const SizedBox(width: 14),
        SizedBox(
          width: 520,
          child: Row(
            children: [
              Expanded(
                child: _SearchField(
                  hint: "Search categories...",
                  onChanged: controller.setSearch,
                  height: 44,
                ),
              ),
              const SizedBox(width: 10),
              const _WebIconBtn(icon: Icons.tune_rounded),
              const SizedBox(width: 10),
              const _WebIconBtn(icon: Icons.view_module_rounded),
            ],
          ),
        ),
      ],
    );
  }
}

class _WebIconBtn extends StatelessWidget {
  final IconData icon;
  const _WebIconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Icon(icon, size: 18, color: cs.onSurface.withOpacity(.7)),
    );
  }
}

class _WebMostPopularLabel extends StatelessWidget {
  const _WebMostPopularLabel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        const Icon(
          Icons.local_fire_department_rounded,
          size: 16,
          color: Color(0xFFEF4444),
        ),
        const SizedBox(width: 8),
        Text(
          "Most Popular",
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface.withOpacity(.6),
          ),
        ),
      ],
    );
  }
}

class _CollageSection extends StatelessWidget {
  final bool isWeb;
  const _CollageSection({required this.isWeb});

  @override
  Widget build(BuildContext context) {
    if (!isWeb) return const _MobileCollageRow();
    return const _WebCollageRow();
  }
}

class _MobileCollageRow extends StatelessWidget {
  const _MobileCollageRow();

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

class _WebCollageRow extends StatelessWidget {
  const _WebCollageRow();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _WebCollageCard(
            borderColor: cs.outlineVariant,
            imageUrl:
                "https://images.pexels.com/photos/373912/pexels-photo-373912.jpeg?auto=compress&cs=tinysrgb&w=1200",
            title: "Vehicles",
            subtitle: "Cars • Trucks • Bikes",
            icon: Icons.directions_car_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: _WebCollageCard(
            borderColor: cs.outlineVariant,
            imageUrl:
                "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=1200",
            title: "Real Estate",
            subtitle: "Rent • Buy • Sell",
            icon: Icons.home_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: _WebCollageCard(
            borderColor: cs.outlineVariant,
            imageUrl:
                "https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=1200",
            title: "Jobs",
            subtitle: "Full-time • Part-time",
            icon: Icons.work_rounded,
          ),
        ),
      ],
    );
  }
}

class _WebCollageCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color borderColor;

  const _WebCollageCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: theme.colorScheme.surface),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.15),
                  Colors.black.withOpacity(.55),
                ],
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            right: 12,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.92),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.category_rounded,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(.85),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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

class _StatsRow extends StatelessWidget {
  final bool isWeb;
  const _StatsRow({required this.isWeb});

  @override
  Widget build(BuildContext context) {
    const mobileColor = Color(0xFFDC2626);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: "55,000+",
            label: "Active Listings",
            valueColor: isWeb ? const Color(0xFF16A34A) : mobileColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: "1,100+",
            label: "New Daily",
            valueColor: isWeb ? const Color(0xFFDC2626) : mobileColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: "10K+",
            label: "Happy Users",
            valueColor: isWeb ? const Color(0xFFD97706) : mobileColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: "12",
            label: "Categories",
            valueColor: isWeb ? const Color(0xFF1F2937) : mobileColor,
          ),
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
        color: theme.colorScheme.surface,
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

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final double height;

  const _SearchField({
    required this.hint,
    required this.onChanged,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      height: height,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant),
          filled: true,
          fillColor: theme.cardColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: cs.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: cs.primary, width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _ListHeaderRow extends StatelessWidget {
  final AllCategoryController controller;
  const _ListHeaderRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final count = controller.filtered.length;
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
    });
  }
}

class _CategoryListMobile extends StatelessWidget {
  final AllCategoryController controller;
  const _CategoryListMobile({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final list = controller.filtered;

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: cs.surface),
        child: Column(
          children: List.generate(list.length, (i) {
            final item = list[i];
            final expanded = controller.isExpanded(item.id);

            return Padding(
              padding: EdgeInsets.only(bottom: i == list.length - 1 ? 0 : 10),
              child: _CategoryTile(
                item: item,
                expanded: expanded,
                onChevronTap: () => controller.toggleExpanded(item.id),
                onTap: () =>
                    Get.to(() => CategoryListingsScreen(category: item)),
              ),
            );
          }),
        ),
      );
    });
  }
}

class _WebCategoriesContainer extends StatelessWidget {
  final AllCategoryController controller;
  const _WebCategoriesContainer({required this.controller});

  int _columnsForWidth(double w) {
    if (w >= 1200) return 3;
    if (w >= 900) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const spacing = 16.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ListHeaderRow(controller: controller),
          const SizedBox(height: 14),
          Obx(() {
            final list = controller.filtered;

            return LayoutBuilder(
              builder: (context, constraints) {
                final cols = _columnsForWidth(constraints.maxWidth);
                final totalSpacing = spacing * (cols - 1);
                final itemW = (constraints.maxWidth - totalSpacing) / cols;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: List.generate(list.length, (i) {
                    final item = list[i];
                    return SizedBox(
                      width: itemW,
                      height: 172,
                      child: _WebCategoryCard(
                        item: item,
                        onTap: () => Get.to(
                          () => CategoryListingsScreen(category: item),
                        ),
                      ),
                    );
                  }),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _WebCategoryCard extends StatelessWidget {
  final BrowseCategoryVM item;
  final VoidCallback onTap;
  const _WebCategoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final chips = <String>[
      "Cars for Sale",
      "Trucks & Vans",
      "Motorcycles",
      "Spare Parts",
      "Car Rentals",
      "Boats & Marine",
    ];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: item.tint ?? cs.surfaceContainerHighest,
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
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
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(.55),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: cs.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: cs.onSurface.withOpacity(.45),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chips.take(6).map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Text(
                    t,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(.7),
                      fontWeight: FontWeight.w600,
                      fontSize: 10.5,
                      height: 1.1,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
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
            color: theme.cardColor,
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
                        color: item.tint ?? cs.surfaceContainerHighest,
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

class _NeedHelpCta extends StatelessWidget {
  const _NeedHelpCta();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Can't find what you need?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Post a free ad and reach buyers fast.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onPrimary.withOpacity(.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.cardColor,
              foregroundColor: cs.onSurface,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text("Post Free Ad"),
          ),
        ],
      ),
    );
  }
}
