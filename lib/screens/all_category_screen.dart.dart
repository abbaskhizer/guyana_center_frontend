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

    if (controller.categories.isEmpty) {
      controller.setCategories(
        categories.where((e) => e.id.toLowerCase() != "all").toList(),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _isWebDesktop(context)
          ? Colors.white
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
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 15),

      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: MobileTopBar(),
        ),
        const SizedBox(height: 10),

        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: const _BreadcrumbTitleBlock(isWeb: false),
        ),
        const SizedBox(height: 14),

        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: const _CollageSection(isWeb: false),
        ),
        const SizedBox(height: 12),

        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: const _StatsRow(isWeb: false),
        ),
        const SizedBox(height: 14),

        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
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
    if (w >= 1440) return 1320;
    if (w >= 1200) return 1200;
    if (w >= 1000) return 980;
    return w - 32;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
            // ✅ Header full-width, content centered
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const WebHeader(),

                  Container(
                    width: double.infinity,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF161616)
                        : Colors.white,
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

            // ✅ Body full-width FAFAFA, content centered (HomeTab jaisa)
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
                      const SizedBox(height: 18),

                      const _WebMostPopularLabel(),
                      const SizedBox(height: 10),

                      const _CollageSection(isWeb: true),
                      const SizedBox(height: 14),

                      const _StatsRow(isWeb: true),
                      const SizedBox(height: 48),

                      _WebCategoriesContainer(controller: controller),
                      const SizedBox(height: 48),

                      const _NeedHelpCta(),
                      const SizedBox(height: 48),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

            // ✅ Footer full-width
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
        if (!isWeb) const SizedBox(height: 8),
        Row(
          children: [
            if (isWeb) ...[
              Image.asset(
                'assets/icons/app_icon.png', // Fallback for the lines or replace with specific asset if needed, or build custom lines. Let's build custom lines.
                height: 38,
                errorBuilder: (context, error, stackTrace) {
                  return Row(
                    children: [
                      Container(
                        width: 6,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD97706),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (isWeb) const SizedBox(width: 12),
            ],
            Text(
              "All Categories",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
                fontSize: isWeb ? 34 : null,
              ),
            ),
          ],
        ),
        SizedBox(height: isWeb ? 16 : 6),
        Obx(() {
          final count = c.categories.length;
          return Text(
            isWeb
                ? "Browse $count categories with over 50,000 listings across Trinidad & Tobago.\nFind exactly what you need."
                : "Browse $count categories with 55,000+ listings across\nvehicles, real estate, electronics & more.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withOpacity(.45),
              height: 1.5,
              fontSize: 15,
              fontWeight: FontWeight.w500,
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(
            "Home",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withOpacity(.45),
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.chevron_right,
              size: 16,
              color: cs.onSurface.withOpacity(.3),
            ),
          ),
          Text(
            "All Categories",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Icon(
        icon,
        size: 18,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(
                0xFF1E1E1E,
              ) // For visibility against always-white background
            : cs.onSurface.withOpacity(.7),
      ),
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
          Image.network(imageUrl, fit: BoxFit.cover),
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
                  child: Icon(icon, size: 18, color: Colors.black87),
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
    const mobileColor = Color(0xFFDC2626); // red for mobile

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: "50,000+",
            label: "Total Listings",
            valueColor: isWeb ? const Color(0xFF16A34A) : mobileColor,
            icon: Icons.sell_outlined,
            isWeb: isWeb,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            value: "1,200+",
            label: "New Today",
            valueColor: isWeb ? const Color(0xFFDC2626) : mobileColor,
            icon: Icons.flash_on_rounded,
            isWeb: isWeb,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            value: "100K+",
            label: "Active Users",
            valueColor: isWeb ? const Color(0xFFD97706) : mobileColor,
            icon: Icons.people_alt_outlined,
            isWeb: isWeb,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            value: "12",
            label: "Categories",
            valueColor: isWeb
                ? Theme.of(context).colorScheme.onSurface
                : mobileColor,
            icon: Icons.pie_chart_outline_rounded,
            isWeb: isWeb,
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
  final IconData? icon;
  final bool isWeb;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    this.icon,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (isWeb && icon != null) {
      return Container(
        height: 120, // Even taller matching Figma block completely
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1F1F1F)
              : Colors.white, // Deeper contrast in Dark Mode
          borderRadius: BorderRadius.circular(20),
          border: isDark
              ? Border.all(color: Colors.transparent)
              : Border.all(color: Colors.transparent),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark
                    ? valueColor.withOpacity(0.2)
                    : valueColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: valueColor, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      color: cs.onSurface.withOpacity(.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

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
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : cs.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black54
                : cs.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black54
                : cs.onSurfaceVariant,
          ),
          filled: true,
          fillColor: Colors.white,
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
    final cs = Theme.of(context).colorScheme;

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
    // ✅ Figma desktop layout
    if (w >= 1100) return 3;
    if (w >= 800) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const spacing = 24.0; // More spacing for Figma matching

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Figma Header Row inline
        Obx(() {
          final count = controller.filtered.length;
          return Row(
            children: [
              Icon(
                Icons.grid_view_rounded,
                size: 20,
                color: cs.onSurface.withOpacity(.6),
              ),
              const SizedBox(width: 10),
              Text(
                "All Categories",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                "$count categories",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(.45),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 20),

        // ✅ Grid
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
                    height:
                        250, // Strict exact height for Web Grid cards according to design
                    child: _WebCategoryCard(
                      item: item,
                      onTap: () =>
                          Get.to(() => CategoryListingsScreen(category: item)),
                    ),
                  );
                }),
              );
            },
          );
        }),
      ],
    );
  }
}

class _WebCategoryCard extends StatelessWidget {
  final BrowseCategoryVM item;
  final VoidCallback onTap;
  const _WebCategoryCard({required this.item, required this.onTap});

  Color _cardBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(
            0xFF1F1F1F,
          ) // Strictly mapping custom dark background instead of global surface
        : Colors.white;
  }

  Color _chipBg(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Theme.of(context).brightness == Brightness.dark
        ? cs.surfaceVariant.withOpacity(0.5)
        : const Color(0xFFFAFAFA); // Barely noticeable off-white
  }

  Color _chipBorder(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Theme.of(context).brightness == Brightness.dark
        ? cs.outlineVariant.withOpacity(0.2)
        : const Color(0xFFF3F4F6); // Very slight border color almost invisible
  }

  Color _chipText(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Theme.of(context).brightness == Brightness.dark
        ? cs.onSurface.withOpacity(.75)
        : const Color(0xFF6B7280);
  }

  Color _mutedText(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return cs.onSurface.withOpacity(.55);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // ✅ you can replace these with item.subcategories if you have them
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _cardBg(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Header Row (icon + title + arrow)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: item.tint ?? cs.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
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
                const SizedBox(width: 16),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
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
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          maxLines: 2, // ✅ figma like (wrap allowed)
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _mutedText(context),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // ✅ Right arrow (figma)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: cs.onSurface.withOpacity(.3),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ✅ Chips (wrap like figma)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: chips.take(6).map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _chipBg(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _chipBorder(context)),
                  ),
                  child: Text(
                    t,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _chipText(context),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
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
            color: cs.onSurface.withOpacity(.03),
            borderRadius: BorderRadius.circular(18),
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

class _NeedHelpCta extends StatelessWidget {
  const _NeedHelpCta();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = kIsWeb && MediaQuery.of(context).size.width >= 1000;

    return Container(
      width: double.infinity,
      height: isWeb ? 180 : null,
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 48 : 24,
        vertical: isWeb ? 32 : 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF16A34A),
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF15803D), // slightly darker green
            Color(0xFF16A34A), // brand green
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: isWeb
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Can't find what you need?",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Post a free ad and let sellers come to you. It takes less than 60 seconds.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF16A34A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Post Free Ad",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF16A34A),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Can't find what you need?",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Post a free ad and let sellers come to you. It takes less than 60 seconds.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF16A34A),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Post Free Ad",
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
