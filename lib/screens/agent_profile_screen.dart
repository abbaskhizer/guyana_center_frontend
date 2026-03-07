import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/agent_profile_controller.dart';
import 'package:guyana_center_frontend/main.dart';
import 'package:guyana_center_frontend/modal/agent_listing.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';

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
      bottomNavigationBar: isWeb ? null : CustomBottomNavBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
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
    return Column(
      children: [
        const WebHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _WebProfileContent(controller: controller),
                const WebFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WebProfileContent extends StatelessWidget {
  final AgentProfileController controller;
  const _WebProfileContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WebHeaderBlock(controller: controller),
              const SizedBox(height: 48),
              const _WebStatsRow(),
              const SizedBox(height: 48),
              _WebTabsBlock(controller: controller),
              const SizedBox(height: 24),
              const _WebListingsController(),
              const SizedBox(height: 24),
              _WebListingsGrid(controller: controller),
              const SizedBox(height: 48),
              Center(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(
                      color: isDark
                          ? cs.outlineVariant
                          : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    "Load More Listings",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isDark ? cs.onSurface : const Color(0xFF4B5563),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebHeaderBlock extends StatelessWidget {
  final AgentProfileController controller;
  const _WebHeaderBlock({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;
    final textCol = isDark ? cs.onSurface : const Color(0xFF111827);
    final subTextCol = isDark ? cs.onSurfaceVariant : const Color(0xFF6B7280);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF169038).withOpacity(0.2)
                    : const Color(0xFFEAF5EF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  "R",
                  style: TextStyle(
                    color: Color(0xFF169038),
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isDark ? cs.surface : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF169038),
                  size: 22,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Rachel Morrison",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: textCol,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF169038).withOpacity(0.1)
                          : const Color(0xFFEAF5EF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF169038).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF169038),
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Verified Agent",
                          style: TextStyle(
                            color: Color(0xFF169038),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Licensed Real Estate Agent · DRE #01945832",
                style: TextStyle(
                  color: subTextCol,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: subTextCol),
                  const SizedBox(width: 6),
                  Text(
                    "Los Angeles, CA",
                    style: TextStyle(
                      color: subTextCol,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: subTextCol,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Member since Aug 2019",
                    style: TextStyle(
                      color: subTextCol,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Icon(Icons.access_time_outlined, size: 16, color: subTextCol),
                  const SizedBox(width: 6),
                  Text(
                    "Responds in ~2hrs",
                    style: TextStyle(
                      color: subTextCol,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (_) => const Icon(
                        Icons.star_border,
                        color: Color(0xFFFBAF16),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "4.9",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: textCol,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "(127 reviews)",
                    style: TextStyle(
                      color: subTextCol,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF169038),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(200, 48),
              ),
              child: const Text(
                "Follow Agent",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text(
                "Message",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF169038),
                side: const BorderSide(color: Color(0xFF169038), width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(200, 48),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.phone_outlined, size: 18),
              label: const Text(
                "(310) 555-0147",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark
                    ? cs.onSurface
                    : const Color(0xFF4B5563),
                side: BorderSide(
                  color: isDark ? cs.outlineVariant : const Color(0xFFD1D5DB),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(200, 48),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WebStatsRow extends StatelessWidget {
  const _WebStatsRow();

  Widget _stat(String top, String bottom, {Color? color}) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cs = Theme.of(context).colorScheme;
        final defaultColor = isDark ? cs.onSurface : const Color(0xFF111827);
        final defaultBottomColor = isDark
            ? cs.onSurfaceVariant
            : const Color(0xFF9CA3AF);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              top,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: color ?? defaultColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bottom,
              style: TextStyle(
                fontSize: 13,
                color: defaultBottomColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark
        ? Theme.of(context).colorScheme.outlineVariant
        : const Color(0xFFF3F4F6);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _stat("24", "Active Listings"),
        Container(height: 48, width: 1, color: dividerColor),
        _stat("127", "Reviews"),
        Container(height: 48, width: 1, color: dividerColor),
        _stat("89", "Properties Sold"),
        Container(height: 48, width: 1, color: dividerColor),
        _stat("98%", "Response Rate", color: const Color(0xFF169038)),
        Container(height: 48, width: 1, color: dividerColor),
        _stat("\$42M+", "Total Sales Volume"),
      ],
    );
  }
}

class _WebTabsBlock extends StatelessWidget {
  final AgentProfileController controller;
  const _WebTabsBlock({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 2,
            color: isDark
                ? Theme.of(context).colorScheme.outlineVariant
                : const Color(0xFFF3F4F6),
          ),
        ),
        Obx(() {
          return Row(
            children: [
              _WebTabItem(
                text: "Active Listings",
                count: "24",
                active: controller.tabIndex.value == 0,
                icon: Icons.view_in_ar_outlined,
                onTap: () => controller.tabIndex.value = 0,
              ),
              const SizedBox(width: 32),
              _WebTabItem(
                text: "Reviews",
                count: "127",
                active: controller.tabIndex.value == 1,
                icon: Icons.chat_bubble_outline,
                onTap: () => controller.tabIndex.value = 1,
              ),
              const SizedBox(width: 32),
              _WebTabItem(
                text: "About",
                active: controller.tabIndex.value == 2,
                icon: Icons.person_outline,
                onTap: () => controller.tabIndex.value = 2,
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _WebTabItem extends StatelessWidget {
  final String text;
  final String? count;
  final bool active;
  final IconData icon;
  final VoidCallback onTap;

  const _WebTabItem({
    required this.text,
    this.count,
    required this.active,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final inactiveText = isDark ? cs.onSurfaceVariant : const Color(0xFF6B7280);
    final inactiveIcon = isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF);
    final activeColor = const Color(0xFF169038);

    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: active ? activeColor : inactiveIcon,
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    color: active ? activeColor : inactiveText,
                    fontSize: 14,
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? activeColor.withOpacity(0.1)
                          : (isDark
                                ? cs.surfaceVariant
                                : const Color(0xFFF3F4F6)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      count!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: active ? activeColor : inactiveText,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            height: 3,
            width: text.length * 9.0 + (count != null ? 30 : 0),
            decoration: BoxDecoration(
              color: active ? activeColor : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebListingsController extends StatelessWidget {
  const _WebListingsController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final textCol = isDark ? cs.onSurface : const Color(0xFF111827);
    final subCol = isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Showing 6 of 24 listings",
          style: TextStyle(
            color: subCol,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Text(
              "Sort by: ",
              style: TextStyle(
                color: subCol,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Most Recent",
              style: TextStyle(
                color: textCol,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WebListingsGrid extends StatelessWidget {
  final AgentProfileController controller;
  const _WebListingsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    final listings = [
      {
        "title": "Greenwood Estate, 4 BHK Villa",
        "price": "\$1,450,000",
        "tag": "For Sale",
        "beds": "4",
        "baths": "3",
        "sqft": "3,200 sqft",
        "time": "23d",
        "views": "284",
        "location": "Los Angeles, CA",
        "img":
            "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      },
      {
        "title": "Sunrise Penthouse, 3 BHK",
        "price": "\$2,800/mo",
        "tag": "For Rent",
        "beds": "3",
        "baths": "2",
        "sqft": "1,850 sqft",
        "time": "5d",
        "views": "156",
        "location": "Santa Monica, CA",
        "img":
            "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      },
      {
        "title": "Hillcrest Cottage",
        "price": "\$725,000",
        "tag": "For Sale",
        "beds": "3",
        "baths": "2",
        "sqft": "1,600 sqft",
        "time": "12d",
        "views": "412",
        "location": "Pasadena, CA",
        "img":
            "https://images.unsplash.com/photo-1510798831971-661eb04b3739?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      },
      {
        "title": "Downtown Loft Studio",
        "price": "\$1,950/mo",
        "tag": "For Rent",
        "beds": "1",
        "baths": "1",
        "sqft": "780 sqft",
        "time": "2d",
        "views": "89",
        "location": "DTLA, CA",
        "img":
            "https://images.unsplash.com/photo-1493809842364-78817add7ffb?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      },
      {
        "title": "Oceanview Residential Land",
        "price": "\$890,000",
        "tag": "Land",
        "beds": "-",
        "baths": "-",
        "sqft": "5,000 sqft lot",
        "time": "31d",
        "views": "203",
        "location": "Malibu, CA",
        "img":
            "https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      },
      {
        "title": "Willow Park Family Home",
        "price": "\$980,000",
        "tag": "For Sale",
        "beds": "4",
        "baths": "3",
        "sqft": "2,700 sqft",
        "time": "8d",
        "views": "167",
        "location": "Glendale, CA",
        "img":
            "https://images.unsplash.com/photo-1513584684374-8bab748fbf90?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        return _WebListingCard(data: listings[index]);
      },
    );
  }
}

class _WebListingCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _WebListingCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final bgColor = isDark ? cs.surface : Colors.white;
    final borderColor = isDark ? cs.outlineVariant : const Color(0xFFF3F4F6);
    final titleColor = isDark ? cs.onSurface : const Color(0xFF111827);
    final subTextCol = isDark ? cs.onSurfaceVariant : const Color(0xFF6B7280);
    final iconColor = isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 12,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(data['img'], fit: BoxFit.cover),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data['tag'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data['views'],
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
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['price'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        data['time'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: iconColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data['title'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: iconColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data['location'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: subTextCol,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 1,
                    color: borderColor,
                    margin: const EdgeInsets.only(bottom: 10),
                  ),
                  Row(
                    children: [
                      Icon(Icons.bed_outlined, size: 16, color: iconColor),
                      const SizedBox(width: 6),
                      Text(
                        data['beds'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: subTextCol,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.bathtub_outlined, size: 16, color: iconColor),
                      const SizedBox(width: 6),
                      Text(
                        data['baths'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: subTextCol,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.square_foot_outlined,
                        size: 16,
                        color: iconColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        data['sqft'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: subTextCol,
                        ),
                      ),
                    ],
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
