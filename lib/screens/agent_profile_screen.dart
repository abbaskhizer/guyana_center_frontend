import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/agent_profile_controller.dart';
import 'package:guyana_center_frontend/main.dart';
import 'package:guyana_center_frontend/modal/listingVM.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
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
      backgroundColor: isWeb
          ? theme.colorScheme.surface
          : theme.scaffoldBackgroundColor,
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

    return Obx(() {
      if (controller.isLoading.value && controller.listings.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        padding: const EdgeInsets.only(top: 10, bottom: 18),
        children: content.children(context),
      );
    });
  }
}

class _WebShell extends StatelessWidget {
  final AgentProfileController controller;
  const _WebShell({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final content = _AgentProfileContent(controller: controller, web: true);

    return Obx(() {
      if (controller.isLoading.value && controller.listings.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: theme.colorScheme.surface,
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
    });
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _TopBarMobile(controller: controller),
        )
      else
        _TopBarWeb(controller: controller),
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
              /* 
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _ActiveListingsHeader(web: false),
              ), 
              */
              const SizedBox(height: 10),
              Obx(() => Column(
                children: controller.listings.where((l) => l.status == 'active').map(
                  (x) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: _AgentListingCard(item: x, controller: controller),
                  ),
                ).toList(),
              )),
              if (controller.listings.where((l) => l.status == 'active').isEmpty && !controller.isLoading.value)
                 const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: Text("No active ads posted yet")),
                ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ] else ...[
        wrapWebCard(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ActiveListingsHeader(web: true, controller: controller),
              const SizedBox(height: 14),
              Obx(() => Column(
                children: controller.listings.map(
                  (x) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _AgentListingCard(item: x, controller: controller),
                  ),
                ).toList(),
              )),
              if (controller.listings.isEmpty && !controller.isLoading.value)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: Text("No ads posted yet")),
                ),
              const SizedBox(height: 6),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    ];
  }
}

class _TopBarMobile extends StatelessWidget {
  final AgentProfileController controller;
  const _TopBarMobile({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
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
            child: Obx(() => Text(
              controller.isOwnProfile.value ? "My Ad Dashboard" : "Seller Profile",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
              ),
            )),
          ),
        ),
        InkWell(
          onTap: () {
            // TODO: Implement actual share logic
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.share_outlined,
              color: cs.onSurface,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBarWeb extends StatelessWidget {
  final AgentProfileController controller;
  const _TopBarWeb({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
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
        Obx(() => Text(
          controller.isOwnProfile.value ? "My Dashboard" : "Seller Profile",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        )),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.share_outlined, size: 18, color: cs.onSurface),
          label: Text(
            "Share Profile",
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
    final dividerColor = theme.dividerTheme.color ?? cs.outlineVariant;
    final auth = AuthService.to;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final photoUrl = controller.sellerUser.value?.photoUrl ?? AuthService.to.userPhotoUrl.value;
              String? fullPhotoUrl;
              if (photoUrl != null && photoUrl.isNotEmpty) {
                if (photoUrl.startsWith('http')) {
                  fullPhotoUrl = photoUrl;
                } else {
                  fullPhotoUrl = 'http://185.197.194.139$photoUrl';
                }
              }
              if (fullPhotoUrl != null && fullPhotoUrl.isNotEmpty) {
                return CircleAvatar(
                  radius: web ? 34 : 30,
                  backgroundColor: cs.primary.withOpacity(.12),
                  backgroundImage: NetworkImage(fullPhotoUrl),
                  onBackgroundImageError: (_, __) {},
                );
              }
              return CircleAvatar(
                radius: web ? 34 : 30,
                backgroundColor: cs.primary.withOpacity(.12),
                child: Text(
                  (controller.sellerUser.value?.name ?? AuthService.to.userName.value ?? "U")[0].toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                  ),
                ),
              );
            }),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(() => Text(
                        controller.sellerUser.value?.name ?? "User",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: web ? 16 : 15,
                          color: cs.onSurface,
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Obx(() => Text(
                    controller.sellerUser.value?.email ?? "No email available",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withOpacity(.55),
                    ),
                  )),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant.withOpacity(.55)),
          ),
          child: Obx(() => Row(
            children: [
              Expanded(
                child: _StatPill(top: "${controller.listings.where((l) => l.status == 'active').length}", bottom: "Listings"),
              ),
              Expanded(
                child: _StatPill(top: "${controller.soldCount}", bottom: "Sold"),
              ),
              if (controller.isOwnProfile.value) ...[
                const _VLine(),
                Expanded(
                  child: _StatPill(top: "\$${controller.earnings.toStringAsFixed(0)}", bottom: "Earnings"),
                ),
              ],
            ],
          )),
        ),
        const SizedBox.shrink(),
// Tabs removed for cleaner view
/*
        Obx(() {
          return Container(
...
*/
      ],
    );
  }
}

class _ActiveListingsHeader extends StatelessWidget {
  final bool web;
  final AgentProfileController controller;
  const _ActiveListingsHeader({required this.web, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Obx(() => Text(
            controller.isOwnProfile.value ? "My Active Listings" : "Active Listings",
            style:
                (web ? theme.textTheme.titleMedium : theme.textTheme.titleSmall)
                    ?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
          )),
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.cardColor,
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
            "Account Status",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_outlined,
                  size: 18,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Your profile is active and verified. You can post unlimited ads.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(.7),
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
    final auth = AuthService.to;

    return _WebCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Active Account",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.email_outlined,
            label: "Email",
            value: auth.userEmail.value ?? "N/A",
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.phone_android_rounded,
            label: "Phone",
            value: auth.userPhone.value ?? "Not set",
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
  final ListingVM item;
  final AgentProfileController controller;
  const _AgentListingCard({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isOwn = controller.isOwnProfile.value;

    return GestureDetector(
      onTap: isOwn ? null : () {
        Get.toNamed('/listing-detail', arguments: item);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  if (item.imageUrl.isNotEmpty)
                    Image.network(
                      item.imageUrl,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _PlaceholderImage(),
                    )
                  else
                    _PlaceholderImage(),
                  if (isOwn)
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: item.status == "active" ? const Color(0xFF10B981) : Colors.orange,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item.status.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.price,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      _CategoryBadge(cat: item.categoryId),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface.withOpacity(.65),
                    ),
                  ),
                  if (isOwn) ...[
                    const SizedBox(height: 14),
                    Divider(height: 1, color: cs.outlineVariant.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            onPressed: () => controller.markAsSold(item.id),
                            icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                            label: const Text("Sold"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF10B981),
                              side: const BorderSide(color: Color(0xFF10B981)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            onPressed: () => controller.editListing(item),
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            label: const Text("Update"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: cs.primary,
                              side: BorderSide(color: cs.primary.withOpacity(0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            onPressed: () => controller.deleteListing(item.id),
                            icon: const Icon(Icons.delete_outline_rounded, size: 16),
                            label: const Text("Delete"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String cat;
  const _CategoryBadge({required this.cat});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        cat.toUpperCase(),
        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.grey),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
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
                    color: active ? kPrimaryColor : cs.onSurfaceVariant,
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
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: cs.outlineVariant.withOpacity(.5),
                      ),
                    ),
                    child: Text(
                      count!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: active ? kPrimaryColor : cs.onSurfaceVariant,
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
