import 'package:flutter/material.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/home_tab_controller.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';

class WebCategoriesGrid extends StatelessWidget {
  final HomeTabController controller;
  const WebCategoriesGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get all categories (excluding "All") and take first 12
    final allCategories = controller.allCategoriesForScreen.take(12).toList();

    return Column(
      children: [
        // First row (6 items)
        Row(
          children: List.generate(6, (index) {
            if (index >= allCategories.length) {
              return const Expanded(child: SizedBox());
            }
            final item = allCategories[index];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 5 ? 12 : 0),
                child: _WebCategoryCard(item: item),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        // Second row (6 items)
        Row(
          children: List.generate(6, (index) {
            final secondIndex = index + 6;
            if (secondIndex >= allCategories.length) {
              return const Expanded(child: SizedBox());
            }
            final item = allCategories[secondIndex];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 5 ? 12 : 0),
                child: _WebCategoryCard(item: item),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _WebCategoryCard extends StatelessWidget {
  final BrowseCategoryVM item;
  const _WebCategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.tint.withOpacity(isDark ? 0.2 : 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              item.assetImage ?? "assets/vehicle.png",
              fit: BoxFit.contain,
              width: 28,
              height: 28,
              errorBuilder: (_, _, _) => Icon(
                Icons.broken_image_outlined,
                color: cs.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "12,400+ ads",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.55),
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
