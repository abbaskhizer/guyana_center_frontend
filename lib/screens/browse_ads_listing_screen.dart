import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/browse_fav_ads_controller.dart';
import 'package:guyana_center_frontend/modal/fav_ads.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';

class BrowseAdsListingScreen extends StatelessWidget {
  BrowseAdsListingScreen({super.key});

  final BrowseAdsListingController controller =
      Get.isRegistered<BrowseAdsListingController>()
      ? Get.find<BrowseAdsListingController>()
      : Get.put(BrowseAdsListingController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: MobileHeader(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite_border_outlined,
                    size: 18,
                    color: cs.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "My Favorites",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Search Saved Items",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: controller.searchCtrl,
                  decoration: InputDecoration(
                    hintText: "Search by name or keyword...",
                    hintStyle: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: cs.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: cs.outlineVariant.withOpacity(.5),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: cs.outlineVariant.withOpacity(.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: cs.primary, width: 1.1),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: cs.outlineVariant),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: SizedBox(
                height: 44,
                child: Obx(() {
                  final tabs = controller.filters;
                  final active = controller.selectedFilterIndex.value;

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => _FilterChip(
                      text: tabs[i],
                      active: i == active,
                      onTap: () => controller.setFilter(i),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              color: cs.surface,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: cs.outlineVariant.withOpacity(.7),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_alt_outlined,
                                size: 16,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Filters",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: cs.outlineVariant.withOpacity(.7),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tune,
                                size: 16,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Recently Added",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: cs.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        Obx(
                          () => Text(
                            "${controller.filteredItems.length} items",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Obx(
                    () => GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.05,
                          ),
                      itemBuilder: (_, index) {
                        final item = controller.filteredItems[index];
                        return _AdCard(item: item);
                      },
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _BottomStatPill(
                            icon: Icons.favorite_border_rounded,
                            value: "8",
                            label: "Saved",
                            iconBg: Color(0xFFE8F8EF),
                            iconColor: Color(0xFF22C55E),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _BottomStatPill(
                            icon: Icons.star_outline_rounded,
                            value: "4.6",
                            label: "Avg\nRating",
                            iconBg: Color(0xFFFFF4DB),
                            iconColor: Color(0xFFF5B301),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _BottomStatPill(
                            icon: Icons.notifications_none_rounded,
                            value: "3",
                            label: "Drops",
                            iconBg: Color(0xFFFFECE7),
                            iconColor: Color(0xFFFF7A59),
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
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
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
          color: active ? cs.primary : theme.cardColor,
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

class _AdCard extends StatelessWidget {
  final BrowseAdsItem item;

  const _AdCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tags = _getTags(item);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.70,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: cs.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: cs.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 34,
                          color: cs.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 10,
                  left: 10,
                  child: Text(
                    item.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),

                const Positioned(top: 10, right: 10, child: _FavCircle()),

                if (item.rating != null)
                  Positioned(
                    left: 10,
                    bottom: 8,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Color(0xFFF5B301),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item.rating!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        if (item.featured) ...[
                          const SizedBox(width: 3),
                          Text(
                            '(8)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(.9),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.price,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF17B45C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.map((e) => _buildTag(context, e)).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        item.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      item.time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
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

  List<String> _getTags(BrowseAdsItem item) {
    switch (item.category.toLowerCase()) {
      case 'real estate':
        return ['furnished', 'downtown', 'pet friendly'];
      case 'vehicles':
        return ['automatic', 'low mileage', 'clean'];
      case 'electronics':
        return ['warranty', 'like new', 'boxed'];
      default:
        return ['popular', 'verified', 'new'];
    }
  }

  Widget _buildTag(BuildContext context, String label) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _FavCircle extends StatelessWidget {
  const _FavCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.favorite_rounded,
        size: 15,
        color: Color(0xFFFF5A6E),
      ),
    );
  }
}

class _BottomStatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconBg;
  final Color iconColor;

  const _BottomStatPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
