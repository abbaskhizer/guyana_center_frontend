import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const Scaffold(body: Center(child: Text("Web only")));

    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? cs.surface : const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            const WebHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: _WebEditProfileContent(),
                      ),
                    ),
                    const SizedBox(height: 64),
                    const WebFooter(),
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

class _WebEditProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: _LeftColumn()),
            const SizedBox(width: 32),
            Expanded(flex: 4, child: _RightColumn()),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? cs.outlineVariant : const Color(0xFFE5E7EB),
                ),
                borderRadius: BorderRadius.circular(8),
                color: isDark ? cs.surface : Colors.white,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: isDark ? cs.onSurface : Colors.black,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? cs.onSurface : const Color(0xFF111827),
                  ),
                ),
                Text(
                  "Update your personal information and preferences",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? cs.onSurfaceVariant
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark ? cs.outlineVariant : const Color(0xFFD1D5DB),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                foregroundColor: isDark
                    ? cs.onSurface
                    : const Color(0xFF374151),
                backgroundColor: isDark ? cs.surface : Colors.white,
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                elevation: 0,
              ),
              child: Row(
                children: const [
                  Icon(Icons.save_outlined, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Save Changes",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LeftColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfilePhotoCard(),
        const SizedBox(height: 24),
        _PersonalInfoCard(),
        const SizedBox(height: 24),
        _AboutBioCard(),
        const SizedBox(height: 24),
        _SpecializationsCard(),
        const SizedBox(height: 24),
        _OnlinePresenceCard(),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfilePreviewCard(),
        const SizedBox(height: 24),
        _ProfileCompletionCard(),
        const SizedBox(height: 24),
        _ProfileTipsCard(),
        const SizedBox(height: 24),
        _DangerZoneCard(),
        const SizedBox(height: 24),
        _DeleteAlert(),
      ],
    );
  }
}

// --------------------------- CARDS ---------------------------
class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? cs.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? cs.outlineVariant : const Color(0xFFF3F4F6),
        ),
      ),
      child: child,
    );
  }
}

class _ProfilePhotoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Photo",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? cs.onSurface : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFDCFCE7),
                    child: Text(
                      "R",
                      style: TextStyle(
                        color: const Color(0xFF16A34A),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload a new photo",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? cs.onSurface : const Color(0xFF374151),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "JPG, PNG or GIF. Max size 5MB.",
                    style: TextStyle(
                      color: isDark
                          ? cs.onSurfaceVariant
                          : const Color(0xFF9CA3AF),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.upload,
                          size: 16,
                          color: Color(0xFF16A34A),
                        ),
                        label: const Text(
                          "Upload Photo",
                          style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                        ),
                        child: const Text(
                          "Remove",
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonalInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal Information",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? cs.onSurface : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildField(context, "First Name", "Rachel")),
              const SizedBox(width: 16),
              Expanded(child: _buildField(context, "Last Name", "Morrison")),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  context,
                  "Email Address",
                  "rachel.morrison@proptt.com",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(context, "Phone Number", "(310) 555-0147"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField(context, "Address", "DRE #01945832"),
              ), // Or whatever this is in image... Oh wait, left is Address (DRE), actually image says Address: DRE #01945832 ok, fine.
              const SizedBox(width: 16),
              Expanded(child: _buildField(context, "City", "Los Angeles, CA")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : const Color(0xFF4B5563),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          style: TextStyle(
            color: isDark
                ? Theme.of(context).colorScheme.onSurface
                : const Color(0xFF111827),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isDark
                ? Theme.of(context).colorScheme.surface
                : const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? Theme.of(context).colorScheme.outlineVariant
                    : const Color(0xFFE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? Theme.of(context).colorScheme.outlineVariant
                    : const Color(0xFFE5E7EB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF16A34A)),
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutBioCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "About / Bio",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? cs.onSurface : const Color(0xFF111827),
                ),
              ),
              Text(
                "345 / 500",
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            maxLines: 4,
            initialValue:
                "With over 8 years of experience in the Los Angeles real estate market, I specialize in helping families find their dream homes in LA...",
            style: TextStyle(
              color: isDark ? cs.onSurface : const Color(0xFF111827),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: isDark ? cs.surface : const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? cs.outlineVariant : const Color(0xFFE5E7EB),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? cs.outlineVariant : const Color(0xFFE5E7EB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF16A34A)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecializationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final tags = [
      "Residential Sales",
      "Luxury Homes",
      "First-Time Buyers",
      "Investment Properties",
      "Land & Development",
      "Relocation Services",
    ];

    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Specializations",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? cs.onSurface : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: tags
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t,
                          style: const TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.close,
                          size: 14,
                          color: Color(0xFF16A34A),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Add a specialization...",
                    hintStyle: TextStyle(
                      color: isDark
                          ? cs.onSurfaceVariant
                          : const Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: isDark ? cs.surface : const Color(0xFFF9FAFB),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? cs.outlineVariant
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? cs.outlineVariant
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDCFCE7),
                  foregroundColor: const Color(0xFF16A34A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text(
                  "Add",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnlinePresenceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Online Presence",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? cs.onSurface : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 24),
          _buildFieldWithPrefix(
            context,
            "Website",
            "https://",
            "rachelmorrisonrealty.com",
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFieldWithPrefix(
                  context,
                  "Facebook",
                  null,
                  "rachel.morrison.realty",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWithPrefix(
                  context,
                  "Instagram",
                  "@",
                  "rachelmorrison_homes",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldWithPrefix(
    BuildContext context,
    String label,
    String? prefix,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? cs.onSurfaceVariant : const Color(0xFF4B5563),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? cs.outlineVariant : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              if (prefix != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(8),
                    ),
                    border: Border(
                      right: BorderSide(
                        color: isDark
                            ? cs.outlineVariant
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                  child: Text(
                    prefix,
                    style: TextStyle(
                      color: isDark
                          ? cs.onSurfaceVariant
                          : const Color(0xFF6B7280),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: TextEditingController(text: value),
                    style: TextStyle(
                      color: isDark ? cs.onSurface : const Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      filled: false,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfilePreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Preview",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFDCFCE7),
                child: const Text(
                  "R",
                  style: TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rachel Morrison",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: isDark ? cs.onSurface : const Color(0xFF111827),
                    ),
                  ),
                  Text(
                    "DRE #01945832",
                    style: TextStyle(
                      color: isDark
                          ? cs.onSurfaceVariant
                          : const Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _infoRow(Icons.location_on_outlined, "Los Angeles, CA", isDark, cs),
          const SizedBox(height: 10),
          _infoRow(
            Icons.email_outlined,
            "rachel.morrison@proptt.com",
            isDark,
            cs,
          ),
          const SizedBox(height: 10),
          _infoRow(Icons.phone_outlined, "(310) 555-0147", isDark, cs),
          const SizedBox(height: 10),
          _infoRow(
            Icons.language,
            "rachelmorrisonrealty.com",
            isDark,
            cs,
            color: const Color(0xFF16A34A),
          ),
          const SizedBox(height: 20),
          Divider(color: isDark ? cs.outlineVariant : const Color(0xFFF3F4F6)),
          const SizedBox(height: 20),
          Text(
            "With over 8 years of experience in the Los Angeles real estate market, I specialize in helping families find their dream ...",
            style: TextStyle(
              fontSize: 13,
              color: isDark ? cs.onSurfaceVariant : const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _miniTag("Residential Sales"),
              const SizedBox(width: 8),
              _miniTag("Luxury Homes"),
              const SizedBox(width: 8),
              _miniTag("First-Time Buyers"),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "+ 3 more",
            style: TextStyle(
              fontSize: 11,
              color: isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String text,
    bool isDark,
    ColorScheme cs, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color:
                color ??
                (isDark ? cs.onSurfaceVariant : const Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _miniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF16A34A),
        ),
      ),
    );
  }
}

class _ProfileCompletionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Completion",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? cs.onSurfaceVariant : const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: isDark
                        ? cs.surfaceContainerHighest
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.85,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "85%",
                style: TextStyle(
                  color: Color(0xFF16A34A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _checkItem("Personal information", true, isDark, cs),
          const SizedBox(height: 12),
          _checkItem("Profile photo", true, isDark, cs),
          const SizedBox(height: 12),
          _checkItem("Bio & specializations", true, isDark, cs),
          const SizedBox(height: 12),
          _checkItem("ID verification", false, isDark, cs),
          const SizedBox(height: 12),
          _checkItem("Social media links", false, isDark, cs),
        ],
      ),
    );
  }

  Widget _checkItem(String text, bool checked, bool isDark, ColorScheme cs) {
    return Row(
      children: [
        Icon(
          checked ? Icons.check_circle_outline : Icons.radio_button_unchecked,
          color: checked
              ? const Color(0xFF16A34A)
              : (isDark ? cs.outlineVariant : const Color(0xFFD1D5DB)),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? cs.onSurfaceVariant : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _ProfileTipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCFCE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profile Tips",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF16A34A),
            ),
          ),
          const SizedBox(height: 16),
          _tipBullet(
            "Complete profiles get 3x more inquiries from potential clients",
          ),
          const SizedBox(height: 10),
          _tipBullet(
            "Add a professional photo to build trust with buyers and renters",
          ),
          const SizedBox(height: 10),
          _tipBullet(
            "Verify your identity to display the trusted badge on your profile",
          ),
        ],
      ),
    );
  }

  Widget _tipBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6.0, right: 8.0),
          child: CircleAvatar(radius: 2, backgroundColor: Color(0xFF16A34A)),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF15803D), // Slightly darker green
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _DangerZoneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? cs.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Danger Zone",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.delete_outline,
                color: Color(0xFFEF4444),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Deactivate Account",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeleteAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCA5A5).withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: const Text(
              "Once deleted, all your data will be permanently lost.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
