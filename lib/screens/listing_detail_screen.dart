import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/listing_detail_controller.dart';
import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/widgets/mobile_top_bar.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ListingDetailController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _isWebDesktop(context)
          ? theme.colorScheme.surfaceContainerLowest
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
  final ListingDetailController controller;

  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.item;
      final idx = controller.currentImage.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 10, 6),
              child: _MobileHeader(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: _Breadcrumb(title: item.title, web: false),
            ),
            _ImageGalleryMobile(controller: controller, imageIndex: idx),
            const SizedBox(height: 10),
            _ThumbnailStrip(controller: controller, compact: false),
            const SizedBox(height: 14),
            _MobileTitleBlock(item: item),
            const SizedBox(height: 14),
            _MobilePriceBlock(item: item),
            const SizedBox(height: 14),
            _SpecsRow(item: item),
            const SizedBox(height: 14),
            _MobileActionSection(item: item),
            const SizedBox(height: 12),
            const _SellerCard(web: false),
            const SizedBox(height: 12),
            const _SafetyTipsCard(web: false),
            const SizedBox(height: 14),
            _DescriptionSection(controller: controller, web: false),
            const SizedBox(height: 14),
            _LocationSection(web: false),
            const SizedBox(height: 16),
            _SimilarAdsSection(controller: controller, web: false),
          ],
        ),
      );
    });
  }
}

class _WebLayout extends StatelessWidget {
  final ListingDetailController controller;

  const _WebLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final item = controller.item;
      final idx = controller.currentImage.value;

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Breadcrumb(title: item.title, web: true),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _ImageGalleryWeb(
                                  controller: controller,
                                  imageIndex: idx,
                                ),
                                const SizedBox(height: 10),
                                _ThumbnailStrip(
                                  controller: controller,
                                  compact: true,
                                ),
                                const SizedBox(height: 14),
                                _WebMainDetailsCard(item: item),
                                const SizedBox(height: 14),
                                _DescriptionSection(
                                  controller: controller,
                                  web: true,
                                ),
                                const SizedBox(height: 14),
                                _LocationSection(web: true),
                                const SizedBox(height: 16),
                                _SimilarAdsSection(
                                  controller: controller,
                                  web: true,
                                ),
                                const SizedBox(height: 26),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 300,
                            child: Column(
                              children: [
                                _WebSidebarCard(item: item),
                                const SizedBox(height: 12),
                                const _SellerCard(web: true),
                                const SizedBox(height: 12),
                                const _SafetyTipsCard(web: true),
                              ],
                            ),
                          ),
                        ],
                      ),
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
      );
    });
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader();

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
        ProfileDot(
          onTap: () {
            Get.to(AgentProfileScreen());
          },
        ),
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final String title;
  final bool web;

  const _Breadcrumb({required this.title, required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(web ? 0 : 0, 0, 0, web ? 0 : 0),
      child: Row(
        children: [
          Text(
            web ? 'HOME  >  CARS FOR SALE  >  ' : 'VEHICLES  >  ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.45),
              fontWeight: FontWeight.w800,
              fontSize: web ? 10.5 : 11,
            ),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w900,
                fontSize: web ? 10.5 : 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageGalleryMobile extends StatelessWidget {
  final ListingDetailController controller;
  final int imageIndex;

  const _ImageGalleryMobile({
    required this.controller,
    required this.imageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final item = controller.item;
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        SizedBox(
          height: 260,
          width: double.infinity,
          child: Image.network(
            item.gallery[imageIndex],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: cs.surfaceContainerHighest,
              alignment: Alignment.center,
              child: Icon(
                Icons.broken_image_outlined,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
        if (item.gallery.length > 1) ...[
          Positioned(
            left: 12,
            top: 106,
            child: _ArrowCircle(
              icon: Icons.chevron_left_rounded,
              onTap: controller.prev,
            ),
          ),
          Positioned(
            right: 12,
            top: 106,
            child: _ArrowCircle(
              icon: Icons.chevron_right_rounded,
              onTap: controller.next,
            ),
          ),
        ],
        Positioned(
          right: 14,
          top: 14,
          child: Obx(() {
            final fav = controller.isFav.value;
            return Material(
              color: Colors.white.withOpacity(.92),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: controller.toggleFav,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    fav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: fav ? cs.primary : Colors.black87,
                    size: 18,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ImageGalleryWeb extends StatelessWidget {
  final ListingDetailController controller;
  final int imageIndex;

  const _ImageGalleryWeb({required this.controller, required this.imageIndex});

  @override
  Widget build(BuildContext context) {
    final item = controller.item;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            SizedBox(
              height: 340,
              width: double.infinity,
              child: Image.network(
                item.gallery[imageIndex],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: cs.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            if (item.gallery.length > 1) ...[
              Positioned(
                left: 12,
                top: 145,
                child: _ArrowCircle(
                  icon: Icons.chevron_left_rounded,
                  onTap: controller.prev,
                ),
              ),
              Positioned(
                right: 12,
                top: 145,
                child: _ArrowCircle(
                  icon: Icons.chevron_right_rounded,
                  onTap: controller.next,
                ),
              ),
            ],
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.photo_library_outlined,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.gallery.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
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

class _ThumbnailStrip extends StatelessWidget {
  final ListingDetailController controller;
  final bool compact;

  const _ThumbnailStrip({required this.controller, required this.compact});

  @override
  Widget build(BuildContext context) {
    final idx = controller.currentImage.value;
    final item = controller.item;
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: compact ? 54 : 66,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 16),
        scrollDirection: Axis.horizontal,
        itemCount: item.gallery.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final active = i == idx;

          return InkWell(
            onTap: () => controller.setImage(i),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: compact ? 64 : 78,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: active ? cs.primary : cs.outlineVariant,
                  width: active ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.gallery[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: cs.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MobileTitleBlock extends StatelessWidget {
  final dynamic item;

  const _MobileTitleBlock({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Posted 2 days ago',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              const _MiniTag(text: 'ID 87'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobilePriceBlock extends StatelessWidget {
  final dynamic item;

  const _MobilePriceBlock({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.price,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.condition,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.55),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'WITH music system\n\$150,000 without music system',
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.35,
              color: cs.onSurface.withOpacity(.62),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecsRow extends StatelessWidget {
  final dynamic item;

  const _SpecsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _SpecIconTile(
              icon: Icons.directions_car_filled_outlined,
              label: item.trim,
            ),
          ),
          Expanded(
            child: _SpecIconTile(
              icon: Icons.local_gas_station_outlined,
              label: item.fuel,
            ),
          ),
          Expanded(
            child: _SpecIconTile(
              icon: Icons.settings_outlined,
              label: item.transmission,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileActionSection extends StatelessWidget {
  final dynamic item;

  const _MobileActionSection({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.price,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.condition,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.55),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                  label: const Text('Show Phone Number'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message_outlined),
                  label: const Text('Send Message'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: cs.outlineVariant),
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

class _WebMainDetailsCard extends StatelessWidget {
  final dynamic item;

  const _WebMainDetailsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final c = Get.find<ListingDetailController>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Obx(() {
                final fav = c.isFav.value;
                return InkWell(
                  onTap: c.toggleFav,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      fav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: fav ? cs.primary : cs.onSurfaceVariant,
                    ),
                  ),
                );
              }),
              const SizedBox(width: 8),
              Icon(Icons.share_outlined, size: 18, color: cs.onSurfaceVariant),
            ],
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Posted 2 days ago',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              const _MiniTag(text: 'ID 87'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.price,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.condition,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.55),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SpecIconTile(
                  icon: Icons.directions_car_filled_outlined,
                  label: item.trim,
                ),
              ),
              Expanded(
                child: _SpecIconTile(
                  icon: Icons.local_gas_station_outlined,
                  label: item.fuel,
                ),
              ),
              Expanded(
                child: _SpecIconTile(
                  icon: Icons.settings_outlined,
                  label: item.transmission,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebSidebarCard extends StatelessWidget {
  final dynamic item;

  const _WebSidebarCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.price,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call, size: 16),
              label: const Text('Show Phone Number'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.message_outlined, size: 16),
              label: const Text('Send Message'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(color: cs.primary.withOpacity(.35)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  final bool web;

  const _SellerCard({required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 18, child: Text('M')),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marissa Mahraj',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Color(0xFFFFB020),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '4.9  •  15 reviews',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(.6),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (web) ...[
                  const SizedBox(height: 10),
                  Text(
                    'View All Ads by Seller',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!web)
            Text(
              'View All Ads by Seller',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
        ],
      ),
    );
  }
}

class _SafetyTipsCard extends StatelessWidget {
  final bool web;

  const _SafetyTipsCard({required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE1A6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Safety Tips',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _bullet(theme, cs, 'Meet in a safe, public location'),
          _bullet(theme, cs, 'Inspect item before payment'),
          _bullet(theme, cs, 'Never send money in advance'),
        ],
      ),
    );
  }

  static Widget _bullet(ThemeData theme, ColorScheme cs, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface.withOpacity(.7),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withOpacity(.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final ListingDetailController controller;
  final bool web;

  const _DescriptionSection({required this.controller, required this.web});

  @override
  Widget build(BuildContext context) {
    final item = controller.item;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final highlights = controller.highlights;
    final musicSystemIncludes = controller.musicSystemIncludes;
    final batterySystem = controller.batterySystem;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Description', web: web),
        const SizedBox(height: 8),
        Text(
          item.description.isEmpty
              ? 'Toyota Hiace Super GL, Gas, Not heavy T, inspected and ready for immediate transfer.'
              : item.description,
          style: theme.textTheme.bodySmall?.copyWith(
            height: 1.55,
            color: cs.onSurface.withOpacity(.75),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Column(children: highlights.map((e) => _GreenBullet(text: e)).toList()),
        const SizedBox(height: 12),
        const _SubTitle(title: 'Music System Includes:'),
        const SizedBox(height: 8),
        Column(
          children: musicSystemIncludes
              .map((e) => _GreyBullet(text: e))
              .toList(),
        ),
        const SizedBox(height: 12),
        const _SubTitle(title: 'Battery System:'),
        const SizedBox(height: 8),
        Column(
          children: batterySystem.map((e) => _GreyBullet(text: e)).toList(),
        ),
      ],
    );

    if (!web) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: content,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: content,
    );
  }
}

class _LocationSection extends StatelessWidget {
  final bool web;

  const _LocationSection({required this.web});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final mapCard = Container(
      height: web ? 200 : 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=1200',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: cs.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.map_outlined,
                    color: cs.onSurfaceVariant,
                    size: 40,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.15),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_on_rounded,
                  color: cs.onPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Location: Cunupia', web: web),
        const SizedBox(height: 10),
        mapCard,
      ],
    );

    if (!web) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: content,
      );
    }

    return content;
  }
}

class _SimilarAdsSection extends StatelessWidget {
  final ListingDetailController controller;
  final bool web;

  const _SimilarAdsSection({required this.controller, required this.web});

  @override
  Widget build(BuildContext context) {
    final item = controller.item;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final header = Row(
      children: [
        Expanded(
          child: Text(
            'Similar Ads',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
        ),
        Text(
          'See all',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );

    final list = SizedBox(
      height: web ? 190 : 210,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _SimilarCard(
          imageUrl: item.gallery[i % item.gallery.length],
          title: web ? 'Toyota Corolla 2019' : 'Toyota Van 2016',
          price: i == 1 ? '\$165,000' : '\$210,000',
          location: i == 1 ? 'Arima' : 'Port of Spain',
          web: web,
        ),
      ),
    );

    if (!web) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(children: [header, const SizedBox(height: 10), list]),
      );
    }

    return Column(children: [header, const SizedBox(height: 10), list]);
  }
}

class _SubTitle extends StatelessWidget {
  final String title;

  const _SubTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Text(
      title,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w900,
        color: cs.onSurface,
      ),
    );
  }
}

class _GreenBullet extends StatelessWidget {
  final String text;

  const _GreenBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.12),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.check_rounded, size: 14, color: cs.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.4,
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withOpacity(.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreyBullet extends StatelessWidget {
  final String text;

  const _GreyBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: cs.onSurface.withOpacity(.45),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withOpacity(.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool web;

  const _SectionTitle({required this.title, required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: cs.onSurface,
      ),
    );
  }
}

class _SpecIconTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecIconTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        Icon(icon, size: 20, color: cs.onSurface.withOpacity(.75)),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface.withOpacity(.75),
          ),
        ),
      ],
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String text;

  const _MiniTag({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: cs.onSurface.withOpacity(.7),
        ),
      ),
    );
  }
}

class _ArrowCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 22, color: Colors.black87),
        ),
      ),
    );
  }
}

class _SimilarCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String location;
  final bool web;

  const _SimilarCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.location,
    required this.web,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: web ? 160 : 170,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: web ? 92 : 105,
              width: web ? 160 : 170,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: web ? 92 : 105,
                color: cs.surfaceContainerHighest,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
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
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface.withOpacity(.6),
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
