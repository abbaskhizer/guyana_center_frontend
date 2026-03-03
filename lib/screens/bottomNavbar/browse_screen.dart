import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/browse_controller.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/screens/store_screen.dart';
import 'package:guyana_center_frontend/widgets/guyana_central_logo.dart';

import 'package:guyana_center_frontend/screens/listing_detail_screen.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BrowseController());
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {},
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
                const SizedBox(width: 10),
                const Expanded(child: GuyanaCentralLogo()),
                IconButton(
                  onPressed: () {
                    Get.to(StoresScreen());
                  },
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

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final hasText = c.searchText.value.isNotEmpty;
                    return TextField(
                      onChanged: c.setSearch,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: cs.onSurfaceVariant,
                        ),
                        suffixIcon: hasText
                            ? IconButton(
                                onPressed: c.clearSearch,
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: cs.onSurfaceVariant,
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: cs.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.primary, width: 1.4),
                        ),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.search_rounded, color: cs.onPrimary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Obx(() {
              final q = c.searchText.value.trim();

              if (c.showEmptyState) {
                return _EmptySearchState(
                  query: q,
                  onTryDifferent: c.clearSearch,
                  onBrowseAll: () {
                    c.clearSearch();
                    c.setChip(0);
                  },
                );
              }

              final count = c.filtered.length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q.isEmpty ? '$count results' : '$count results for "$q"',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(.55),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: Obx(() {
                            final tabs = c.chips;
                            final active = c.activeChip.value;

                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: tabs.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (_, i) => _ChipPill(
                                text: tabs[i],
                                active: i == active,
                                onTap: () => c.setChip(i),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort_rounded,
                              size: 18,
                              color: cs.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              c.sortLabel.value,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(() {
                        final grid = c.isGrid.value;
                        return InkWell(
                          onTap: c.toggleView,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: cs.outlineVariant),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              grid
                                  ? Icons.grid_view_rounded
                                  : Icons.view_list_rounded,
                              size: 18,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 12),

                  GridView.builder(
                    itemCount: c.filtered.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.66,
                        ),
                    itemBuilder: (_, i) {
                      final item = c.filtered[i];

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Get.to(
                            () => const ListingDetailScreen(),
                            arguments: item,
                          );
                        },
                        child: _ListingCard(item: item),
                      );
                    },
                  ),

                  const SizedBox(height: 8),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final BrowseListingVM item;
  const _ListingCard({required this.item});

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
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: cs.surfaceVariant,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.primary,
                          ),
                        ),
                      );
                    },
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

                if (item.featured)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Featured',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  right: 10,
                  top: 10,
                  child: Material(
                    color: cs.surface.withOpacity(0.9),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () {},
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 18,
                          color: cs.onSurface,
                        ),
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
                  item.category,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(.55),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.price,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipPill extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _ChipPill({
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
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: active ? cs.primary : cs.outlineVariant),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: active ? cs.onPrimary : cs.onSurface,
          ),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.search_rounded, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Text(
            'No results for "$query"',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We couldn’t find any listings matching your search.\nTry adjusting your keywords or browse our categories.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.55),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onTryDifferent,
                  child: Text(
                    'Try a Different Search',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onBrowseAll,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Browse All',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
