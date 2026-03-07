import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/browse_controller.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/screens/listing_detail_screen.dart';
import 'package:guyana_center_frontend/widgets/mobile_top_bar.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrowseController(), permanent: true);
    final theme = Theme.of(context);

    return Obx(() {
      final isEmpty = controller.showEmptyState;
      final isWeb = _isWebDesktop(context);

      return Scaffold(
        backgroundColor: isWeb
            ? (isEmpty
                  ? (theme.brightness == Brightness.dark
                        ? theme.colorScheme.surface
                        : Colors.white)
                  : theme.colorScheme.surface)
            : theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: isWeb
              ? _WebLayout(controller: controller)
              : _MobileLayout(controller: controller),
        ),
      );
    });
  }
}

class _MobileLayout extends StatelessWidget {
  final BrowseController controller;

  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        children: [
          const MobileTopBar(),
          const SizedBox(height: 12),
          _BrowseSearchSection(controller: controller, web: false),
          const SizedBox(height: 14),
          _BrowseFilterSection(controller: controller, web: false),
          const SizedBox(height: 14),
          BrowseResults(controller: controller),
        ],
      ),
    );
  }
}

class _WebLayout extends StatelessWidget {
  final BrowseController controller;

  const _WebLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF161616)
                : Colors.white,
            width: double.infinity,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 22,
                  ),
                  child: _BrowseSearchSection(
                    controller: controller,
                    web: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Obx(() {
            final isEmpty = controller.showEmptyState;
            return Container(
              width: double.infinity,
              color: isEmpty
                  ? (Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.surface
                        : Colors.white)
                  : (Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).scaffoldBackgroundColor
                        : const Color(0xFFFAFAFA)),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: isEmpty
                        ? EdgeInsets.zero
                        : const EdgeInsets.fromLTRB(24, 28, 24, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BrowseFilterSection(controller: controller, web: true),
                        if (!isEmpty) const SizedBox(height: 24),
                        BrowseResults(controller: controller, isWeb: true),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SliverToBoxAdapter(child: WebFooter()),
      ],
    );
  }
}

class _BrowseSearchSection extends StatelessWidget {
  final BrowseController controller;
  final bool web;

  const _BrowseSearchSection({required this.controller, required this.web});

  @override
  Widget build(BuildContext context) {
    return _BrowseSearchBar(controller: controller, web: web);
  }
}

class _BrowseSearchBar extends StatelessWidget {
  final BrowseController controller;
  final bool web;

  const _BrowseSearchBar({required this.controller, required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final hasText = controller.searchText.value.isNotEmpty;

      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: web ? 48 : 46,
              child: TextFormField(
                initialValue: controller.searchText.value,
                onChanged: controller.setSearch,
                decoration: InputDecoration(
                  hintText: controller.defaultSearchHint(web),
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: cs.surface,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: cs.onSurfaceVariant,
                    size: 20,
                  ),
                  suffixIcon: hasText
                      ? IconButton(
                          onPressed: controller.clearSearch,
                          icon: Icon(
                            Icons.close_rounded,
                            color: cs.onSurfaceVariant,
                            size: 18,
                          ),
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.primary),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: web ? 48 : 46,
            width: web ? 96 : 50,
            child: ElevatedButton(
              onPressed: () {
                controller.forceEmptyState.value = true;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: web
                  ? const Text(
                      'Search',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    )
                  : const Icon(Icons.search_rounded, size: 20),
            ),
          ),
        ],
      );
    });
  }
}

class _BrowseFilterSection extends StatelessWidget {
  final BrowseController controller;
  final bool web;

  const _BrowseFilterSection({required this.controller, required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final isEmptyState = controller.showEmptyState;
      final query = controller.displayQuery(web);

      if (isEmptyState) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${controller.filtered.length} results for "$query"',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: web ? 13 : 14,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: web
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(controller.chips.length, (i) {
                            final active = controller.activeChip.value == i;
                            return Padding(
                              padding: EdgeInsets.only(
                                right: i == controller.chips.length - 1 ? 0 : 8,
                              ),
                              child: _FilterChip(
                                label: controller.chips[i],
                                active: active,
                                onTap: () => controller.setChip(i),
                              ),
                            );
                          }),
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(controller.chips.length, (i) {
                          final active = controller.activeChip.value == i;
                          return _FilterChip(
                            label: controller.chips[i],
                            active: active,
                            onTap: () => controller.setChip(i),
                          );
                        }),
                      ),
              ),
              const SizedBox(width: 12),
              if (web) ...[
                _SortButton(label: 'Most Relevant', onTap: () {}),
                const SizedBox(width: 8),
              ] else ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 17,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Sort',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
              _ViewTypeButton(
                icon: Icons.grid_view_rounded,
                active: controller.isGrid.value,
                onTap: controller.setGridView,
              ),
              const SizedBox(width: 6),
              _ViewTypeButton(
                icon: Icons.view_list_rounded,
                active: !controller.isGrid.value,
                onTap: controller.setListView,
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? cs.primary : cs.outlineVariant),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? cs.onPrimary : cs.onSurface,
          ),
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SortButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_vert_rounded, size: 16, color: cs.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewTypeButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ViewTypeButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: active ? cs.surfaceContainerHighest : cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Icon(icon, size: 18, color: cs.onSurface),
      ),
    );
  }
}

class BrowseResults extends StatelessWidget {
  final BrowseController controller;
  final bool isWeb;

  const BrowseResults({
    super.key,
    required this.controller,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Obx(() {
        final q = controller.searchText.value.trim();

        if (controller.showEmptyState) {
          return _EmptySearchState(
            query: q,
            onTryDifferent: controller.clearSearch,
            onBrowseAll: controller.clearSearch,
          );
        }

        return controller.isGrid.value
            ? LayoutBuilder(
                builder: (context, constraints) {
                  final cols = isWeb
                      ? (constraints.maxWidth >= 980
                            ? 4
                            : constraints.maxWidth >= 760
                            ? 3
                            : constraints.maxWidth >= 520
                            ? 2
                            : 1)
                      : 2;
                  double extent = isWeb
                      ? (cols >= 4
                            ? 305
                            : cols == 3
                            ? 330
                            : cols == 2
                            ? 350
                            : 370)
                      : 260;

                  return GridView.builder(
                    itemCount: controller.filtered.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      mainAxisExtent: extent,
                    ),
                    itemBuilder: (_, i) {
                      final item = controller.filtered[i];
                      return _BrowseListingCardWrapper(item: item);
                    },
                  );
                },
              )
            : Container(
                width: double.infinity,
                color: Colors.transparent,
                child: ListView.separated(
                  itemCount: controller.filtered.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final item = controller.filtered[i];
                    return _BrowseListingCardWrapper(
                      item: item,
                      listView: true,
                    );
                  },
                ),
              );
      }),
    );
  }
}

class _BrowseListingCardWrapper extends StatelessWidget {
  final BrowseListingVM item;
  final bool listView;

  const _BrowseListingCardWrapper({required this.item, this.listView = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(ListingDetailScreen(), arguments: item);
      },
      borderRadius: BorderRadius.circular(18),
      child: _ListingCard(item: item, listView: listView),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final BrowseListingVM item;
  final bool listView;

  const _ListingCard({required this.item, this.listView = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (listView) {
      return Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 140,
              height: 130,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(item.imageUrl, fit: BoxFit.cover),
                    if (item.featured)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: _FeaturedBadge(web: true),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: _ListingContent(item: item),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 10.5,
                  child: Image.network(item.imageUrl, fit: BoxFit.cover),
                ),
              ),
              if (item.featured)
                Positioned(left: 12, top: 12, child: _FeaturedBadge(web: true)),
              Positioned(
                right: 12,
                top: 12,
                child: Row(
                  children: [
                    if (item.gallery.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${item.gallery.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 16,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: _ListingContent(item: item, compact: true),
          ),
        ],
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  final bool web;

  const _FeaturedBadge({this.web = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: web ? const Color(0xFFF59E0B) : cs.primary,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        'Featured',
        style: TextStyle(
          color: web ? Colors.white : cs.onPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ListingContent extends StatelessWidget {
  final BrowseListingVM item;
  final bool compact;

  const _ListingContent({required this.item, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final content = <Widget>[
      Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.category,
              style: const TextStyle(
                color: Color(0xFF16A34A),
                fontWeight: FontWeight.w800,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.condition,
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        item.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: cs.onSurface,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        item.price,
        style: TextStyle(
          color: const Color(0xFF16A34A),
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 14,
            color: cs.onSurfaceVariant.withOpacity(0.6),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              item.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: cs.onSurfaceVariant.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.access_time_rounded,
            size: 14,
            color: cs.onSurfaceVariant.withOpacity(0.6),
          ),
          const SizedBox(width: 4),
          Text(
            "2 hours ago",
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: cs.onSurfaceVariant.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ];

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: content,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...content.take(3), const Spacer(), ...content.skip(3)],
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final String query;
  final VoidCallback onTryDifferent;
  final VoidCallback onBrowseAll;

  const _EmptySearchState({
    required this.query,
    required this.onTryDifferent,
    required this.onBrowseAll,
  });

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final isWeb = _isWebDesktop(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final controller = Get.find<BrowseController>();
    final displayQuery = controller.emptyStateTitleQuery;

    return Container(
      width: double.infinity,
      color: cs.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 1100 : double.infinity),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isWeb ? 24 : 8,
              isWeb ? 34 : 24,
              isWeb ? 24 : 8,
              isWeb ? 36 : 18,
            ),
            child: Column(
              children: [
                const SizedBox(height: 38),
                _EmptyStateIcon(web: isWeb),
                const SizedBox(height: 36),
                _EmptyTitle(web: isWeb, query: displayQuery),
                const SizedBox(height: 16),
                Text(
                  'We could not find any listings matching your search. Try different\nkeywords or browse our categories.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withOpacity(0.6),
                    height: 1.6,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onTryDifferent,
                    icon: const Icon(Icons.search_rounded, size: 20),
                    label: const Text('Try a New Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: onBrowseAll,
                  style: TextButton.styleFrom(
                    foregroundColor: cs.onSurface.withOpacity(0.6),
                  ),
                  child: const Text(
                    'Browse All Categories',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 64),
                Text(
                  'Search Tips',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _EmptyTipCard(
                      icon: Icons.search_rounded,
                      iconColor: const Color(0xFF22C55E),
                      iconBg: const Color(0xFFF0FDF4),
                      text:
                          'Try broader terms like "car"\ninstead of specific model\nnumbers',
                    ),
                    _EmptyTipCard(
                      icon: Icons.sell_outlined,
                      iconColor: const Color(0xFFEF4444),
                      iconBg: const Color(0xFFFEF2F2),
                      text: 'Check your spelling or try\nalternate keywords',
                    ),
                    _EmptyTipCard(
                      icon: Icons.grid_view_rounded,
                      iconColor: const Color(0xFFEAB308),
                      iconBg: const Color(0xFFFFFBEB),
                      text: 'Browse categories directly\nto discover listings',
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                Text(
                  'Popular Right Now',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.popularSearches.map((item) {
                    return _PopularSearchChip(label: item, web: isWeb);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyTitle extends StatelessWidget {
  final bool web;
  final String query;

  const _EmptyTitle({required this.web, required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (web) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 32,
            color: cs.onSurface,
            letterSpacing: -0.5,
          ),
          children: [
            const TextSpan(text: 'No results for "  '),
            TextSpan(
              text: query,
              style: TextStyle(color: cs.onSurface),
            ),
            const TextSpan(text: '  "'),
          ],
        ),
      );
    }

    return Text(
      'No results for “$query”',
      textAlign: TextAlign.center,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w900,
        fontSize: 17,
        color: cs.onSurface,
      ),
    );
  }
}

class _EmptyStateIcon extends StatelessWidget {
  final bool web;

  const _EmptyStateIcon({required this.web});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: web ? 90 : 56,
      height: web ? 90 : 56,
      decoration: BoxDecoration(
        color: web ? const Color(0xFFFFF1F2) : const Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: web ? 48 : 26,
        height: web ? 48 : 26,
        decoration: web
            ? BoxDecoration(
                border: Border.all(color: const Color(0xFFFDA4AF), width: 1.5),
                shape: BoxShape.circle,
              )
            : null,
        alignment: Alignment.center,
        child: Icon(
          web ? Icons.close_rounded : Icons.search_rounded,
          size: web ? 22 : 26,
          color: web ? const Color(0xFFF43F5E) : const Color(0xFFD1D5DB),
        ),
      ),
    );
  }
}

class _EmptyTipCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String text;

  const _EmptyTipCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 260,
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              cs.brightness == Brightness.dark ? 0.3 : 0.02,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: 20),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularSearchChip extends StatelessWidget {
  final String label;
  final bool web;

  const _PopularSearchChip({required this.label, required this.web});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.8)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: cs.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }
}
