// agent_profile_screen.dart ✅ Figma-like (same as screenshot) + GetX + uses your Theme (kPrimaryColor etc.)
// NOTE: No bindings. Safe Get.put pattern included.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/agent_profile_controller.dart';
import 'package:guyana_center_frontend/main.dart';
import 'package:guyana_center_frontend/modal/agent_listing.dart';

class AgentProfileScreen extends StatelessWidget {
  const AgentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AgentProfileController c = Get.isRegistered<AgentProfileController>()
        ? Get.find<AgentProfileController>()
        : Get.put(AgentProfileController());

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          children: [
            // ===== Top row (back title + close) =====
            Row(
              children: [
                InkWell(
                  onTap: Get.back,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: cs.onSurface,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Center(
                    child: Text(
                      "Agent Profile",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.share_outlined),
                  color: cs.onSurface,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_horiz),
                  color: cs.onSurface,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ===== Profile header card =====
            Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: cs.primary.withOpacity(.12),
                      child: Text(
                        "R",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Rachel Morrison",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(width: 40),
                              Obx(() {
                                if (!c.isVerified.value) {
                                  return const SizedBox.shrink();
                                }
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: cs.primary),
                                  ),
                                  child: Text(
                                    "Verified Agent",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ===== License Text =====
                              Text(
                                "Licensed Real Estate Agent · DRE",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface.withOpacity(.55),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "#01945832",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface.withOpacity(.55),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // ===== Rating Row =====
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 5 Stars
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => const Padding(
                                        padding: EdgeInsets.only(right: 2),
                                        child: Icon(
                                          Icons.star_rounded,
                                          size: 14,
                                          color: Color(0xFFFFB020),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  // Rating Number
                                  Text(
                                    "4.9",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: cs.onSurface,
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  // Reviews
                                  Text(
                                    "(277 reviews)",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface.withOpacity(.55),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Call / Message
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.call_rounded, size: 18),
                        label: Text(
                          "Call",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
                        icon: Icon(Icons.message_outlined, color: cs.primary),
                        label: Text(
                          "Message",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: cs.primary,
                              ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(color: cs.outlineVariant),
                          foregroundColor: cs.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Stats row like screenshot
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        child: _StatPill(top: "24", bottom: "Listings"),
                      ),
                      _VLine(),
                      Expanded(
                        child: _StatPill(top: "89", bottom: "Sold"),
                      ),
                      _VLine(),
                      Expanded(
                        child: _StatPill(
                          top: "98%",
                          bottom: "Satisfaction",
                          topColor: Color(0xFF109E4B), // 👈 green highlight
                        ),
                      ),
                      _VLine(),
                      Expanded(
                        child: _StatPill(top: "\$42M+", bottom: "Sales"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Tabs (Listings active)
                Obx(() {
                  return Container(
                    // Bottom border for the whole tab bar
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                      ),
                    ),
                    child: SingleChildScrollView(
                      // Scrollable agar tabs zyada hon
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _TabItem(
                            text: "Listings",
                            count: "24",
                            active: c.tabIndex.value == 0,
                            onTap: () => c.tabIndex.value = 0,
                          ),
                          _TabItem(
                            text: "Reviews",
                            count: "127",
                            active: c.tabIndex.value == 1,
                            onTap: () => c.tabIndex.value = 1,
                          ),
                          _TabItem(
                            text: "Overview",
                            active: c.tabIndex.value == 2,
                            onTap: () => c.tabIndex.value = 2,
                          ),
                          _TabItem(
                            text: "About",
                            active: c.tabIndex.value == 3,
                            onTap: () => c.tabIndex.value = 3,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 14),

            // ===== Active Listings header =====
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Active Listings",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "See All",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ===== Cards =====
            ...c.listings.map(
              (x) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AgentListingCard(item: x),
              ),
            ),

            const SizedBox(height: 6),

            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: BorderSide(color: cs.outlineVariant),
              ),
              child: Text(
                "Load More Listings",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface.withOpacity(.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================== Widgets ===================

class _AgentListingCard extends StatelessWidget {
  final AgentListing item;
  const _AgentListingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bool forSale = item.tag.toLowerCase().contains("sale");

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  item.image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150,
                    color: cs.surfaceVariant,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),

                // Tag (For Sale / For Rent)
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: forSale ? cs.primary : const Color(0xFF2F6FED),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.tag,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ),

                // Heart icon
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.95),
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 18,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.price,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withOpacity(.65),
                  ),
                ),
                const SizedBox(height: 10),

                // bottom meta (like screenshot icons row)
                Row(
                  children: [
                    Icon(
                      Icons.bed_outlined,
                      size: 16,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "4",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface.withOpacity(.7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.bathtub_outlined,
                      size: 16,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "2",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface.withOpacity(.7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.square_foot_outlined,
                      size: 16,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "1,580 sqft",
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface.withOpacity(.7),
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

class _StatPill extends StatelessWidget {
  final String top;
  final String bottom;
  final Color? topColor; // 👈 optional

  const _StatPill({required this.top, required this.bottom, this.topColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          top,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: topColor ?? cs.onSurface, // 👈 default fallback
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bottom,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            color: cs.onSurface.withOpacity(.55),
          ),
        ),
      ],
    );
  }
}

class _VLine extends StatelessWidget {
  const _VLine();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: cs.outlineVariant,
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final String? count; // Badge ke liye
  final bool active;
  final VoidCallback onTap;

  const _TabItem({
    required this.text,
    this.count,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    color: active ? kPrimaryColor : const Color(0xFF9CA3AF),
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      // Active hone par light green background, varna light grey
                      color: active
                          ? kPrimaryColor.withOpacity(0.1)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      count!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: active ? kPrimaryColor : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Bottom Indicator Line
          Container(
            height: 3,
            width: 80, // Aap isse dynamic bhi kar sakte hain
            decoration: BoxDecoration(
              color: active ? kPrimaryColor : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
