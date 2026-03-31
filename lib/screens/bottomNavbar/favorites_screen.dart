import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/favorites_controller.dart';
import 'package:guyana_center_frontend/modal/favItem.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';
import 'package:guyana_center_frontend/screens/listing_detail_screen.dart';
import 'package:guyana_center_frontend/widgets/featured_item_card.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(FavoritesController(), permanent: true);
    final theme = Theme.of(context);

    if (_isWebDesktop(context)) {
      return _WebFavoritesLayout(controller: c);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!kIsWeb)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: MobileHeader(),
              ),
            _FavTabs(c: c),
            Expanded(
              child: PageView(
                controller: c.pageController,
                onPageChanged: c.onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: [
                  _FavoriteAdsTab(c: c),
                  _SavedSearchesTab(c: c),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteAdsTab extends StatelessWidget {
  final FavoritesController c;
  const _FavoriteAdsTab({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      if (c.isLoadingAds.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final filtered = c.filteredAds;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "My Favorites",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Search Saved Items",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: TextField(
                onChanged: c.setSearch,
                decoration: InputDecoration(
                  hintText: "Search by name or keyword...",
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _CategoryChip(label: "All", controller: c),
                _CategoryChip(label: "Real Estate", controller: c),
                _CategoryChip(label: "Electronics", controller: c),
                _CategoryChip(label: "Vehicles", controller: c),
                _CategoryChip(label: "Jobs", controller: c),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyFavoriteAds(c: c)
                : RefreshIndicator(
                    onRefresh: () async => c.loadFavoriteAds(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return FeatureItemCardWrapper(item: item, c: c);
                      },
                    ),
                  ),
          ),
        ],
      );
    });
  }
}

class _SavedSearchesTab extends StatelessWidget {
  final FavoritesController c;
  const _SavedSearchesTab({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: Color(0xFFF5B301),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Saved Searches",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFF5B301),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "My Keywords",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                "Get notified when new ads match your search",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: TextField(
                    controller: c.searchInputController,
                    decoration: InputDecoration(
                      hintText: "Add a keyword (e.g. iPhone 15)",
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(
                          0.5,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.add_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      suffixIcon: Obx(
                        () => c.searchInputText.value.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () => c.setSearchInput(""),
                              )
                            : const SizedBox(),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (_) => c.addSearch(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: c.addSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: c.searches.isEmpty
              ? _EmptyFavoriteSearches(c: c)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: c.searches.length,
                  itemBuilder: (context, index) {
                    final item = c.searches[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SavedSearchCard(
                        title: item.title,
                        icon: item.icon,
                        alertsOn: item.alertsOn.value,
                        onToggleAlerts: () => c.toggleAlerts(index),
                        onDelete: () => c.removeSearch(index),
                        onView: () => c.viewSearch(item),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _WebFavoritesLayout extends StatelessWidget {
  final FavoritesController controller;
  const _WebFavoritesLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: WebHeader()),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _FavTabs(c: controller),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: PageView(
                          controller: controller.pageController,
                          onPageChanged: controller.onPageChanged,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _WebFavoriteAdsTab(c: controller),
                            _WebSavedSearchesTab(c: controller),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(color: cs.surface, child: const WebFooter()),
          ),
        ],
      ),
    );
  }
}

class _WebFavoriteAdsTab extends StatelessWidget {
  final FavoritesController c;
  const _WebFavoriteAdsTab({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      if (c.isLoadingAds.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final filtered = c.filteredAds;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_border, color: cs.primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      "My Favorites",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Search Saved Items",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: TextField(
                onChanged: c.setSearch,
                decoration: InputDecoration(
                  hintText: "Search by name or keyword...",
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: cs.onSurfaceVariant.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyFavoriteAds(c: c)
                : RefreshIndicator(
                    onRefresh: () async => c.loadFavoriteAds(),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 280,
                          ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return FeatureItemCardWrapper(item: item, c: c);
                      },
                    ),
                  ),
          ),
        ],
      );
    });
  }
}

class _WebSavedSearchesTab extends StatelessWidget {
  final FavoritesController c;
  const _WebSavedSearchesTab({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: Color(0xFFF5B301),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Saved Searches",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFF5B301),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "My Keywords",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                "Get notified when new ads match your search",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: TextField(
                    controller: c.searchInputController,
                    decoration: InputDecoration(
                      hintText: "Add a keyword (e.g. iPhone 15)",
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(
                          0.5,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.add_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      suffixIcon: Obx(
                        () => c.searchInputText.value.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () => c.setSearchInput(""),
                              )
                            : const SizedBox(),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (_) => c.addSearch(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: c.addSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: c.searches.isEmpty
              ? _EmptyFavoriteSearches(c: c)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: c.searches.length,
                  itemBuilder: (context, index) {
                    final item = c.searches[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SavedSearchCard(
                        title: item.title,
                        icon: item.icon,
                        alertsOn: item.alertsOn.value,
                        onToggleAlerts: () => c.toggleAlerts(index),
                        onDelete: () => c.removeSearch(index),
                        onView: () => c.viewSearch(item),
                      ),
                    );
                  },
                ),
        ),
      ],
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
    final dividerColor = theme.dividerTheme.color ?? cs.outlineVariant;

    Widget tab(String text, FavTab t) {
      return Expanded(
        child: InkWell(
          onTap: () => c.setTab(t),
          child: Obx(() {
            final active = c.tab.value == t;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? cs.primary : Colors.transparent,
                    width: active ? 2.5 : 0,
                  ),
                ),
              ),
              child: Text(
                text,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 14,
                  fontWeight: active ? FontWeight.bold : FontWeight.w600,
                  color: active
                      ? cs.primary
                      : cs.onSurfaceVariant.withOpacity(0.6),
                ),
              ),
            );
          }),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: dividerColor.withOpacity(0.5), width: 1),
        ),
      ),
      child: Row(
        children: [
          tab("Favorite ads", FavTab.ads),
          tab("Favorite searches", FavTab.searches),
        ],
      ),
    );
  }
}

class _EmptyFavoriteAds extends StatelessWidget {
  final FavoritesController c;
  const _EmptyFavoriteAds({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.08),
                shape: BoxShape.circle,
                border: Border.all(color: cs.primary.withOpacity(.10)),
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/favads.png', height: 30, width: 30),
            ),
            const SizedBox(height: 18),
            Text(
              "No Favorite ads yet",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "See your favorite ads here! Click on the star\nnext to each ad to save it for later.",
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.50,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: cs.onSurface.withOpacity(.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              width: 180,
              child: ElevatedButton(
                onPressed: c.openBrowseAds,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Browse Listing",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: cs.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
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

class _EmptyFavoriteSearches extends StatelessWidget {
  final FavoritesController c;
  const _EmptyFavoriteSearches({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _FavoriteSearchIcon(),
            const SizedBox(height: 18),
            Text(
              "No searches saved yet",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Save keywords using the input above to get\nnotified of new listings matching your interests.",
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.50,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: cs.onSurface.withOpacity(.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              width: 180,
              child: ElevatedButton(
                onPressed: c.openBrowseSearches,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Browse Listing",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: cs.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
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

class _FavoriteSearchIcon extends StatelessWidget {
  const _FavoriteSearchIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(92, 92),
      painter: HeartPainter(color: Theme.of(context).colorScheme.primary),
    );
  }
}

class HeartPainter extends CustomPainter {
  final Color color;

  HeartPainter({this.color = const Color(0xFF22C55E)});

  @override
  void paint(Canvas canvas, Size size) {
    final heartPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final heart = Path();
    heart.moveTo(w * 0.50, h * 0.78);
    heart.cubicTo(w * 0.18, h * 0.56, w * 0.10, h * 0.28, w * 0.28, h * 0.18);
    heart.cubicTo(w * 0.40, h * 0.11, w * 0.48, h * 0.18, w * 0.50, h * 0.28);
    heart.cubicTo(w * 0.52, h * 0.18, w * 0.60, h * 0.11, w * 0.72, h * 0.18);
    heart.cubicTo(w * 0.90, h * 0.28, w * 0.82, h * 0.56, w * 0.50, h * 0.78);

    canvas.drawPath(heart, heartPaint);

    final eyePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;

    final leftEye = Path()
      ..moveTo(w * 0.35, h * 0.43)
      ..quadraticBezierTo(w * 0.40, h * 0.39, w * 0.45, h * 0.43);

    final rightEye = Path()
      ..moveTo(w * 0.55, h * 0.43)
      ..quadraticBezierTo(w * 0.60, h * 0.39, w * 0.65, h * 0.43);

    canvas.drawPath(leftEye, eyePaint);
    canvas.drawPath(rightEye, eyePaint);
  }

  @override
  bool shouldRepaint(covariant HeartPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class FeatureItemCardWrapper extends StatelessWidget {
  final ListingVM item;
  final FavoritesController c;

  const FeatureItemCardWrapper({
    super.key,
    required this.item,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FeaturedItemCard(
        title: item.title,
        price: item.price,
        location: item.location,
        imageUrl: item.imageUrl,
        pictureCount: item.images.length,
        isFavorite: true,
        onFavoriteTap: () => c.toggleFavorite(item),
        fixedHeight: 280,
        onTap: () => Get.to(
          () => const ListingDetailScreen(),
          arguments: item,
          transition: Transition.rightToLeft,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final FavoritesController controller;

  const _CategoryChip({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final selected = controller.selectedCategory.value == label;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: InkWell(
          onTap: () => controller.setCategory(label),
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: selected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    });
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
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: onView,
              icon: const Text(
                "View",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              label: const Icon(Icons.arrow_forward_rounded, size: 14),
              style: TextButton.styleFrom(
                foregroundColor: cs.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: cs.error,
              ),
              onPressed: onDelete,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
          ],
        ),
      ),
    );
  }
}
