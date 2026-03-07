import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/favorites_controller.dart';
import 'package:guyana_center_frontend/modal/favItem.dart';
import 'package:guyana_center_frontend/widgets/app_drawar.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';
import 'package:guyana_center_frontend/screens/custom_bottom_navbar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<FavoritesController>()
        ? Get.find<FavoritesController>()
        : Get.put(FavoritesController());

    final theme = Theme.of(context);
    final isWeb = _isWebDesktop(context);

    return Scaffold(
      bottomNavigationBar: isWeb ? null : CustomBottomNavBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isWeb ? null : const AppDrawer(),
      body: SafeArea(
        child: isWeb ? _WebFavoritesShell(c: c) : _MobileFavoritesShell(c: c),
      ),
    );
  }
}

class _MobileFavoritesShell extends StatelessWidget {
  final FavoritesController c;
  const _MobileFavoritesShell({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
          child: MobileHeader(),
        ),
        _FavTabs(c: c),
        Expanded(
          child: PageView(
            controller: c.pageController,
            onPageChanged: c.onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: const [_EmptyFavoriteAds(), _EmptyFavoriteSearches()],
          ),
        ),
      ],
    );
  }
}

class _WebFavoritesShell extends StatelessWidget {
  final FavoritesController c;
  const _WebFavoritesShell({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WebHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        _FavTabs(c: c),
                        const SizedBox(height: 60),
                        Obx(
                          () => c.tab.value == FavTab.ads
                              ? const _EmptyFavoriteAds()
                              : const _EmptyFavoriteSearches(),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
                const WebFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FavTabs extends StatelessWidget {
  final FavoritesController c;
  const _FavTabs({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget tab(String text, FavTab t) {
      return InkWell(
        onTap: () => c.setTab(t),
        child: Obx(() {
          final active = c.tab.value == t;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: active ? cs.primary : const Color(0xFFE5E7EB),
                  width: active ? 2 : 1,
                ),
              ),
            ),
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? cs.primary : const Color(0xFFB0B7C3),
              ),
            ),
          );
        }),
      );
    }

    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(child: tab("Favorite ads", FavTab.ads)),
        Expanded(child: tab("Favorite searches", FavTab.searches)),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _EmptyFavoriteAds extends StatelessWidget {
  const _EmptyFavoriteAds();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final controller = Get.find<FavoritesController>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.08),
                shape: BoxShape.circle,
                border: Border.all(color: cs.primary.withOpacity(.10)),
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/favads.png', height: 30, width: 30),
            ),
            const SizedBox(height: 18),
            Text(
              "No Favorite ads yet",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: const Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "See your favorite ads here! Click on the star\nnext to each ad to save it for later.",
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.50,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: cs.onSurface.withOpacity(.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              width: 180,
              child: ElevatedButton(
                onPressed: controller.openBrowseAds,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Browse Listing",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: cs.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: cs.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavoriteSearches extends StatelessWidget {
  const _EmptyFavoriteSearches();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final controller = Get.put(FavoritesController());

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _FavoriteSearchIcon(),
            const SizedBox(height: 18),
            Text(
              "Be the first to see the new ads!",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: const Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "On the search results page, click the star\nicon next to the result count.\nSubscribe to category updates",
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.50,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: cs.onSurface.withOpacity(.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              width: 180,
              child: ElevatedButton(
                onPressed: controller.openBrowseSearches,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Browse Listing",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: cs.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: cs.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteSearchIcon extends StatelessWidget {
  const _FavoriteSearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(92, 92), painter: HeartPainter());
  }
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const green = Color(0xFF22C55E);

    final heartPaint = Paint()
      ..color = green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final heart = Path();
    heart.moveTo(w * 0.50, h * 0.78);
    heart.cubicTo(w * 0.18, h * 0.56, w * 0.10, h * 0.28, w * 0.28, h * 0.18);
    heart.cubicTo(w * 0.40, h * 0.11, w * 0.48, h * 0.18, w * 0.50, h * 0.28);
    heart.cubicTo(w * 0.52, h * 0.18, w * 0.60, h * 0.11, w * 0.72, h * 0.18);
    heart.cubicTo(w * 0.90, h * 0.28, w * 0.82, h * 0.56, w * 0.50, h * 0.78);

    canvas.drawPath(heart, heartPaint);

    final eyePaint = Paint()
      ..color = green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;

    final leftEye = Path()
      ..moveTo(w * 0.35, h * 0.43)
      ..quadraticBezierTo(w * 0.40, h * 0.39, w * 0.45, h * 0.43);

    final rightEye = Path()
      ..moveTo(w * 0.55, h * 0.43)
      ..quadraticBezierTo(w * 0.60, h * 0.39, w * 0.65, h * 0.43);

    canvas.drawPath(leftEye, eyePaint);
    canvas.drawPath(rightEye, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
