import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/home_tab_controller.dart';
import 'package:guyana_center_frontend/widgets/featured_item_card.dart';

class FeaturedVehiclesSection extends StatelessWidget {
  const FeaturedVehiclesSection({super.key});



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final controller = Get.find<HomeTabController>();

    return Column(
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E8),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/vehicle.png",
                  fit: BoxFit.contain,
                  width: 28,
                  height: 28,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.directions_car_outlined,
                    color: cs.primary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Vehicles',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Latest cars, trucks & SUVs',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'See all >',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Vehicles grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 280,
            child: Obx(() {
              if (controller.isLoadingFeatured.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final vehicles = controller.featuredListings
                  .where((l) => l.categoryId.toLowerCase() == 'vehicles')
                  .toList();
                  
              if (vehicles.isEmpty) {
                return const Center(child: Text("No vehicles found"));
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: vehicles.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  final v = vehicles[index];
                  return SizedBox(
                    width: 240,
                    child: FeaturedItemCard(
                      title: v.title,
                      price: v.price,
                      location: v.location,
                      imageUrl: v.imageUrl,
                      pictureCount: v.images.length,
                      fixedHeight: 280,
                      onTap: () => Get.toNamed('/listing-detail', arguments: v),
                      onFavoriteTap: () {},
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}


class RealEstateSection extends StatelessWidget {
  const RealEstateSection({super.key});



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final controller = Get.find<HomeTabController>();

    return Column(
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/realestate.png",
                  fit: BoxFit.contain,
                  width: 28,
                  height: 28,
                  errorBuilder: (_, _, _) =>
                      Icon(Icons.home_outlined, color: cs.primary, size: 28),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Real Estate',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Houses & apartments for sale or rent',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'See all >',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Properties grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 280,
            child: Obx(() {
              if (controller.isLoadingProperties.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final props = controller.properties;
                  
              if (props.isEmpty) {
                return const Center(child: Text("No properties found"));
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: props.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  final p = props[index];
                  return SizedBox(
                    width: 240,
                    child: FeaturedItemCard(
                      title: p.title,
                      price: p.price,
                      location: p.location,
                      imageUrl: p.imageUrl,
                      pictureCount: p.images.length,
                      tag: p.propertyType,
                      fixedHeight: 280,
                      onTap: () => Get.toNamed('/listing-detail', arguments: p),
                      onFavoriteTap: () {},
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
