import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/agent_profile_controller.dart';
import 'package:guyana_center_frontend/main.dart';
import 'package:guyana_center_frontend/modal/agent_listing.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class AgentProfileScreen extends StatelessWidget {
  const AgentProfileScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final AgentProfileController c = Get.isRegistered<AgentProfileController>()
        ? Get.find<AgentProfileController>()
        : Get.put(AgentProfileController());

    final isWeb = _isWebDesktop(context);
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      backgroundColor: isWeb ? Colors.white : theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: isWeb ? _WebShell(controller: c) : _MobileShell(controller: c),
      ),
    );
  }
}

class _MobileShell extends StatelessWidget {
  final AgentProfileController controller;
  const _MobileShell({required this.controller});

  @override
  Widget build(BuildContext context) {
    final content = _AgentProfileContent(controller: controller, web: false);

    return ListView(
      padding: const EdgeInsets.only(top: 10, bottom: 18),
      children: content.children(context),
    );
  }
}

class _WebShell extends StatelessWidget {
  final AgentProfileController controller;
  const _WebShell({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final content = _AgentProfileContent(controller: controller, web: true);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFFFAFAFA),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: content.children(context),
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          _WebSidebarContactCard(),
                          SizedBox(height: 14),
                          _WebSidebarQuickInfo(),
                        ],
                      ),
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
  }
}

class _AgentProfileContent {
  final AgentProfileController controller;
  final bool web;

  const _AgentProfileContent({required this.controller, required this.web});

  List<Widget> children(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget wrapWebCard(
      Widget child, {
      EdgeInsets padding = const EdgeInsets.fromLTRB(18, 16, 18, 18),
    }) {
      if (!web) return child;
      return _WebCard(padding: padding, child: child);
    }

    return [
      if (!web)
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TopBarMobile(),
        )
      else
        const _TopBarWeb(),
      SizedBox(height: web ? 14 : 12),

      if (!web)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _ProfileHeaderCard(controller: controller, web: false),
        )
      else
        wrapWebCard(_ProfileHeaderCard(controller: controller, web: true)),

      SizedBox(height: web ? 18 : 14),

      if (!web) ...[
        Container(
          width: double.infinity,
          color: cs.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _ActiveListingsHeader(web: false),
              ),
              const SizedBox(height: 10),
              ...controller.listings.map(
                (x) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _AgentListingCard(item: x),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(color: cs.outlineVariant),
                    ),
                    child: Text(
                      "Load More Listings",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface.withOpacity(.75),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ] else ...[
        wrapWebCard(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ActiveListingsHeader(web: true),
              const SizedBox(height: 14),
              ...controller.listings.map(
                (x) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _AgentListingCard(item: x),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: cs.outlineVariant),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                  child: Text(
                    "Load More Listings",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface.withOpacity(.75),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    ];
  }
}

class _TopBarMobile extends StatelessWidget {
  const _TopBarMobile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
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
          icon: const Icon(Icons.share_outlined),
          color: cs.onSurface,
          iconSize: 20,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
          color: cs.onSurface,
        ),
      ],
    );
  }
}

class _TopBarWeb extends StatelessWidget {
  const _TopBarWeb();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        InkWell(
          onTap: Get.back,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.chevron_left_rounded,
              color: cs.onSurface,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "Agent Profile",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.share_outlined, size: 18, color: cs.onSurface),
          label: Text(
            "Share",
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: cs.outlineVariant),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: cs.outlineVariant),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Icon(Icons.more_horiz, color: cs.onSurface),
        ),
      ],
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final AgentProfileController controller;
  final bool web;
  const _ProfileHeaderCard({required this.controller, required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: web ? 34 : 30,
              backgroundColor: cs.primary.withOpacity(.12),
              child: Text(
                "R",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Rachel Morrison",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: web ? 16 : 15,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Obx(() {
                        if (!controller.isVerified.value) {
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
                              fontSize: 9,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 6),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: Icon(
                              Icons.star_border_outlined,
                              size: 14,
                              color: Color(0xFFFFB020),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "4.9",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 6),
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
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call_rounded, size: 18),
                label: Text(
                  "Call",
                  style: theme.textTheme.bodyMedium?.copyWith(
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
                icon: Image.asset(
                  "assets/chat.png",
                  width: 18,
                  height: 18,
                  color: cs.primary,
                ),
                label: Text(
                  "Message",
                  style: theme.textTheme.bodyMedium?.copyWith(
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
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
                  topColor: Color(0xFF109E4B),
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
        Obx(() {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TabItem(
                    text: "Listings",
                    count: "24",
                    active: controller.tabIndex.value == 0,
                    onTap: () => controller.tabIndex.value = 0,
                  ),
                  _TabItem(
                    text: "Reviews",
                    count: "127",
                    active: controller.tabIndex.value == 1,
                    onTap: () => controller.tabIndex.value = 1,
                  ),
                  _TabItem(
                    text: "Overview",
                    active: controller.tabIndex.value == 2,
                    onTap: () => controller.tabIndex.value = 2,
                  ),
                  _TabItem(
                    text: "About",
                    active: controller.tabIndex.value == 3,
                    onTap: () => controller.tabIndex.value = 3,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ActiveListingsHeader extends StatelessWidget {
  final bool web;
  const _ActiveListingsHeader({required this.web});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            "Active Listings",
            style:
                (web ? theme.textTheme.titleMedium : theme.textTheme.titleSmall)
                    ?.copyWith(fontWeight: FontWeight.w900),
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
    );
  }
}

class _WebCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _WebCard({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 16, 18, 18),
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _WebSidebarContactCard extends StatelessWidget {
  const _WebSidebarContactCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return _WebCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Agent",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call_rounded, size: 18),
              label: Text(
                "Call",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: Image.asset(
                "assets/chat.png",
                width: 18,
                height: 18,
                color: cs.primary,
              ),
              label: Text(
                "Message",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: cs.outlineVariant),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_outlined,
                  size: 18,
                  color: Color(0xFF16A34A),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Verified agent profile (web-only info box).",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF475569),
                      fontWeight: FontWeight.w600,
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
}

class _WebSidebarQuickInfo extends StatelessWidget {
  const _WebSidebarQuickInfo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return _WebCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Info",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: "Location",
            value: "Los Angeles, CA",
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.badge_outlined,
            label: "License",
            value: "#01945832",
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.star_border_rounded,
            label: "Rating",
            value: "4.9 (277)",
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Text(
              "Add any extra web-only content here (tips, profile summary, etc.).",
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(.65),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: cs.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(.7),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _AgentListingCard extends StatelessWidget {
  final AgentListing item;
  const _AgentListingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bool forSale = item.tag.toLowerCase().contains("sale");

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.background,
        borderRadius: BorderRadius.circular(16),
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
  final Color? topColor;

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
            color: topColor ?? cs.onSurface,
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
  final String? count;
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          Container(
            height: 3,
            width: 80,
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
