import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/listing_detail_controller.dart';
import 'package:guyana_center_frontend/screens/agent_profile_screen.dart';
import 'package:guyana_center_frontend/widgets/guyana_central_logo.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ListingDetailController());
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // bottomNavigationBar: _BottomNavBarFigma(activeIndex: 2),
      body: SafeArea(
        child: Obx(() {
          final item = c.item;
          final idx = c.currentImage.value;

          // ✅ DEMO section (later bind from API/model)
          final highlights = <String>[
            "Fully serviced with soft close doors",
            "27 inch rims dry, slightly lowered",
            "Can be sold with or without music system",
          ];

          final musicSystemIncludes = <String>[
            "12\" Hifonics subwoofers (x2) + 15\" EVs (2) housed box",
            "2K TPL 4-channel amps Class D",
            "TBC proline Power Cable + Apple 3 aluminium insert amp",
            "TBC proline DSP + 4x4 Midway",
          ];

          final batterySystem = <String>[
            "1 Headunit (Pioneer 7600) Class D + Blockbake V15SE",
            "2x HJ Power SP120 + 2x Shakard Safeway 0/1W",
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== Top bar ======
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
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
                        icon: Icon(Icons.search_rounded, color: cs.onSurface),
                      ),
                      const SizedBox(width: 4),
                      ProfileDot(
                        onTap: () {
                          Get.to(AgentProfileScreen());
                        },
                      ),
                    ],
                  ),
                ),

                // ====== Breadcrumb ======
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Row(
                    children: [
                      Text(
                        "VEHICLES  >  ",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(.45),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ====== Main image ======
                Stack(
                  children: [
                    SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: Image.network(
                        item.gallery[idx],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: cs.surfaceVariant,
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
                          onTap: c.prev,
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 106,
                        child: _ArrowCircle(
                          icon: Icons.chevron_right_rounded,
                          onTap: c.next,
                        ),
                      ),
                    ],

                    // ✅ Fav button (GetX)
                    Positioned(
                      right: 14,
                      top: 14,
                      child: Obx(() {
                        final fav = c.isFav.value;
                        return Material(
                          color: Colors.white.withOpacity(.92),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: c.toggleFav,
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
                ),

                const SizedBox(height: 10),

                // ====== Thumbnails ======
                SizedBox(
                  height: 66,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: item.gallery.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final active = i == idx;
                      return InkWell(
                        onTap: () => c.setImage(i),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 78,
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
                                color: cs.surfaceVariant,
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
                ),

                const SizedBox(height: 14),

                // ====== Title + meta ======
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
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
                        "Posted 2 days ago",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const _MiniTag(text: "ID 87"),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ====== Price + negotiable ======
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item.price,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item.condition,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(.55),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ====== note ======
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "WITH music system\n\$150,000 without music system",
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.35,
                      color: cs.onSurface.withOpacity(.62),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ====== specs ======
                Padding(
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
                ),

                const SizedBox(height: 14),

                // ====== price again + buttons ======
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item.price,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item.condition,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(.55),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call),
                          label: const Text("Show Phone Number"),
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
                          label: const Text("Send Message"),
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
                ),

                const SizedBox(height: 12),

                // ====== Seller ======
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 18, child: Text("M")),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Marissa Mahraj",
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
                                    "4.9  •  15 reviews",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.onSurface.withOpacity(.6),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "View All Ads by Seller",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ====== Safety tips ======
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
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
                          "Safety Tips",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _bullet(theme, cs, "Meet in a safe, public location"),
                        _bullet(theme, cs, "Inspect item before payment"),
                        _bullet(theme, cs, "Never send money in advance"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ✅✅✅ FIGMA DESCRIPTION AREA (like your screenshot)
                const _SectionTitle(title: "Description"),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    item.description.isEmpty
                        ? "Toyota Hiace Super GL, Gas, Not heavy T, inspected and ready for immediate transfer."
                        : item.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.55,
                      color: cs.onSurface.withOpacity(.75),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: highlights
                        .map((e) => _GreenBullet(text: e))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 12),
                const _SubTitle(title: "Music System Includes:"),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: musicSystemIncludes
                        .map((e) => _GreyBullet(text: e))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 12),
                const _SubTitle(title: "Battery System:"),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: batterySystem
                        .map((e) => _GreyBullet(text: e))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 14),

                const _SectionTitle(title: "Location: Cunupia"),
                const SizedBox(height: 10),

                // map card (with border like figma)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 170,
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
                              "https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=1200",
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: cs.surfaceVariant,
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
                  ),
                ),

                const SizedBox(height: 16),

                // ====== Similar ads ======
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Similar Ads",
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        "See all",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 210, // ✅ fixed to avoid overflow
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => _SimilarCard(
                      imageUrl: item.gallery[i % item.gallery.length],
                      title: "Toyota Van 2016",
                      price: "\$210,000",
                      location: "Port of Spain",
                    ),
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          );
        }),
      ),
    );
  }

  static Widget _bullet(ThemeData theme, ColorScheme cs, String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•  ",
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface.withOpacity(.7),
            ),
          ),
          Expanded(
            child: Text(
              t,
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

// ==================== EXTRA FIGMA WIDGETS ====================

class _SubTitle extends StatelessWidget {
  final String title;
  const _SubTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: cs.onSurface,
        ),
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

// ==================== YOUR EXISTING SMALL WIDGETS ====================

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: cs.onSurface,
        ),
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

  const _SimilarCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              imageUrl,
              height: 105,
              width: 170,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 105,
                color: cs.surfaceVariant,
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
                  price,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(height: 4),
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

/// Bottom nav (simple figma-like)
