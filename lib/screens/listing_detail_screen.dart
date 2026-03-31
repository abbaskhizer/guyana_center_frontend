import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:guyana_center_frontend/controller/listing_detail_controller.dart';
import 'package:guyana_center_frontend/controller/message_controller.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/screens/chat_screen.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/controller/notification_controller.dart';
import 'package:http/http.dart' as http;

class ShareHelper {
  static const String baseUrl = 'https://guyanacentral.com';

  static void shareListing(String listingId, String title) {
    final url = '$baseUrl/listing/$listingId';
    final text = 'Check out this listing on GUYANA CENTRAL: $title\n$url';
    _share(text);
  }

  static void shareAgent(String userId, String name) {
    final url = '$baseUrl/agent/$userId';
    final text = 'Check out $name\'s profile on GUYANA CENTRAL\n$url';
    _share(text);
  }

  static void _share(String text) {
    if (kIsWeb) {
      Clipboard.setData(ClipboardData(text: text));
      Get.snackbar(
        'Copied!',
        'Link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF16A34A),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      // For mobile, use share dialog through a method channel or plugin
      Clipboard.setData(ClipboardData(text: text));
      Get.snackbar(
        'Copied!',
        'Link copied to clipboard. You can now paste and share it.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF16A34A),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

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
      backgroundColor: theme.scaffoldBackgroundColor,
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
      final item = controller.itemNullable;
      final idx = controller.currentImage.value;
      final theme = Theme.of(context);
      final cs = theme.colorScheme;
      final dividerColor = theme.dividerTheme.color ?? cs.outlineVariant;

      if (item == null) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: controller.isItemLoading.value
                ? CircularProgressIndicator(color: cs.primary)
                : Text(
                    'Listing not found',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      }

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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: _Breadcrumb2(item: item),
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

                  const SizedBox(height: 12),
                  _MobileTitleBlock(item: item),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(color: dividerColor),
                  ),
                  const SizedBox(height: 15),
                  _MobilePriceBlock(item: item),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(color: dividerColor),
                  ),
                  const SizedBox(height: 14),
                  _SpecsRow(item: item),
                  const SizedBox(height: 14),
                  _PropertyFeatures(item: item, web: false),
                  _JobFeatures(item: item, web: false),
                  if (item.user?.id == AuthService.to.userId.value) ...[
                    const SizedBox(height: 14),
                    _FeatureAdCard(),
                  ],
                  const SizedBox(height: 14),
                  _DescriptionSection(controller: controller, web: false),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(color: dividerColor),
                  ),
                  const SizedBox(height: 14),
                  _MobileActionSection(item: item),
                  const SizedBox(height: 14),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        if (item.user?.id != AuthService.to.userId.value)
                          Expanded(child: _ReportAd(item: item)),
                        if (item.user?.id != AuthService.to.userId.value)
                          Container(
                            height: 15,
                            width: 1.5,
                            color: cs.outlineVariant,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        Expanded(child: _ShareAd(listingId: item.id.toString(), title: item.title)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(color: dividerColor),
                  ),
                  const SizedBox(height: 14),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: _SafetyTipsCard(web: false),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(color: dividerColor),
                  ),
                  const SizedBox(height: 14),
                  _LocationSection(controller: controller, web: false),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(color: dividerColor),
                  ),
                  const SizedBox(height: 14),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: _SellerCard(web: false),
                  ),
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
      final item = controller.itemNullable;
      final idx = controller.currentImage.value;

      if (item == null) {
        return Center(
          child: controller.isItemLoading.value
              ? CircularProgressIndicator(color: cs.primary)
              : Text(
                  'Listing not found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        );
      }

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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _Breadcrumb2(item: item),
                      ),
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
                                _PropertyFeatures(item: item, web: true),
                                _JobFeatures(item: item, web: true),
                                const SizedBox(height: 14),
                                _DescriptionSection(
                                  controller: controller,
                                  web: true,
                                ),
                                const SizedBox(height: 14),
                                _LocationSection(
                                  controller: controller,
                                  web: true,
                                ),
                                const SizedBox(height: 14),
                                const Divider(),
                                const SizedBox(height: 14),
                                const _SellerCard(web: true),
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                item.images[imageIndex].startsWith('http')
                    ? item.images[imageIndex]
                    : '${ApiService.baseUrl}${item.images[imageIndex]}',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: cs.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            if (item.images.length > 1) ...[
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
                  color: theme.cardColor.withOpacity(.95),
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
                        color: fav ? cs.primary : cs.onSurface,
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
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
                item.images[imageIndex].startsWith('http')
                    ? item.images[imageIndex]
                    : '${ApiService.baseUrl}${item.images[imageIndex]}',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: cs.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            if (item.images.length > 1) ...[
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
                      '${item.images.length}',
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
        itemCount: item.images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
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
                  item.images[i].startsWith('http')
                      ? item.images[i]
                      : '${ApiService.baseUrl}${item.images[i]}',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
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
  final ListingVM item;

  const _Breadcrumb2({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget sep() => const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.chevron_right_rounded,
        size: 12,
        color: Color(0xFFB8BEC8),
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
          Text(
            item.categoryId[0].toUpperCase() + item.categoryId.substring(1),
            style: crumbStyle,
          ),
          sep(),
          Text(item.title, style: activeStyle),
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
              Text(item.timeAgo, style: metaStyle),
              const SizedBox(width: 14),
              Icon(
                Icons.remove_red_eye_outlined,
                size: 15,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text('${item.views}', style: metaStyle),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
              if (item.negotiable == true) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    "(Negotiable)",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: cs.primary.withOpacity(0.7),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (item.categoryId.toLowerCase() != 'jobs' &&
              item.categoryId.toLowerCase() != 'pets' &&
              item.categoryId.toLowerCase() != 'services' &&
              item.categoryId.toLowerCase() != 'business') ...[
            const SizedBox(height: 14),
            Text(
              "Condition",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.condition[0].toUpperCase() + item.condition.substring(1),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: cs.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
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
    final catId = item.categoryId.toLowerCase();
    final isRealEstate = catId == 'real_estate';
    final isJob = catId == 'jobs';
    final isElectronics = catId == 'electronics';
    final isFashion = catId == 'fashion';
    final isHomeGarden = catId == 'home_garden';
    final isKids = catId == 'kids';
    final isPets = catId == 'pets';
    final isHealthBeauty = catId == 'health_beauty';
    final isServices = catId == 'services';
    final isBusiness = catId == 'business';

    if (isFashion || isHealthBeauty || isServices || isBusiness) {
      return Row(
        children: [
          Expanded(
            child: _SpecIconTile(
              icon: isHealthBeauty
                  ? Icons.spa_outlined
                  : isServices
                  ? Icons.design_services_outlined
                  : isBusiness
                  ? Icons.business_center_outlined
                  : Icons.checkroom_outlined,
              value: item.brand ?? 'N/A',
              label: isServices
                  ? 'Service Type'
                  : isBusiness
                  ? 'Business Type'
                  : 'Brand',
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          const Expanded(child: SizedBox.shrink()),
        ],
      );
    }

    if (isElectronics || isHomeGarden || isKids || isPets) {
      return Row(
        children: [
          Expanded(
            child: _SpecIconTile(
              icon: isHomeGarden
                  ? Icons.chair_outlined
                  : isKids
                  ? Icons.toys_outlined
                  : isPets
                  ? Icons.pets_outlined
                  : Icons.branding_watermark_outlined,
              value: item.brand ?? 'N/A',
              label: isPets ? 'Species / Type' : 'Brand',
            ),
          ),
          Expanded(
            child: _SpecIconTile(
              icon: isHomeGarden
                  ? Icons.widgets_outlined
                  : isKids
                  ? Icons.child_friendly_outlined
                  : isPets
                  ? Icons.category_outlined
                  : Icons.devices_outlined,
              value: item.model ?? 'N/A',
              label: isPets ? 'Breed' : 'Model',
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
        ],
      );
    }

    if (isJob) {
      return Row(
        children: [
          Expanded(
            child: _SpecIconTile(
              icon: Icons.work_outline_rounded,
              value: _jobTypeLabel(item.jobType),
              label: 'Job Type',
            ),
          ),
          Expanded(
            child: _SpecIconTile(
              icon: Icons.trending_up_rounded,
              value: _expLabel(item.experienceLevel),
              label: 'Experience',
            ),
          ),
          Expanded(
            child: _SpecIconTile(
              icon: Icons.schedule_rounded,
              value:
                  item.salaryPeriod != null &&
                      (item.salaryPeriod as String).isNotEmpty
                  ? (item.salaryPeriod as String)[0].toUpperCase() +
                        (item.salaryPeriod as String).substring(1)
                  : 'N/A',
              label: 'Pay Period',
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _SpecIconTile(
            icon: isRealEstate
                ? Icons.king_bed_outlined
                : Icons.directions_car_filled_outlined,
            value: isRealEstate
                ? '${item.bedrooms ?? 'N/A'}'
                : (item.brand ?? 'N/A'),
            label: isRealEstate ? 'Beds' : 'Brand',
          ),
        ),
        Expanded(
          child: _SpecIconTile(
            icon: isRealEstate
                ? Icons.bathtub_outlined
                : Icons.local_gas_station_outlined,
            value: isRealEstate
                ? '${item.bathrooms ?? 'N/A'}'
                : (item.fuelType ?? 'N/A'),
            label: isRealEstate ? 'Baths' : 'Fuel',
          ),
        ),
        Expanded(
          child: _SpecIconTile(
            icon: isRealEstate
                ? Icons.square_foot_outlined
                : Icons.settings_outlined,
            value: isRealEstate
                ? (item.area != null
                      ? '${item.area!.toStringAsFixed(0)}'
                      : 'N/A')
                : (item.transmission ?? 'N/A'),
            label: isRealEstate ? 'Sqft' : 'Trans',
          ),
        ),
      ],
    );
  }

  static String _jobTypeLabel(dynamic jt) {
    const labels = {
      'full-time': 'Full-Time',
      'part-time': 'Part-Time',
      'contract': 'Contract',
      'internship': 'Internship',
      'remote': 'Remote',
    };
    if (jt == null || (jt as String).isEmpty) return 'N/A';
    return labels[jt] ?? jt;
  }

  static String _expLabel(dynamic el) {
    const labels = {
      'entry': 'Entry',
      'mid': 'Mid Level',
      'senior': 'Senior',
      'executive': 'Executive',
    };
    if (el == null || (el as String).isEmpty) return 'N/A';
    return labels[el] ?? el;
  }
}

class _PropertyFeatures extends StatelessWidget {
  final dynamic item;
  final bool web;

  const _PropertyFeatures({required this.item, required this.web});

  @override
  Widget build(BuildContext context) {
    if (item.categoryId.toLowerCase() != 'real_estate')
      return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Map<String, dynamic>? waterData;
    Map<String, dynamic>? amenitiesData;

    try {
      if (item.water != null) {
        if (item.water is String) {
          waterData = jsonDecode(item.water);
        } else {
          waterData = item.water;
        }
      }
      if (item.amenities != null) {
        if (item.amenities is String) {
          amenitiesData = jsonDecode(item.amenities);
        } else {
          amenitiesData = item.amenities;
        }
      }
    } catch (_) {}

    final features = <Map<String, String>>[];

    if (item.village != null && item.village.isNotEmpty)
      features.add({"label": "Village", "value": item.village});
    if (item.propertyType != null)
      features.add({"label": "Property Type", "value": item.propertyType});
    if (item.parking != null && item.parking != 'None')
      features.add({"label": "Parking", "value": item.parking});
    features.add({
      "label": "Gated",
      "value": item.gated == true ? "Yes" : "No",
    });
    features.add({
      "label": "Tiled",
      "value": item.tiled == true ? "Yes" : "No",
    });
    if (item.ac != null && item.ac != 'None')
      features.add({"label": "AC", "value": item.ac});
    features.add({
      "label": "Master Ensuite",
      "value": item.ensuite == true ? "Yes" : "No",
    });
    if (item.cupboards != null && item.cupboards != 'None')
      features.add({"label": "Cupboards", "value": item.cupboards});
    features.add({
      "label": "Furnished",
      "value": item.furnished == true ? "Yes" : "No",
    });

    String waterStr = "";
    if (waterData != null) {
      final w = <String>[];
      if (waterData['hot'] == true) w.add("Hot");
      if (waterData['cold'] == true) w.add("Cold");
      waterStr = w.join(", ");
    }
    if (waterStr.isNotEmpty)
      features.add({"label": "Water", "value": waterStr});

    String amenitiesStr = "";
    if (amenitiesData != null) {
      final a = <String>[];
      if (amenitiesData['pool'] == true) a.add("Pool");
      if (amenitiesData['elevator'] == true) a.add("Elevator");
      if (amenitiesData['patio'] == true) a.add("Patio");
      amenitiesStr = a.join(", ");
    }
    if (amenitiesStr.isNotEmpty)
      features.add({"label": "Includes", "value": amenitiesStr});

    if (features.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: web ? 0 : 22, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Property Details', web: web),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 12,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final f = features[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f['label']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        f['value']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _JobFeatures extends StatelessWidget {
  final dynamic item;
  final bool web;

  const _JobFeatures({required this.item, required this.web});

  @override
  Widget build(BuildContext context) {
    if (item.categoryId.toLowerCase() != 'jobs') return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final features = <Map<String, String>>[];

    const jobTypeLabels = {
      'full-time': 'Full-Time',
      'part-time': 'Part-Time',
      'contract': 'Contract',
      'internship': 'Internship',
      'remote': 'Remote',
    };
    const expLabels = {
      'entry': 'Entry Level',
      'mid': 'Mid Level',
      'senior': 'Senior',
      'executive': 'Executive',
    };
    if (item.jobType != null && item.jobType.isNotEmpty)
      features.add({
        "label": "Job Type",
        "value": jobTypeLabels[item.jobType] ?? item.jobType,
      });
    if (item.experienceLevel != null && item.experienceLevel.isNotEmpty)
      features.add({
        "label": "Experience Level",
        "value": expLabels[item.experienceLevel] ?? item.experienceLevel,
      });
    if (item.salaryPeriod != null && item.salaryPeriod.isNotEmpty)
      features.add({
        "label": "Salary Period",
        "value":
            (item.salaryPeriod as String)[0].toUpperCase() +
            (item.salaryPeriod as String).substring(1),
      });
    if (item.companyName != null && item.companyName.isNotEmpty)
      features.add({"label": "Company", "value": item.companyName});
    if (item.industry != null && item.industry.isNotEmpty)
      features.add({"label": "Industry", "value": item.industry});

    if (features.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: web ? 0 : 22, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Job Details', web: web),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 12,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final f = features[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f['label']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        f['value']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
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
    final c = Get.find<ListingDetailController>();

    final canCall =
        item.contactMethod == 'call' || item.contactMethod == 'both';
    final canChat =
        item.contactMethod == 'chat' || item.contactMethod == 'both';

    final isOwner = item.user?.id == AuthService.to.userId.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (canCall)
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: Obx(
                      () => ElevatedButton.icon(
                        onPressed: () {
                          if (!c.isLoggedIn) {
                            Get.snackbar(
                              "Login Required",
                              "Please login to contact the seller",
                              backgroundColor: Colors.red.withOpacity(.1),
                            );
                            return;
                          }
                          c.togglePhone();
                          c.makeCall();
                        },
                        icon: Icon(Icons.call, size: 16, color: cs.onPrimary),
                        label: Text(
                          c.showPhoneNumber.value
                              ? (item.contactPhone.isNotEmpty
                                    ? item.contactPhone
                                    : "Call")
                              : 'Show Phone Number',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onPrimary,
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
                ),
              if (canCall && canChat) const SizedBox(width: 10),
              if (canChat && !isOwner)
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        if (!c.isLoggedIn) {
                          Get.snackbar(
                            "Login Required",
                            "Please login to message the seller",
                            backgroundColor: Colors.red.withOpacity(.1),
                          );
                          return;
                        }
                        // Get seller ID from item
                        final sellerId = item.user?.id?.toString();

                        if (sellerId == null || sellerId.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Unable to get seller information",
                          );
                          return;
                        }

                        // Check if seller is the current user
                        if (sellerId ==
                            AuthService.to.userId.value.toString()) {
                          Get.snackbar("Error", "You cannot message yourself");
                          return;
                        }

                        // Refresh conversations from backend so we can reuse existing conversationId
                        final msgController =
                            Get.isRegistered<MessagesController>()
                            ? Get.find<MessagesController>()
                            : Get.put(MessagesController(), permanent: true);
                        await msgController.refreshConversations();

                        final currentUserId = AuthService.to.userId.value
                            .toString();
                        String existingConversationId = '';
                        for (final conv in msgController.conversations) {
                          final sameListing = conv.listingId == item.id;
                          final samePair =
                              (conv.sellerId == sellerId &&
                                  conv.buyerId == currentUserId) ||
                              (conv.buyerId == sellerId &&
                                  conv.sellerId == currentUserId);
                          if (sameListing && samePair) {
                            existingConversationId = conv.conversationId;
                            break;
                          }
                        }

                        // Navigate to chat screen with listing context
                        Get.to(
                          ChatScreen(
                            conversationId: existingConversationId,
                            otherUserId: sellerId,
                            otherUserName: item.user?.name ?? 'Seller',
                            otherUserPhotoUrl: item.user?.photoUrl,
                            listingId: item.id,
                            listingTitle: item.title,
                            listingPrice: item.price != null
                                ? double.tryParse(item.price.toString())
                                : null,
                            listingImages: item.images,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.mail_outline,
                        size: 16,
                        color: cs.onSurfaceVariant,
                      ),
                      label: Text(
                        'Send Message',
                        style: theme.textTheme.bodySmall?.copyWith(
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.price,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                  fontSize: 26,
                ),
              ),
              if (item.negotiable == true) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    "(Negotiable)",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: cs.primary.withOpacity(0.7),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (item.categoryId.toLowerCase() != 'jobs' &&
              item.categoryId.toLowerCase() != 'pets' &&
              item.categoryId.toLowerCase() != 'services' &&
              item.categoryId.toLowerCase() != 'business') ...[
            const SizedBox(height: 4),
            Text(
              item.condition,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(.55),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 14),
          const SizedBox(height: 14),
          _SpecsRow(item: item),
          _PropertyFeatures(item: item, web: true),
          _JobFeatures(item: item, web: true),
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
    final c = Get.find<ListingDetailController>();

    final canCall =
        item.contactMethod == 'call' || item.contactMethod == 'both';
    final canChat =
        item.contactMethod == 'chat' || item.contactMethod == 'both';
    final isOwner = item.user?.id == AuthService.to.userId.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Column(
            children: [
              if (canCall)
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton.icon(
                      onPressed: () {
                        if (!c.isLoggedIn) {
                          Get.snackbar(
                            "Login Required",
                            "Please login to contact the seller",
                            backgroundColor: Colors.red.withOpacity(.1),
                          );
                          return;
                        }
                        c.togglePhone();
                        c.makeCall();
                      },
                      icon: const Icon(Icons.call, size: 16),
                      label: Text(
                        c.showPhoneNumber.value
                            ? (item.contactPhone.isNotEmpty
                                  ? item.contactPhone
                                  : "Call Seller")
                            : 'Show Phone Number',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              if (canCall && canChat) const SizedBox(height: 10),
              if (canChat && !isOwner)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      if (!c.isLoggedIn) {
                        Get.snackbar(
                          "Login Required",
                          "Please login to message the seller",
                          backgroundColor: Colors.red.withOpacity(.1),
                        );
                        return;
                      }
                      // Get seller ID from item
                      final sellerId = item.user?.id?.toString();

                      if (sellerId == null || sellerId.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Unable to get seller information",
                        );
                        return;
                      }

                      // Check if seller is the current user
                      if (sellerId == AuthService.to.userId.value.toString()) {
                        Get.snackbar("Error", "You cannot message yourself");
                        return;
                      }

                      // Refresh conversations from backend so we can reuse existing conversationId
                      final msgController =
                          Get.isRegistered<MessagesController>()
                          ? Get.find<MessagesController>()
                          : Get.put(MessagesController(), permanent: true);
                      await msgController.refreshConversations();

                      final currentUserId = AuthService.to.userId.value
                          .toString();
                      String existingConversationId = '';
                      for (final conv in msgController.conversations) {
                        final sameListing = conv.listingId == item.id;
                        final samePair =
                            (conv.sellerId == sellerId &&
                                conv.buyerId == currentUserId) ||
                            (conv.buyerId == sellerId &&
                                conv.sellerId == currentUserId);
                        if (sameListing && samePair) {
                          existingConversationId = conv.conversationId;
                          break;
                        }
                      }

                      // Navigate to chat screen with listing context
                      Get.to(
                        ChatScreen(
                          conversationId: existingConversationId,
                          otherUserId: sellerId,
                          otherUserName: item.user?.name ?? 'Seller',
                          otherUserPhotoUrl: item.user?.photoUrl,
                          listingId: item.id,
                          listingTitle: item.title,
                          listingPrice: item.price != null
                              ? double.tryParse(item.price.toString())
                              : null,
                          listingImages: item.images,
                        ),
                      );
                    },
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
    final item = Get.find<ListingDetailController>().item;

    final userName = item.user?.name ?? 'Seller';
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'S';
    // Fallback to current user's photo if this is the user's own listing
    final bool isMe = item.user?.id == AuthService.to.userId.value;
    final userPhoto =
        (item.user?.photoUrl != null && item.user!.photoUrl!.isNotEmpty)
        ? item.user!.photoUrl
        : (isMe ? AuthService.to.userPhotoUrl.value : null);

    final hasPhoto = userPhoto != null && userPhoto.isNotEmpty;
    final photoUrl = hasPhoto
        ? (userPhoto.startsWith('http')
              ? userPhoto
              : '${ApiService.baseUrl}${userPhoto.startsWith('/') ? '' : '/'}$userPhoto')
        : null;

    if (web) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: hasPhoto ? NetworkImage(photoUrl!) : null,
              onBackgroundImageError: hasPhoto
                  ? (exception, stackTrace) {
                      print('Error loading seller photo: $exception');
                    }
                  : null,
              child: !hasPhoto ? Text(userInitial) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  /*
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Color(0xFFFFB020),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.9  •  15 ads',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(.6),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  */
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        '/agent-profile',
                        arguments: {'userId': item.user?.id, 'user': item.user},
                      );
                    },
                    child: Text(
                      'View All Ads by Seller',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w900,
                      ),
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
        color: theme.cardColor,
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
                backgroundColor: cs.onSurfaceVariant.withOpacity(.6),
                backgroundImage: hasPhoto ? NetworkImage(photoUrl!) : null,
                onBackgroundImageError: hasPhoto
                    ? (exception, stackTrace) {
                        print('Error loading mobile seller photo: $exception');
                      }
                    : null,
                child: !hasPhoto
                    ? Text(
                        userInitial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Posting since ${item.timeAgo}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface.withOpacity(.5),
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    /*
                    Row(
                      children: [
                        const Icon(
                          Icons.star_border_rounded,
                          size: 20,
                          color: Color(0xFFFFB020),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'No ratings yet',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(.6),
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                    */
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Get.toNamed(
                '/agent-profile',
                arguments: {'userId': item.user?.id, 'user': item.user},
              );
            },
            child: Text(
              'View All Ads by Seller',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w900,
              ),
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
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF2A2116) : const Color(0xFFFFF4E5);

    final borderColor = isDark
        ? const Color(0xFF5B4A2E)
        : const Color(0xFFFFE1A6);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: cs.error),
              const SizedBox(width: 10),
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
                color: cs.onSurface.withOpacity(.78),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportAd extends StatefulWidget {
  final dynamic item;
  const _ReportAd({required this.item});

  @override
  State<_ReportAd> createState() => _ReportAdState();
}

class _ReportAdState extends State<_ReportAd> {
  final _descriptionController = TextEditingController();

  void _showReportDialog(BuildContext context) {
    final controller = Get.find<ListingDetailController>();
    final item = controller.itemNullable;
    if (item == null) return;

    String selectedReason = 'spam';
    final reasons = [
      {
        'value': 'spam',
        'label': 'Spam or misleading',
        'icon': Icons.markunread_mailbox,
      },
      {'value': 'fraud', 'label': 'Scam or fraud', 'icon': Icons.money_off},
      {
        'value': 'inappropriate',
        'label': 'Inappropriate content',
        'icon': Icons.no_adult_content,
      },
      {
        'value': 'prohibited',
        'label': 'Prohibited item/service',
        'icon': Icons.block,
      },
      {'value': 'other', 'label': 'Other', 'icon': Icons.report_outlined},
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.flag, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 8),
              Text(
                'Report this ad',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a reason:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...reasons.map(
                  (r) => RadioListTile<String>(
                    value: r['value'] as String,
                    groupValue: selectedReason,
                    onChanged: (v) => setDialogState(() => selectedReason = v!),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    secondary: Icon(r['icon'] as IconData, size: 20),
                    title: Text(r['label'] as String),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Additional details (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await _submitReport(
                  context,
                  item.id,
                  selectedReason,
                  _descriptionController.text,
                );
              },
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport(
    BuildContext context,
    int listingId,
    String reason,
    String description,
  ) async {
    final token = AuthService.to.accessToken.value;

    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/listings/$listingId/report'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'reason': reason, 'description': description}),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        if (Get.isRegistered<NotificationController>()) {
          Get.find<NotificationController>().refreshNotifications();
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Report submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Failed to submit report'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _showReportDialog(context),
              child: Row(
                children: [
                  Icon(
                    Icons.outlined_flag,
                    size: 22,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Report this ad',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
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

class _ShareAd extends StatelessWidget {
  final String listingId;
  final String title;
  
  const _ShareAd({required this.listingId, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => ShareHelper.shareListing(listingId, title),
              borderRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Share this ad',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
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

class _FeatureAdCard extends StatelessWidget {
  const _FeatureAdCard();

  void _onFeaturePressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Work in progress'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary.withOpacity(0.1), cs.primary.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.star_rounded, color: cs.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feature Your Ad',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Make your ad appear at the top of search results',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _onFeaturePressed(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Feature Now',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final item = controller.item;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Description', web: web),
        const SizedBox(height: 18),
        Text(
          item.description.isNotEmpty
              ? item.description
              : 'No description provided.',
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.7,
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
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
        color: Theme.of(context).cardColor,
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: cs.onSurface,
      ),
    );
  }
}

class _LocationSection extends StatelessWidget {
  final ListingDetailController controller;
  final bool web;

  const _LocationSection({required this.controller, required this.web});

  @override
  Widget build(BuildContext context) {
    final item = controller.item;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final loggedIn = controller.isLoggedIn;

      final hasCoordinates = item.latitude != null && item.longitude != null;
      final mapLatLng = hasCoordinates
          ? LatLng(item.latitude!, item.longitude!)
          : const LatLng(10.6918, -61.2225); // Default to Port of Spain

      final mapCard = Container(
        height: web ? 200 : 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // OpenStreetMap - Static (non-interactive)
              FlutterMap(
                options: MapOptions(
                  initialCenter: mapLatLng,
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none, // Disable all interactions
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.guyanacentral.www',
                  ),
                  // Always show marker at listing location
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: mapLatLng,
                        width: 40,
                        height: 40,
                        child: Container(
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
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Blur overlay for non-logged in users (covering the marker too)
              if (!loggedIn)
                Positioned.fill(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withOpacity(.1),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              color: cs.onSurface,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Log in to view exact location",
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
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
          _SectionTitle(title: 'Location: ${item.location}', web: web),
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
    });
  }
}

class _SimilarAdsSection extends StatelessWidget {
  final ListingDetailController controller;
  final bool web;

  const _SimilarAdsSection({required this.controller, required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_SectionTitle(title: 'Similar Ads', web: web)],
    );

    final list = Obx(() {
      if (controller.isSimilarLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.similarAds.isEmpty) {
        return Container(
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          child: Text(
            'No similar ads found',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }

      return SizedBox(
        height: web ? 190 : 176,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: controller.similarAds.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, i) =>
              _SimilarCard(ad: controller.similarAds[i], web: web),
        ),
      );
    });

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

class _MiniTag extends StatelessWidget {
  final String text;

  const _MiniTag({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: cs.onSurface.withOpacity(.7),
          fontSize: 10.5,
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: theme.cardColor.withOpacity(.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: cs.onSurface),
        ),
      ),
    );
  }
}

class _SimilarCard extends StatelessWidget {
  final ListingVM ad;
  final bool web;

  const _SimilarCard({required this.ad, required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final imageUrl = ad.images.isEmpty
        ? 'https://via.placeholder.com/150'
        : ad.images[0].startsWith('http')
        ? ad.images[0]
        : '${ApiService.baseUrl}${ad.images[0]}';

    return GestureDetector(
      onTap: () async {
        // Delete old controller to force fresh state
        await Get.delete<ListingDetailController>();
        Get.offNamed(
          '/listing-detail',
          arguments: ad,
          preventDuplicates: false,
        );
      },
      child: Container(
        width: web ? 160 : 150,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: Image.network(
                imageUrl,
                height: web ? 92 : 100,
                width: web ? 160 : 150,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: web ? 92 : 100,
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
                    ad.title,
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
                    ad.price,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.primary,
                      fontSize: 11.8,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ad.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurfaceVariant,
                      fontSize: 10.5,
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
