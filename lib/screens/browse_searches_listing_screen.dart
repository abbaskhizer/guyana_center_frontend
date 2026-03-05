import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';

class BrowseSearchesListingScreen extends StatelessWidget {
  const BrowseSearchesListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Favorite Searches",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  Icon(Icons.more_horiz_rounded, color: cs.onSurface),
                ],
              ),
            ),

            // chips row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _Mini(text: "All", active: true),
                  const SizedBox(width: 10),
                  _Mini(text: "Vehicles"),
                  const SizedBox(width: 10),
                  _Mini(text: "Electronics"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: const [
                  _SavedSearchCard(
                    title: "Toyota Corolla 2020",
                    meta: "Vehicles • Central",
                  ),
                  SizedBox(height: 10),
                  _SavedSearchCard(
                    title: "MacBook Pro M2",
                    meta: "Electronics • Port of Spain",
                  ),
                  SizedBox(height: 10),
                  _SavedSearchCard(
                    title: "Studio Apartment",
                    meta: "Real estate • San Fernando",
                  ),
                  SizedBox(height: 10),
                  _SavedSearchCard(
                    title: "Jobs - Marketing",
                    meta: "Jobs • Georgetown",
                  ),
                ],
              ),
            ),

            // bottom action bar like screenshot
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: cs.onSurface.withOpacity(.45),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Find more deals",
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface.withOpacity(.55),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        elevation: 0,
                      ),
                      child: const Text("Search"),
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

class _Mini extends StatelessWidget {
  final String text;
  final bool active;
  const _Mini({required this.text, this.active = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? cs.primary.withOpacity(.10) : cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: active ? cs.primary : cs.outlineVariant),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 12,
          color: active ? cs.primary : cs.onSurface.withOpacity(.65),
        ),
      ),
    );
  }
}

class _SavedSearchCard extends StatelessWidget {
  final String title;
  final String meta;

  const _SavedSearchCard({required this.title, required this.meta});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withOpacity(.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border_rounded,
              color: cs.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withOpacity(.55),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text("View"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          side: BorderSide(color: cs.outlineVariant),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          "Remove",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface.withOpacity(.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: cs.outlineVariant),
        ],
      ),
    );
  }
}
