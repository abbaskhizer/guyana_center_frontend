import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/favorites_controller.dart';

import 'package:guyana_center_frontend/modal/favItem.dart';
import 'package:guyana_center_frontend/widgets/app_drawar.dart';
import 'package:guyana_center_frontend/widgets/guyana_central_logo.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(FavoritesController());
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // ===== Top bar (same style as others) - hidden on web =====
            if (!kIsWeb)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Row(
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
                      icon: Icon(
                        Icons.notifications_none_rounded,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    ProfileDot(onTap: () {}),
                  ],
                ),
              ),

            // ===== Tabs =====
            _FavTabs(c: c),

            // ===== Body =====
            Expanded(
              child: Obx(() {
                final t = c.tab.value;
                return IndexedStack(
                  index: t == FavTab.ads ? 0 : 1,
                  children: const [_FavAdsTab(), _FavSearchesTab()],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavTabs extends StatelessWidget {
  final FavoritesController c;
  const _FavTabs({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget tab(String text, FavTab t) {
      return Expanded(
        child: InkWell(
          onTap: () => c.setTab(t),
          child: Obx(() {
            final active = c.tab.value == t;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? cs.primary : cs.outlineVariant,
                    width: active ? 2 : 1,
                  ),
                ),
              ),
              child: Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: active ? cs.primary : cs.onSurface.withOpacity(.45),
                ),
              ),
            );
          }),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          tab("Favorite ads", FavTab.ads),
          tab("Favorite searches", FavTab.searches),
        ],
      ),
    );
  }
}

/// ===============================
/// TAB 1: Favorite ads
/// ===============================
class _FavAdsTab extends GetView<FavoritesController> {
  const _FavAdsTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final hasAny = controller.favoriteAds.isNotEmpty;

      if (!hasAny) {
        return const _EmptyFavoriteAds();
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        children: [
          Text(
            "Search Saved Items",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 10),

          // Search bar + filters (like figma)
          _SearchAndFilters(),

          const SizedBox(height: 14),

          // Cards
          Obx(() {
            final list = controller.visibleAds;
            return Column(
              children: List.generate(list.length, (i) {
                final item = list[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _FavAdCard(
                    item: item,
                    onHeartTap: () => controller.toggleFav(i),
                  ),
                );
              }),
            );
          }),

          const SizedBox(height: 8),

          Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: cs.outlineVariant),
                shape: const StadiumBorder(),
              ),
              child: Text(
                "Load more saved items",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _SearchAndFilters extends GetView<FavoritesController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        TextField(
          controller: controller.searchCtrl,
          decoration: InputDecoration(
            hintText: "Search saved items...",
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: Obx(() {
              final show = controller.query.value.isNotEmpty;
              if (!show) return const SizedBox.shrink();
              return IconButton(
                onPressed: controller.clearSearch,
                icon: const Icon(Icons.close_rounded),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: Obx(() {
            final selected = controller.selectedFilter.value;

            Widget chip(String text) {
              final active = selected == text;
              return InkWell(
                onTap: () => controller.setFilter(text),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: active ? cs.primary.withOpacity(.10) : cs.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: active ? cs.primary : cs.outlineVariant,
                    ),
                  ),
                  child: Text(
                    text,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: active
                          ? cs.primary
                          : cs.onSurface.withOpacity(.65),
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.adFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => chip(controller.adFilters[i]),
            );
          }),
        ),
      ],
    );
  }
}

class _FavAdCard extends StatelessWidget {
  final FavItemVM item;
  final VoidCallback onHeartTap;
  const _FavAdCard({required this.item, required this.onHeartTap});

  Color _badgeColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final b = item.badge.toLowerCase();
    if (b == "urgent") return const Color(0xFFFF5A5A);
    if (b == "featured") return cs.primary;
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
                  aspectRatio: 16 / 10,
                  child: Image.network(item.imageUrl, fit: BoxFit.cover),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _badgeColor(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.badge,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Material(
                    color: cs.surface.withOpacity(0.92),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onHeartTap,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite_rounded,
                          size: 18,
                          color: const Color(0xFFFF5A5A),
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
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: cs.onSurface.withOpacity(.45),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface.withOpacity(.55),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.price,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
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

class _EmptyFavoriteAds extends StatelessWidget {
  const _EmptyFavoriteAds();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.08),
                shape: BoxShape.circle,
                border: Border.all(color: cs.primary.withOpacity(.15)),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.favorite_border_rounded,
                color: cs.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No Favorite ads yet",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "See your favorite ads here! Click on the star\nnext to each ad to save it for later.",
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withOpacity(.45),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Browse Listing",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: cs.onPrimary,
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

/// ===============================
/// TAB 2: Favorite searches
/// ===============================
class _FavSearchesTab extends GetView<FavoritesController> {
  const _FavSearchesTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final hasAny = controller.savedSearches.isNotEmpty;
      if (!hasAny) return const _EmptyFavoriteSearches();

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        children: [
          Text(
            "Favorite Searches",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 10),

          // small chips row like figma top
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _MiniChip(text: "All"),
              _MiniChip(text: "Vehicles"),
              _MiniChip(text: "Real estate"),
              _MiniChip(text: "Jobs"),
            ],
          ),
          const SizedBox(height: 14),

          // list
          Obx(() {
            return Column(
              children: List.generate(controller.savedSearches.length, (i) {
                final s = controller.savedSearches[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SavedSearchTile(
                    item: s,
                    onSearch: () => controller.runSavedSearch(s),
                    onRemove: () => controller.removeSavedSearch(i),
                  ),
                );
              }),
            );
          }),
        ],
      );
    });
  }
}

class _MiniChip extends StatelessWidget {
  final String text;
  const _MiniChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: cs.onSurface.withOpacity(.65),
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SavedSearchTile extends StatelessWidget {
  final SavedSearchVM item;
  final VoidCallback onSearch;
  final VoidCallback onRemove;

  const _SavedSearchTile({
    required this.item,
    required this.onSearch,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.bookmark_border_rounded,
              color: cs.primary,
              size: 18,
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
                  ),
                ),
                const SizedBox(height: 6),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Pill(text: item.subtitle),
                    _Pill(text: item.query),
                    _Pill(text: item.location),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: onSearch,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        child: Text(
                          "Search",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 34,
                      child: OutlinedButton(
                        onPressed: onRemove,
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          side: BorderSide(color: cs.outlineVariant),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        child: Text(
                          "Remove",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface.withOpacity(.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Icon(Icons.chevron_right_rounded, color: cs.outlineVariant),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withOpacity(.18)),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 11.5,
          color: cs.primary,
        ),
      ),
    );
  }
}

class _EmptyFavoriteSearches extends StatelessWidget {
  const _EmptyFavoriteSearches();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded, color: cs.primary, size: 54),
            const SizedBox(height: 16),
            Text(
              "Be the first to see the new ads!",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "On the search results page, click the star\nicon next to the result count.\nSubscribe to category updates",
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withOpacity(.45),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  elevation: 0,
                ),
                icon: Icon(Icons.search_rounded, size: 18, color: cs.onPrimary),
                label: Text(
                  "Browse Listing",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
