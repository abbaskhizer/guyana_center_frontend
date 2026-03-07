import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/store_controller.dart';
import 'package:guyana_center_frontend/modal/storeVm.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';
import 'package:guyana_center_frontend/widgets/app_drawar.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:guyana_center_frontend/widgets/web_header.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(StoresController());
    final theme = Theme.of(context);
    final isWeb = _isWebDesktop(context);

    return Scaffold(
      bottomNavigationBar: isWeb ? null : CustomBottomNavBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isWeb ? null : const AppDrawer(),
      body: SafeArea(
        child: isWeb
            ? _WebStoreShell(controller: c)
            : _MobileShell(controller: c),
      ),
    );
  }
}

class _MobileShell extends StatelessWidget {
  final StoresController controller;
  const _MobileShell({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = controller;

    return ListView(
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
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => StoreTile(store: c.visibleStores[i]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WebStoreShell extends StatelessWidget {
  final StoresController controller;
  const _WebStoreShell({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WebHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _WebStoreContent(controller: controller),
                const WebFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WebStoreContent extends StatelessWidget {
  final StoresController controller;
  const _WebStoreContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;
    final bgColor = isDark
        ? theme.scaffoldBackgroundColor
        : const Color(0xFFFAFAFA);

    return Container(
      width: double.infinity,
      color: bgColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WebSearchBar(controller: controller),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Guyanacentral stores",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: isDark ? cs.onSurface : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        "Open new store",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _WebFilters(controller: controller),
                const SizedBox(height: 24),
                Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.visibleStores.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 0),
                    itemBuilder: (_, i) =>
                        _WebStoreCard(store: controller.visibleStores[i]),
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WebSearchBar extends StatelessWidget {
  final StoresController controller;
  const _WebSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? cs.outlineVariant : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search,
            color: isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller.searchCtrl,
              onChanged: controller.onSearchChanged,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? cs.onSurface : const Color(0xFF111827),
              ),
              decoration: InputDecoration(
                hintText: "Search stores...",
                hintStyle: TextStyle(
                  color: isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                filled: false,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search, size: 18),
                label: const Text(
                  "Search",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebFilters extends StatelessWidget {
  final StoresController controller;
  const _WebFilters({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedKey = controller.selectedFilter.value;
      return Wrap(
        spacing: 24,
        runSpacing: 16,
        children: controller.filters.map((f) {
          final isSelected = selectedKey == f.key;
          return InkWell(
            onTap: () => controller.setFilter(f.key),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: f.label,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF16A34A).withOpacity(0.8),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  if (f.count != null)
                    TextSpan(
                      text: " ${f.count}",
                      style: TextStyle(
                        color: const Color(0xFF86EFAC),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _WebStoreCard extends StatelessWidget {
  final StoreVM store;
  const _WebStoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    final bgColor = isDark ? cs.surface : Colors.white;
    final borderColor = isDark ? cs.outlineVariant : const Color(0xFFF3F4F6);

    return Container(
      padding: const EdgeInsets.all(28),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              store.avatarUrl,
              width: 170,
              height: 170,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        store.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? cs.onSurface
                              : const Color(0xFF111827),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (store.verified)
                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF16A34A),
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  store.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.7,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? cs.onSurfaceVariant
                        : const Color(0xFF6B7280),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: isDark
                          ? cs.onSurfaceVariant
                          : const Color(0xFF9CA3AF),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      store.location,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? cs.onSurfaceVariant
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Icon(
                      Icons.insert_drive_file,
                      color: Color(0xFF16A34A),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      store.ads.isNotEmpty ? store.ads : "0 ads",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// Mobile components retained below
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
          color: active ? cs.primary.withOpacity(0.10) : cs.background,
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
        color: cs.background,
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
