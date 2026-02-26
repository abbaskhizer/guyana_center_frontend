import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Main Footer ──
        Container(
          width: double.infinity,
          color: const Color(0xFF0E8C3F),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBrandColumn(),
                    const SizedBox(height: 36),
                    Wrap(
                      spacing: 40,
                      runSpacing: 28,
                      children: [
                        _buildLinkColumn('Categories', const [
                          'Vehicles',
                          'Real Estate',
                          'Jobs',
                          'Electronics',
                        ]),
                        _buildLinkColumn('Company', const [
                          'About',
                          'Contact',
                          'Terms',
                          'Privacy',
                        ]),
                        _buildLinkColumn('Popular', const [
                          'Toyota for sale',
                          'Houses POS',
                          'Apartments rent',
                          'Phones for sale',
                        ]),
                      ],
                    ),
                    const SizedBox(height: 36),
                    _buildCompanyInfo(),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand + Post an ad + Store badges
                  Expanded(flex: 3, child: _buildBrandColumn()),
                  const SizedBox(width: 24),

                  // Categories
                  Expanded(
                    flex: 2,
                    child: _buildLinkColumn('Categories', const [
                      'Vehicles',
                      'Real Estate',
                      'Jobs',
                      'Electronics',
                    ]),
                  ),

                  // Company
                  Expanded(
                    flex: 2,
                    child: _buildLinkColumn('Company', const [
                      'About',
                      'Contact',
                      'Terms',
                      'Privacy',
                    ]),
                  ),

                  // Popular
                  Expanded(
                    flex: 2,
                    child: _buildLinkColumn('Popular', const [
                      'Toyota for sale',
                      'Houses POS',
                      'Apartments rent',
                      'Phones for sale',
                    ]),
                  ),

                  const SizedBox(width: 16),

                  // Company info + Payment icons
                  Expanded(flex: 3, child: _buildCompanyInfo()),
                ],
              );
            },
          ),
        ),

        // ── Divider line ──
        Container(
          width: double.infinity,
          height: 1,
          color: const Color(0xFF3DAF6A),
        ),

        // ── Bottom Bar ──
        Container(
          width: double.infinity,
          color: const Color(0xFF0E8C3F),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'GUYANACENTRALCLASSIFIEDS.COM',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Brand column: Logo → Post an ad → Store badges (all centered) ──
  Widget _buildBrandColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'GUYANA',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              TextSpan(
                text: 'CENTRAL',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFF5A623),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Post an ad button (centered between logo and badges)
        SizedBox(
          width: 200,
          height: 48,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white54, width: 1.2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'Post an ad',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Store badges – using the official SVG assets
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Google Play badge
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SvgPicture.asset('assets/playstore.svg', height: 48),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // App Store badge
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SvgPicture.asset('assets/appstore.svg', height: 48),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Link column ──
  Widget _buildLinkColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  link,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Company info + Payment icons ──
  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guyanacentral Classifieds Limited',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Kyriacou Matsi 44,',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
        const Text(
          'Office 101, Nicosia, Cyprus',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),

        // Payment icons row 1: Mastercard + LINX
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _MastercardIcon(),
            SizedBox(width: 10),
            _LinxBadge(),
          ],
        ),
        const SizedBox(height: 12),

        // Payment icons row 2: VISA SECURE + Mastercard + ID Check
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _VisaSecureBadge(),
            SizedBox(width: 12),
            _MastercardIcon(),
            SizedBox(width: 8),
            Text(
              'ID Check',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════
//  Mastercard Icon (two overlapping circles)
// ═══════════════════════════════════════════
class _MastercardIcon extends StatelessWidget {
  const _MastercardIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3D),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: SizedBox(
          width: 34,
          height: 22,
          child: Stack(
            children: [
              // Red circle (left)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEB001B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Orange/yellow circle (right, overlapping)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF79E1B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  LINX Badge
// ═══════════════════════════════════════════
class _LinxBadge extends StatelessWidget {
  const _LinxBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5A623),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'LINX',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  VISA SECURE Badge
// ═══════════════════════════════════════════
class _VisaSecureBadge extends StatelessWidget {
  const _VisaSecureBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F71),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'VISA',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(width: 6),
          Text(
            'SECURE',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
