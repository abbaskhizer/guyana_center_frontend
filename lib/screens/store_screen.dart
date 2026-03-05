import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/store_controller.dart';
import 'package:guyana_center_frontend/main.dart';
import 'package:guyana_center_frontend/modal/storeVm.dart';

import 'package:guyana_center_frontend/widgets/app_drawar.dart';
import 'package:guyana_center_frontend/widgets/mobile_top_bar.dart';
import 'package:guyana_center_frontend/widgets/profile_dot.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(StoresController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          children: [
            _TopBar(controller: c),
            const SizedBox(height: 14),

            _SearchRow(controller: c),
            const SizedBox(height: 18),

            _HeaderRow(controller: c),
            const SizedBox(height: 14),

            Obx(
              () => _FiltersWrap(
                controller: c,
                selectedKey: c.selectedFilter.value,
              ),
            ),
            const SizedBox(height: 16),

            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: c.visibleStores.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => StoreTile(store: c.visibleStores[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final StoresController controller;
  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Builder(
          builder: (ctx) => InkWell(
            onTap: () => Scaffold.of(ctx).openDrawer(),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.menu_rounded, color: cs.onSurface, size: 22),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(child: GuyanaCentralLogo()),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_none_rounded, color: cs.onSurface),
        ),
        const SizedBox(width: 4),
        ProfileDot(onTap: () {}),
      ],
    );
  }
}

class _SearchRow extends StatelessWidget {
  final StoresController controller;
  const _SearchRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.searchCtrl,
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: "Search stores...",
              prefixIcon: const Icon(Icons.search_rounded),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Search",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: cs.onPrimary,
              ),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Stores",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            color: cs.onSurface,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text("Open new store"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            shape: const StadiumBorder(),
            elevation: 0,
          ),
        ),
      ],
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
      runSpacing: 10,
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Show all",
            style: TextStyle(fontWeight: FontWeight.w800, color: cs.primary),
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? cs.primary.withOpacity(0.1) : cs.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? cs.primary : cs.outlineVariant.withOpacity(0.5),
            width: active ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? cs.primary : cs.onSurface.withOpacity(0.8),
              ),
            ),
            if (count != null)
              Text(
                " $count",
                style: TextStyle(
                  fontSize: 11,
                  color: active
                      ? cs.primary.withOpacity(0.6)
                      : cs.onSurface.withOpacity(0.3),
                ),
              ),
          ],
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              store.avatarUrl,
              width: 75,
              height: 75,
              fit: BoxFit.cover,
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
                      store.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface, // Theme-aware
                      ),
                    ),
                    const SizedBox(width: 20),
                    if (store.verified)
                      Icon(
                        Icons.check_circle_outline_outlined,
                        size: 16,
                        color: cs.primary,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  store.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.55),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: cs.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      store.location,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.description_outlined,
                      size: 14,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      store.ads,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.primary, // Using your kPrimaryColor
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: cs.onSurface.withOpacity(0.2)),
        ],
      ),
    );
  }
}
