import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/browse_controller.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/screens/listing_detail_screen.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrowseController(), permanent: true);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _isWebDesktop(context)
          ? theme.colorScheme.surface
          : theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebLayout(controller: controller)
            : _MobileLayout(controller: controller),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final BrowseController controller;

  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.only(bottom: 18),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MobileHeader(),
              const SizedBox(height: 12),
              _BrowseSearchSection(controller: controller, web: false),
              const SizedBox(height: 14),
              _BrowseFilterSection(controller: controller, web: false),
              const SizedBox(height: 14),
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(color: cs.surface),
          width: double.infinity,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: BrowseResults(controller: controller),
          ),
        ),
      ],
    );
  }
}

class _WebLayout extends StatelessWidget {
  final BrowseController controller;

  const _WebLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 10),
                child: _BrowseSearchSection(controller: controller, web: true),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            color: cs.surfaceContainerLowest,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withOpacity(.04),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BrowseFilterSection(controller: controller, web: true),
                        const SizedBox(height: 16),
                        BrowseResults(controller: controller),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: controller.defaultSearchHint(web),
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
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
              onPressed: () {},
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

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEmptyState
                ? '0 results for "$query"'
                : '${controller.filtered.length} results for "$query"',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: web ? 13 : 14,
            ),
          ),
          if (!isEmptyState) ...[
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: web
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(controller.chips.length, (
                              i,
                            ) {
                              final active = controller.activeChip.value == i;
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: i == controller.chips.length - 1
                                      ? 0
                                      : 8,
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune_rounded, size: 16, color: cs.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
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
          color: active ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? cs.primary : cs.outlineVariant),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: active ? cs.onPrimary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class BrowseResults extends StatelessWidget {
  final BrowseController controller;

  const BrowseResults({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final q = controller.searchText.value.trim();

      if (controller.showEmptyState) {
        return Container(
          width: double.infinity,
          color: cs.surface,
          child: _EmptySearchState(
            query: q,
            onTryDifferent: controller.clearSearch,
            onBrowseAll: controller.clearSearch,
          ),
        );
      }

      return Container(
        width: double.infinity,
        color: cs.surface,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: controller.isGrid.value
              ? LayoutBuilder(
                  key: const ValueKey('grid_view'),
                  builder: (context, constraints) {
                    final isWeb =
                        kIsWeb && MediaQuery.of(context).size.width >= 1000;
                    final crossAxisCount = isWeb ? 4 : 2;
                    final spacing = 14.0;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filtered.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        mainAxisExtent: isWeb ? 300 : 240,
                      ),
                      itemBuilder: (_, i) {
                        final item = controller.filtered[i];
                        return _BrowseListingCardWrapper(item: item);
                      },
                    );
                  },
                )
              : ListView.separated(
                  key: const ValueKey('list_view'),
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
        ),
      );
    });
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
        Get.to(() => ListingDetailScreen(), arguments: item);
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
          color: cs.background,
          borderRadius: BorderRadius.circular(18),

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
        color: cs.background,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(item.imageUrl, fit: BoxFit.cover),
                ),
              ),
              if (item.featured)
                const Positioned(left: 8, top: 8, child: _FeaturedBadge()),
              Positioned(
                right: 8,
                top: 8,
                child: Material(
                  color: cs.surface.withOpacity(.92),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 18,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.category,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11,
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.price,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
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
                  fontSize: 11,
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
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
          constraints: BoxConstraints(maxWidth: isWeb ? 760 : double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: cs.background),
                child: Column(
                  children: [
                    _EmptyStateIcon(web: isWeb),
                    SizedBox(height: isWeb ? 18 : 18),
                    _EmptyTitle(web: isWeb, query: displayQuery),
                    const SizedBox(height: 10),
                    Text(
                      isWeb
                          ? 'We could not find any listings matching your search. Try different\nkeywords or browse our categories.'
                          : 'We couldn\'t find any listings matching your\nsearch. Try adjusting your keywords or\nbrowse our categories.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.55,
                        fontSize: isWeb ? 12 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: isWeb ? 18 : 20),
                    if (isWeb)
                      Column(
                        children: [
                          SizedBox(
                            width: 138,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: onTryDifferent,
                              icon: const Icon(Icons.search_rounded, size: 15),
                              label: Center(
                                child: const Text('Try a New Search'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: onBrowseAll,
                            style: TextButton.styleFrom(
                              foregroundColor: cs.onSurfaceVariant,
                            ),
                            child: const Text(
                              'Browse All Categories',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: ElevatedButton(
                                onPressed: onTryDifferent,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cs.primary,
                                  foregroundColor: cs.onPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                child: const Text('Try a Different Search'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: TextButton(
                                onPressed: onBrowseAll,
                                style: TextButton.styleFrom(
                                  foregroundColor: cs.onSurface,
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: const Text('Browse All'),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: isWeb ? 28 : 5),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: cs.background),
                child: Column(
                  children: [
                    SizedBox(height: isWeb ? 24 : 5),
                    Text(
                      'Search Tips',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: isWeb ? 12.5 : 15,
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(height: isWeb ? 14 : 14),
                    if (isWeb)
                      Row(
                        children: const [
                          Expanded(
                            child: _EmptyTipCard(
                              icon: Icons.search_rounded,
                              iconColor: Color(0xFF22C55E),
                              iconBg: Color(0xFFEAFBF0),
                              text:
                                  'Try broader terms like "car"\ninstead of specific model\nnumbers',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _EmptyTipCard(
                              icon: Icons.sell_outlined,
                              iconColor: Color(0xFFEF4444),
                              iconBg: Color(0xFFFDECEC),
                              text:
                                  'Check your spelling or try\nalternate keywords',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _EmptyTipCard(
                              icon: Icons.grid_view_rounded,
                              iconColor: Color(0xFFEAB308),
                              iconBg: Color(0xFFFFF7D6),
                              text:
                                  'Browse categories directly\nto discover listings',
                            ),
                          ),
                        ],
                      )
                    else
                      const Column(
                        children: [
                          _EmptyTipTile(
                            icon: Icons.spellcheck_rounded,
                            title: 'Check Your Spelling',
                            subtitle:
                                'Make sure all words are spelled correctly\nand try again.',
                          ),
                          SizedBox(height: 12),
                          _EmptyTipTile(
                            icon: Icons.layers_rounded,
                            title: 'Use Fewer Keywords',
                            subtitle:
                                'Try simplifying your search with broader or\nfewer terms.',
                          ),
                          SizedBox(height: 12),
                          _EmptyTipTile(
                            icon: Icons.autorenew_rounded,
                            title: 'Try Different Words',
                            subtitle:
                                'Use synonyms or alternative phrases for\nbetter results.',
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: isWeb ? 28 : 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                decoration: BoxDecoration(color: cs.background),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Searches',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.popularSearches.map((item) {
                        return _PopularSearchChip(label: item, web: false);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
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
            fontSize: 18,
            color: cs.onSurface,
          ),
          children: [
            const TextSpan(text: 'No results for "'),
            TextSpan(text: query),
            const TextSpan(text: '"'),
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
      width: web ? 44 : 56,
      height: web ? 44 : 56,
      decoration: BoxDecoration(
        color: web ? const Color(0xFFFDECEC) : const Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        web ? Icons.search_off_rounded : Icons.search_rounded,
        size: web ? 18 : 26,
        color: web ? const Color(0xFFF87171) : const Color(0xFFD1D5DB),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
      ),
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 13, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10.5,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTipTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyTipTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: cs.background,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.45,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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

class _PopularSearchChip extends StatelessWidget {
  final String label;
  final bool web;

  const _PopularSearchChip({required this.label, required this.web});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up_rounded,
            size: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
