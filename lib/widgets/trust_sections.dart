import 'package:flutter/material.dart';

class TopStoresSection extends StatelessWidget {
  const TopStoresSection({super.key});

  final stores = const [
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Stores',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Trusted sellers on Pin.tt',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'All stores',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF16A34A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF16A34A),
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: stores.map((store) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: store == stores.last ? 0 : 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: store['color'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        store['letter'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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
                            store['name'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            store['category'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_outline,
                          color: Color(0xFFD97706),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          store['rating'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class WhyTrinisLoveSection extends StatelessWidget {
  const WhyTrinisLoveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 64),
        Text(
          'Why Trinis Love Gyanacentral',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Simple, free, and built for Trinidad & Tobago',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            Expanded(
              child: _BenefitCard(
                title: '100% Free',
                description:
                    'Post unlimited ads at no cost. No hidden fees, no premium plans — just free classifieds.',
                icon: Icons.shield_outlined,
                color: const Color(0xFF16A34A),
                bgColor: const Color(0xFFF0FDF4),
                borderColor: const Color(0xFFDCFCE7),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _BenefitCard(
                title: 'Fast Results',
                description:
                    'Post an ad in under 60 seconds. Get calls from buyers the same day you list.',
                icon: Icons.trending_up,
                color: const Color(0xFFDC2626),
                bgColor: const Color(0xFFFEF2F2),
                borderColor: const Color(0xFFFEE2E2),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _BenefitCard(
                title: 'Made for T&T',
                description:
                    'Built for locals — browse by parish, connect with nearby sellers, and deal in TTD.',
                icon: Icons.location_on_outlined,
                color: const Color(0xFFD97706),
                bgColor: const Color(0xFFFFFBEB),
                borderColor: const Color(0xFFFEF3C7),
              ),
            ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.1) : bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? color.withOpacity(0.25) : borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6B7280),
              height: 1.6,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
