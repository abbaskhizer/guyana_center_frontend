import 'package:flutter/material.dart';
import 'package:guyana_center_frontend/widgets/featured_item_card.dart';

class FeaturedVehiclesSection extends StatelessWidget {
  const FeaturedVehiclesSection({super.key});

  final vehicles = const [
    {
      'title': 'Toyota Hilux 2023',
      'price': '\$185,000',
      'location': 'Port of Spain',
      'imageUrl': 'https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=800',
      'pictureCount': 7,
    },
    {
      'title': 'Nissan Juke 2018',
      'price': '\$120,000',
      'location': 'San Fernando',
      'imageUrl': 'https://images.pexels.com/photos/358070/pexels-photo-358070.jpeg?auto=compress&cs=tinysrgb&w=800',
      'pictureCount': 12,
    },
    {
      'title': 'Toyota Aqua 2015',
      'price': '\$95,000',
      'location': 'Chaguanas',
      'imageUrl': 'https://images.pexels.com/photos/120049/pexels-photo-120049.jpeg?auto=compress&cs=tinysrgb&w=800',
      'pictureCount': 7,
    },
    {
      'title': 'Nissan Frontier 2021',
      'price': '\$210,000',
      'location': 'Arima',
      'imageUrl': 'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg?auto=compress&cs=tinysrgb&w=800',
      'pictureCount': 9,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
                  errorBuilder: (_, __, ___) => Icon(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: vehicles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final vehicle = vehicles[index];
                return SizedBox(
                  width: 240,
                  child: FeaturedItemCard(
                    title: vehicle['title'] as String,
                    price: vehicle['price'] as String,
                    location: vehicle['location'] as String,
                    imageUrl: vehicle['imageUrl'] as String,
                    pictureCount: vehicle['pictureCount'] as int,
                    fixedHeight: 280,
                    onTap: () {},
                    onFavoriteTap: () {},
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class RealEstateSection extends StatelessWidget {
  const RealEstateSection({super.key});

  final properties = const [
    {
      'title': '2BR House in Coromandel',
      'price': '\$1,250,000',
      'location': 'Coromandel',
      'imageUrl': 'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=900',
      'pictureCount': 9,
      'tag': 'For Sale',
    },
    {
      'title': '2BR Apt in Chaguanas',
      'price': '\$4,500/mo',
      'location': 'Chaguanas',
      'imageUrl': 'https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg?auto=compress&cs=tinysrgb&w=900',
      'pictureCount': 11,
      'tag': 'For Rent',
    },
    {
      'title': '3BR House in Maraval',
      'price': '\$2,800,000',
      'location': 'Maraval',
      'imageUrl': 'https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg?auto=compress&cs=tinysrgb&w=900',
      'pictureCount': 16,
      'tag': 'For Sale',
    },
    {
      'title': '2BR Apt in Maraval',
      'price': '\$6,200/mo',
      'location': 'Maraval',
      'imageUrl': 'https://images.pexels.com/photos/1642128/pexels-photo-1642128.jpeg?auto=compress&cs=tinysrgb&w=900',
      'pictureCount': 14,
      'tag': 'For Rent',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.home_outlined,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: properties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final property = properties[index];
                return SizedBox(
                  width: 240,
                  child: FeaturedItemCard(
                    title: property['title'] as String,
                    price: property['price'] as String,
                    location: property['location'] as String,
                    imageUrl: property['imageUrl'] as String,
                    pictureCount: property['pictureCount'] as int,
                    tag: property['tag'] as String?,
                    fixedHeight: 280,
                    onTap: () {},
                    onFavoriteTap: () {},
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
