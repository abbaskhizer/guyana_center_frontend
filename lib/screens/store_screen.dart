import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/store_controller.dart';
import 'package:guyana_center_frontend/modal/storeVm.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(StoresController());
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              child: Column(
                children: [
                  MobileHeader(),
                  const SizedBox(height: 14),
                  _SearchRow(controller: c),
                  const SizedBox(height: 18),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: double.infinity,

              color: theme.colorScheme.surface,
              child: Column(
                children: [
                  _HeaderRow(controller: c),
                  const SizedBox(height: 12),
                  Obx(
                    () => _FiltersWrap(
                      controller: c,
                      selectedKey: c.selectedFilter.value,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: c.visibleStores.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          StoreTile(store: c.visibleStores[i]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  final StoresController controller;
  const _SearchRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
              controller: controller.searchCtrl,
              onChanged: controller.onSearchChanged,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.5,
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Search stores...",
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  color: cs.onSurface.withOpacity(0.35),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: cs.onSurface.withOpacity(0.35),
                ),
                filled: true,
                fillColor: cs.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: cs.outlineVariant.withOpacity(0.8),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: cs.primary, width: 1.2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Search",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final StoresController controller;
  const _HeaderRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Stores",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 34,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 14),
              label: const Text(
                "Open new store",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: const StadiumBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltersWrap extends StatelessWidget {
  final StoresController controller;
  final String selectedKey;

  const _FiltersWrap({required this.controller, required this.selectedKey});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...controller.filters.map(
          (f) => ChipPill(
            text: f.label,
            count: f.count,
            active: selectedKey == f.key,
            onTap: () => controller.setFilter(f.key),
          ),
        ),
        TextButton(
          onPressed: () => controller.setFilter(StoresController.filterAll),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Show all",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: cs.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class ChipPill extends StatelessWidget {
  final String text;
  final int? count;
  final bool active;
  final VoidCallback onTap;

  const ChipPill({
    super.key,
    required this.text,
    this.count,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? cs.primary.withOpacity(0.10) : cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active
                ? cs.primary.withOpacity(0.30)
                : cs.outlineVariant.withOpacity(0.45),
            width: 1,
          ),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: text,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                  color: active ? cs.primary : cs.primary.withOpacity(0.72),
                ),
              ),
              if (count != null)
                TextSpan(
                  text: count.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: active
                        ? cs.primary.withOpacity(0.65)
                        : cs.onSurface.withOpacity(0.35),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreTile extends StatelessWidget {
  final StoreVM store;
  const StoreTile({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              store.avatarUrl,
              width: 74,
              height: 74,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          store.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      if (store.verified)
                        Icon(
                          Icons.verified_outlined,
                          size: 16,
                          color: cs.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    store.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(0.42),
                      height: 1.45,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: cs.onSurface.withOpacity(0.32),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        store.location,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.48),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Image.asset('assets/fuel.png', height: 12, width: 12),
                      const SizedBox(width: 4),
                      Text(
                        store.ads,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: cs.onSurface.withOpacity(0.18),
            ),
          ),
        ],
      ),
    );
  }
}
