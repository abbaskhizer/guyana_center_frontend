import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/listing_detail_controller.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';
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
      bottomNavigationBar: _isWebDesktop(context) ? null : CustomBottomNavBar(),
      backgroundColor: _isWebDesktop(context)
          ? theme.scaffoldBackgroundColor
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
      final cs = Theme.of(context).colorScheme;

      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 10, 6),
              child: MobileHeader(),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: _Breadcrumb(title: item.title, web: false),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _ImageGalleryMobile(
                controller: controller,
                imageIndex: idx,
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ThumbnailStrip(controller: controller, compact: false),
                  const SizedBox(height: 12),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: _Breadcrumb2(title: 'habibi', web: false),
                  ),
                  const SizedBox(height: 12),

                  _MobileTitleBlock(item: item),
                  const SizedBox(height: 10),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: Divider(color: cs.surface),
                  ),
                  SizedBox(height: 15),
                  _MobilePriceBlock(item: item),
                  const SizedBox(height: 14),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: Divider(color: cs.surface),
                  ),
                  const SizedBox(height: 14),

                  _SpecsRow(item: item),
                  const SizedBox(height: 14),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: Divider(color: cs.surface),
                  ),
                  const SizedBox(height: 14),

                  _MobileActionSection(item: item),
                  const SizedBox(height: 12),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: const _SellerCard(web: false),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: Divider(color: cs.surface),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: const _SafetyTipsCard(web: false),
                  ),
                  const SizedBox(height: 14),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: Divider(color: cs.surface),
                  ),
                  const SizedBox(height: 8),

                  _ReportAd(),
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: Divider(color: cs.surface),
                  ),
                  const SizedBox(height: 14),

                  _DescriptionSection(controller: controller, web: false),
                  const SizedBox(height: 14),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: Divider(color: cs.surface),
                  ),
                  const SizedBox(height: 14),

                  _LocationSection(web: false),
                  const SizedBox(height: 16),

                  _SimilarAdsSection(controller: controller, web: false),
                ],
              ),
            ),
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
          const SliverToBoxAdapter(child: WebHeader()),
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

class _Breadcrumb extends StatelessWidget {
  final String title;
  final bool web;

  const _Breadcrumb({required this.title, required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Text(
          web ? 'HOME  >  CARS FOR SALE  >  ' : 'VEHICLES  >  ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withOpacity(.45),
            fontWeight: FontWeight.w800,
            fontSize: web ? 10.5 : 10.5,
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
              fontSize: web ? 10.5 : 10.5,
            ),
          ),
        ),
      ],
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

    return ClipRRect(
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
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
                left: 10,
                top: 100,
                child: _ArrowCircle(
                  icon: Icons.chevron_left_rounded,
                  onTap: controller.prev,
                ),
              ),
              Positioned(
                right: 10,
                top: 100,
                child: _ArrowCircle(
                  icon: Icons.chevron_right_rounded,
                  onTap: controller.next,
                ),
              ),
            ],
            Positioned(
              right: 10,
              top: 10,
              child: Obx(() {
                final fav = controller.isFav.value;
                return Material(
                  color: Colors.white.withOpacity(.95),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: controller.toggleFav,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        fav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: fav ? cs.primary : Colors.black87,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
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
      height: compact ? 54 : 70,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 12),
        scrollDirection: Axis.horizontal,
        itemCount: item.gallery.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = i == idx;

          return InkWell(
            onTap: () => controller.setImage(i),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: compact ? 64 : 72,
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

class _Breadcrumb2 extends StatelessWidget {
  final String title;
  final bool web;

  const _Breadcrumb2({required this.title, required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget sep() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.chevron_right_rounded,
        size: 12,
        color: const Color(0xFFB8BEC8),
      ),
    );

    final crumbStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF9AA3AF),
      height: 1,
    );

    final activeStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: cs.primary,
      height: 1,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text('Home', style: crumbStyle),
          sep(),
          Text('Vehicles', style: crumbStyle),
          sep(),
          Text('Toyota Hiace', style: activeStyle),
        ],
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

    final metaStyle = theme.textTheme.bodySmall?.copyWith(
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w600,
      fontSize: 11.5,
      height: 1,
    );

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
              fontSize: 22,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 15,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(item.location, style: metaStyle),
              const SizedBox(width: 14),
              Icon(
                Icons.access_time_rounded,
                size: 15,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text('Posted 3 days ago', style: metaStyle),
              const SizedBox(width: 14),
              Icon(
                Icons.remove_red_eye_outlined,
                size: 15,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text('467', style: metaStyle),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.price,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
              fontSize: 32,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.condition,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.55),
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'with music system',
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.35,
              color: cs.onSurface.withOpacity(.62),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '\$' + '150,000 without music system',
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.35,
              color: cs.onSurface.withOpacity(.55),
              fontWeight: FontWeight.w600,
              fontSize: 14,
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
    return Row(
      children: [
        Expanded(
          child: _SpecIconTile(
            icon: Icons.directions_car_filled_outlined,
            value: item.trim,
            label: 'Trim',
          ),
        ),
        Expanded(
          child: _SpecIconTile(
            icon: Icons.local_gas_station_outlined,
            value: item.fuel,
            label: 'Fuel',
          ),
        ),
        Expanded(
          child: _SpecIconTile(
            icon: Icons.settings_outlined,
            value: item.transmission,
            label: 'Trans',
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.price,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            item.condition,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.55),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
            child: Divider(color: cs.surface),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.call,
                      size: 16,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    label: Text(
                      'Show Phone Number',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.mail_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    label: Text(
                      'Send Message',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: cs.outlineVariant),
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

class _WebMainDetailsCard extends StatelessWidget {
  final dynamic item;

  const _WebMainDetailsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final c = Get.find<ListingDetailController>();

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2124) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.transparent
              : cs.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Obx(() {
                final fav = c.isFav.value;
                return Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cs.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  child: InkWell(
                    onTap: c.toggleFav,
                    customBorder: const CircleBorder(),
                    child: Icon(
                      fav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 20,
                      color: fav
                          ? cs.primary
                          : cs.onSurfaceVariant.withOpacity(0.8),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
                ),
                child: InkWell(
                  onTap: () {},
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: cs.onSurfaceVariant.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: cs.onSurfaceVariant.withOpacity(0.8),
              ),
              const SizedBox(width: 6),
              Text(
                item.location,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: cs.onSurfaceVariant.withOpacity(0.8),
              ),
              const SizedBox(width: 6),
              Text(
                'Posted 3 days ago',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.remove_red_eye_outlined,
                size: 16,
                color: cs.onSurfaceVariant.withOpacity(0.8),
              ),
              const SizedBox(width: 6),
              Text(
                '847 views',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.price,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF16A34A),
                  fontSize: 36,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'with music system',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '\$160,000 without music system',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: cs.outlineVariant.withOpacity(0.4)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _WebSpecCard(
                  icon: Icons.directions_car_outlined,
                  title: 'Super GL',
                  subtitle: 'Model',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _WebSpecCard(
                  icon: Icons.local_offer_outlined,
                  title: 'Gas',
                  subtitle: 'Fuel Type',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _WebSpecCard(
                  icon: Icons.shield_outlined,
                  title: 'Automatic',
                  subtitle: 'Transmission',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebSpecCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WebSpecCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHighest.withOpacity(0.3)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: cs.onSurfaceVariant.withOpacity(0.7)),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant.withOpacity(0.8),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
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

    if (web) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 10),
                  Text(
                    'View All Ads by Seller',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w900,
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
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                child: Text('M'),
                backgroundColor: cs.onSurfaceVariant.withOpacity(.6),
              ),
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
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      'Posting since Apr 2023',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface.withOpacity(.5),
                        fontSize: 13.5,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_border_rounded,
                          size: 20,
                          color: Color(0xFFFFB020),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.9  •  5 ad(s) this year',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(.6),
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'View All Ads by Seller',
            style: theme.textTheme.bodyMedium?.copyWith(
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

    if (web) {
      final isDark = theme.brightness == Brightness.dark;
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2114) : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF452B10)
                    : const Color(0xFFFDE68A),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Tips',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFB45309), // Darker orange-brown
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),
                _webBullet(theme, 'Meet in a safe, public location'),
                const SizedBox(height: 16),
                _webBullet(theme, 'Inspect the item before payment'),
                const SizedBox(height: 16),
                _webBullet(theme, 'Never send money in advance'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.outlined_flag,
                size: 20,
                color: cs.onSurfaceVariant.withOpacity(0.6),
              ),
              label: Text(
                'Report this ad',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE1A6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: cs.error),
              SizedBox(width: 10),
              Text(
                'Safety Tips',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.error,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          _bullet(theme, cs, 'Meet in a safe, public location'),
          _bullet(theme, cs, 'Inspect item before payment'),
          _bullet(theme, cs, 'Never send money in advance'),
        ],
      ),
    );
  }

  static Widget _webBullet(ThemeData theme, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.circle, size: 6, color: Color(0xFFD97706)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB45309),
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _bullet(ThemeData theme, ColorScheme cs, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, size: 10, color: Color(0xFFE5A52D)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.error.withOpacity(.6),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportAd extends StatelessWidget {
  const _ReportAd();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              children: [
                Icon(Icons.outlined_flag, size: 25, color: cs.onSurfaceVariant),

                const SizedBox(width: 10),

                Text(
                  'Report this ad',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: cs.onSurfaceVariant.withOpacity(.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        const SizedBox(height: 18),
        Text(
          'Toyota Hiace Super GL, Gas, Not heavy T, inspected and ready for immediate transfer.',

          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.7,
            color: theme.brightness == Brightness.dark
                ? cs.onSurface.withOpacity(0.8)
                : const Color(0xFF5F6B7A),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Column(children: highlights.map((e) => _GreenBullet(text: e)).toList()),
        const SizedBox(height: 10),
        const _SubTitle(title: 'Music System Includes:'),
        const SizedBox(height: 14),
        Column(
          children: musicSystemIncludes
              .map((e) => _GreyBullet(text: e))
              .toList(),
        ),
        const SizedBox(height: 22),
        const _SubTitle(title: 'Battery System:'),
        const SizedBox(height: 14),
        Column(
          children: batterySystem.map((e) => _GreyBullet(text: e)).toList(),
        ),
      ],
    );

    if (!web) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: content,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: content,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool web;

  const _SectionTitle({required this.title, required this.web});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF1F2937),
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  final String title;

  const _SubTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
    );
  }
}

class _GreenBullet extends StatelessWidget {
  final String text;

  const _GreenBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 10,
              height: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF1FB655),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                height: 1.55,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.85)
                    : const Color(0xFF5F6B7A),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 6,
              height: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF6B7280),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
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
      height: web ? 200 : 150,
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
        const SizedBox(height: 14),
        mapCard,
      ],
    );

    if (!web) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SectionTitle(title: 'Similar Ads', web: web),

        Text(
          'See all',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w900,
            fontSize: 11.5,
          ),
        ),
      ],
    );
    SizedBox(height: 14);

    final list = SizedBox(
      height: web ? 190 : 176,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
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
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Column(children: [header, const SizedBox(height: 10), list]),
      );
    }

    return Column(children: [header, const SizedBox(height: 10), list]);
  }
}

class _SpecIconTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SpecIconTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: cs.onSurfaceVariant),

        const SizedBox(height: 10),

        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
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
          child: Icon(icon, size: 20, color: Colors.black87),
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
      width: web ? 160 : 150,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              imageUrl,
              height: web ? 92 : 100,
              width: web ? 160 : 150,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: web ? 92 : 72,
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
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                    fontSize: 10.8,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                    fontSize: 11.8,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withOpacity(.6),
                    fontSize: 10.5,
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
