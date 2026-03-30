import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:guyana_center_frontend/screens/store_screen.dart';

class TopStoresSection extends StatelessWidget {
  const TopStoresSection({super.key});

  static const List<Map<String, dynamic>> stores = [
    {
      'name': 'Adelan Properties',
      'category': 'Real Estate',
      'rating': '4.8',
      'color': Color(0xFF16A34A),
      'letter': 'A',
    },
    {
      'name': 'Andre Haddad Motors',
      'category': 'Vehicles',
      'rating': '4.9',
      'color': Color(0xFFDC2626),
      'letter': 'A',
    },
    {
      'name': 'Astral Realtors',
      'category': 'Real Estate',
      'rating': '4.7',
      'color': Color(0xFFD97706),
      'letter': 'A',
    },
  ];

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isWeb = _isWebDesktop(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Stores',
                    style:
                        (isWeb
                                ? theme.textTheme.titleLarge
                                : theme.textTheme.bodyMedium)
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: isWeb ? 24 : 14.5,
                              color: cs.onSurface,
                            ),
                  ),
                  const SizedBox(height: 4),
                  if (isWeb)
                    Text(
                      'Trusted sellers on Pin.tt',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                        fontSize: isWeb ? 14 : 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(StoresScreen());
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isWeb ? 'All stores' : 'View All',
                    style:
                        (isWeb
                                ? theme.textTheme.bodyMedium
                                : theme.textTheme.bodySmall)
                            ?.copyWith(
                              color: cs.primary,
                              fontWeight: isWeb
                                  ? FontWeight.w700
                                  : FontWeight.w800,
                            ),
                  ),
                  const SizedBox(width: 4),
                  if (isWeb)
                    Icon(Icons.chevron_right, color: cs.primary, size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (isWeb)
          Row(
            children: List.generate(stores.length, (index) {
              final store = stores[index];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == stores.length - 1 ? 0 : 16,
                  ),
                  child: _TopStoreCard(
                    name: store['name'] as String,
                    category: store['category'] as String,
                    rating: store['rating'] as String,
                    color: store['color'] as Color,
                    letter: store['letter'] as String,
                    compact: false,
                  ),
                ),
              );
            }),
          )
        else
          Column(
            children: List.generate(stores.length, (index) {
              final store = stores[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == stores.length - 1 ? 0 : 12,
                ),
                child: _TopStoreCard(
                  name: store['name'] as String,
                  category: store['category'] as String,
                  rating: store['rating'] as String,
                  color: store['color'] as Color,
                  letter: store['letter'] as String,
                  compact: true,
                ),
              );
            }),
          ),
      ],
    );
  }
}

class _TopStoreCard extends StatelessWidget {
  final String name;
  final String category;
  final String rating;
  final Color color;
  final String letter;
  final bool compact;

  const _TopStoreCard({
    required this.name,
    required this.category,
    required this.rating,
    required this.color,
    required this.letter,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 44 : 48,
            height: compact ? 44 : 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                    fontSize: compact ? 13.5 : 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.6),
                    fontSize: compact ? 11.5 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_outline,
                color: Color(0xFFD97706),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                rating,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhyTrinisLoveSection extends StatelessWidget {
  const WhyTrinisLoveSection({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isWeb = _isWebDesktop(context);

    final cards = [
      const _BenefitCard(
        title: '100% Free',
        description:
            'Post unlimited ads at no cost. No hidden fees, no premium plans — just free classifieds.',
        icon: Icons.shield_outlined,
        color: Color(0xFF16A34A),
        bgColor: Color(0xFFF0FDF4),
        borderColor: Color(0xFFDCFCE7),
      ),
      const _BenefitCard(
        title: 'Fast Results',
        description:
            'Post an ad in under 60 seconds. Get calls from buyers the same day you list.',
        icon: Icons.trending_up,
        color: Color(0xFFDC2626),
        bgColor: Color(0xFFFEF2F2),
        borderColor: Color(0xFFFEE2E2),
      ),
      const _BenefitCard(
        title: 'Made for T&T',
        description:
            'Built for locals — browse by parish, connect with nearby sellers, and deal in TTD.',
        icon: Icons.location_on_outlined,
        color: Color(0xFFD97706),
        bgColor: Color(0xFFFFFBEB),
        borderColor: Color(0xFFFEF3C7),
      ),
    ];

    return Column(
      children: [
        SizedBox(height: isWeb ? 64 : 28),
        Text(
          'Why Trinis Love Gyanacentral',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
            fontSize: isWeb ? 32 : 22,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Simple, free, and built for Trinidad & Tobago',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withOpacity(0.6),
            fontSize: isWeb ? 16 : 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isWeb ? 48 : 24),

        if (isWeb)
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 24),
              Expanded(child: cards[1]),
              const SizedBox(width: 24),
              Expanded(child: cards[2]),
            ],
          )
        else
          Column(
            children: [
              cards[0],
              const SizedBox(height: 12),
              cards[1],
              const SizedBox(height: 12),
              cards[2],
            ],
          ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color borderColor;

  const _BenefitCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isWeb = _isWebDesktop(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 32 : 18,
        vertical: isWeb ? 48 : 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.10) : bgColor,
        borderRadius: BorderRadius.circular(isWeb ? 24 : 18),
        border: Border.all(
          color: isDark ? color.withOpacity(0.25) : borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: isWeb ? 56 : 48,
            height: isWeb ? 56 : 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(isWeb ? 16 : 14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white, size: isWeb ? 28 : 24),
          ),
          SizedBox(height: isWeb ? 32 : 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
              fontSize: isWeb ? 20 : 17,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? cs.onSurface.withOpacity(.72)
                  : const Color(0xFF6B7280),
              height: 1.6,
              fontSize: isWeb ? 14 : 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
