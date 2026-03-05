import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:guyana_center_frontend/controller/bottomNavbar/browse_controller.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/widgets/mobile_top_bar.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';
import 'package:guyana_center_frontend/screens/listing_detail_screen.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrowseController(), permanent: true);

    return Scaffold(
      backgroundColor: _isWebDesktop(context)
          ? const Color(0xFFF8F8F8)
          : Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebLayout(controller: controller)
            : _MobileLayout(controller: controller),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final BrowseController controller;

  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        MobileTopBar(),
        const SizedBox(height: 12),
        BrowseSearchBar(controller: controller),
        const SizedBox(height: 12),
        BrowseFilters(controller: controller),
        const SizedBox(height: 12),
        BrowseResults(controller: controller),
      ],
    );
  }
}

class _WebLayout extends StatelessWidget {
  final BrowseController controller;

  const _WebLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 24, 40, 16),
            child: BrowseSearchBar(controller: controller),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrowseFilters(controller: controller),
                const SizedBox(height: 16),
                BrowseResults(controller: controller),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: WebFooter()),
      ],
    );
  }
}

class BrowseSearchBar extends StatelessWidget {
  final BrowseController controller;

  const BrowseSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final hasText = controller.searchText.value.isNotEmpty;

            return TextField(
              onChanged: controller.setSearch,
              decoration: InputDecoration(
                hintText: "Search listings...",
                prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
                suffixIcon: hasText
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: controller.clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: cs.surface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.primary),
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
          child: const Text(
            "Search",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class BrowseFilters extends StatelessWidget {
  final BrowseController controller;

  const BrowseFilters({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      return Row(
        children: [
          Row(
            children: List.generate(controller.chips.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => controller.setChip(i),
                  child: _Chip(
                    controller.chips[i],
                    controller.activeChip.value == i,
                  ),
                ),
              );
            }),
          ),
          const Spacer(),
          Icon(Icons.tune, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          const Text("Sort", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),

          GestureDetector(
            onTap: controller.toggleView,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: controller.isGrid.value
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.grid_view, size: 18),
            ),
          ),

          const SizedBox(width: 6),

          GestureDetector(
            onTap: controller.toggleView,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: !controller.isGrid.value
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.view_list, size: 18),
            ),
          ),
        ],
      );
    });
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active;

  const _Chip(this.label, this.active);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active ? cs.primary : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: active ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class BrowseResults extends StatelessWidget {
  final BrowseController controller;

  const BrowseResults({required this.controller});

  int _gridCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (!kIsWeb) return 2;
    if (width > 1300) return 4;
    if (width > 900) return 3;
    return 2;
  }

  double _cardHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (!kIsWeb) return 320; // mobile
    if (width > 1300) return 420; // large web
    if (width > 900) return 340; // medium web
    return 280; // small web
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final q = controller.searchText.value.trim();

      if (controller.showEmptyState) {
        return _EmptySearchState(
          query: q,
          onTryDifferent: controller.clearSearch,
          onBrowseAll: controller.clearSearch,
        );
      }

      return controller.isGrid.value
          ? GridView.builder(
              itemCount: controller.filtered.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridCount(context),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                mainAxisExtent: _cardHeight(context),
              ),
              itemBuilder: (_, i) {
                final item = controller.filtered[i];

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Get.to(() => const ListingDetailScreen(), arguments: item);
                  },
                  child: _ListingCard(item: item),
                );
              },
            )
          : ListView.builder(
              itemCount: controller.filtered.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) {
                final item = controller.filtered[i];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ListingCard(item: item),
                );
              },
            );
    });
  }
}

class _ListingCard extends StatelessWidget {
  final BrowseListingVM item;

  const _ListingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 11,
                  child: Image.network(item.imageUrl, fit: BoxFit.cover),
                ),
              ),

              if (item.featured)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kIsWeb ? const Color(0xFFF59E0B) : primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Featured",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          /// CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    item.price,
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
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

class _EmptySearchState extends StatelessWidget {
  final String query;
  final VoidCallback onTryDifferent;
  final VoidCallback onBrowseAll;

  const _EmptySearchState({
    required this.query,
    required this.onTryDifferent,
    required this.onBrowseAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          const Icon(Icons.search, size: 50, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No results for "$query"',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "Try adjusting your keywords or browse categories.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onTryDifferent,
                  child: const Text("Try Different Search"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onBrowseAll,
                  child: const Text("Browse All"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
