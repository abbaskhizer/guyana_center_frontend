import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guyana_center_frontend/controller/setting/account_infromation_controller.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AccountController>()) {
      Get.put(AccountController());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SafeArea(
        child: SingleChildScrollView(child: AccountContent(showTopBar: true)),
      ),
    );
  }
}

class AccountContent extends StatelessWidget {
  final bool showTopBar;
  const AccountContent({super.key, this.showTopBar = false});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<AccountController>()
        ? Get.find<AccountController>()
        : Get.put(AccountController());

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final content = Column(
      children: [
        // Profile Photo Section
        Obx(() {
          final photoUrl = AuthService.to.userPhotoUrl.value;
          // Convert relative path to full URL if needed
          String? fullPhotoUrl;
          if (photoUrl != null && photoUrl.isNotEmpty) {
            if (photoUrl.startsWith('http')) {
              fullPhotoUrl = photoUrl;
            } else {
              fullPhotoUrl = 'http://185.197.194.139$photoUrl';
            }
          }
          return _SectionCard(
            title: "Profile Photo",
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  if (fullPhotoUrl != null && fullPhotoUrl.isNotEmpty)
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: cs.primary,
                      backgroundImage: NetworkImage(fullPhotoUrl),
                      onBackgroundImageError: (_, __) {},
                    )
                  else
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: cs.primary.withOpacity(0.12),
                      child: Text(
                        c.fullName.value.isNotEmpty
                            ? c.fullName.value[0].toUpperCase()
                            : AuthService.to.userName.value?.isNotEmpty == true
                                ? AuthService.to.userName.value![0].toUpperCase()
                                : "U",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profile Picture",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Add a photo to represent your account",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => c.pickProfileImage(),
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text("Change"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              if (photoUrl != null && photoUrl.isNotEmpty) ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => c.removeProfileImage(),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text("Remove photo"),
                  style: TextButton.styleFrom(
                    foregroundColor: cs.error,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                  ),
                ),
              ],
            ],
          );
        }),
        const SizedBox(height: 16),
        _SectionCard(
          title: "Account Information",
          children: [
            const SizedBox(height: 6),
            Obx(
              () => _InfoRow(
                title: "Full Name",
                value: c.fullName.value,
                trailingText: "Edit",
                onTapTrailing: () => c.editField(
                  title: "Full Name",
                  field: c.fullName,
                  currentValue: c.fullName.value,
                ),
              ),
            ),
            _divider(context),
            Obx(
              () => _InfoRow(
                title: "Email",
                value: c.email.value,
                verified: c.emailVerified.value,
              ),
            ),
            _divider(context),
            Obx(
              () => _InfoRow(
                title: "Phone",
                value: c.phone.value,
                trailingText: "Edit",
                onTapTrailing: () => c.editField(
                  title: "Phone",
                  field: c.phone,
                  currentValue: c.phone.value,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          // Only show connected accounts section if user is logged in with Google or Facebook
          if (c.loginMethod.value != 'google' && c.loginMethod.value != 'facebook') {
            return const SizedBox.shrink();
          }
          return _SectionCard(
            title: "Connected Accounts",
            children: [
              const SizedBox(height: 6),
              if (c.loginMethod.value == 'google') ...[
                Obx(
                  () => _ConnectedRow(
                    iconBg: theme.cardColor,
                    iconColor: cs.onSurfaceVariant,
                    icon: Icons.g_mobiledata_rounded,
                    title: "Google",
                    subtitle: c.googleEmail.value,
                    connected: true,
                    onConnect: () {},
                    onDisconnect: () {},
                  ),
                ),
              ],
              if (c.loginMethod.value == 'facebook') ...[
                Obx(
                  () => _ConnectedRow(
                    iconBg: theme.cardColor,
                    iconColor: cs.onSurfaceVariant,
                    icon: Icons.facebook,
                    title: "Facebook",
                    subtitle: "Connected",
                    connected: true,
                    onConnect: () {},
                    onDisconnect: () {},
                  ),
                ),
              ],
            ],
          );
        }),
        const SizedBox(height: 16),
        _SectionCard(
          title: "Membership",
          children: [
            const SizedBox(height: 6),
            Obx(
              () => Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD08A00),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/crown.png',
                      height: 20,
                      width: 20,
                      color: cs.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.planName.value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c.planDesc.value,
                          maxLines: 2,
                          softWrap: true,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    c.planPrice.value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.errorContainer.withOpacity(.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(.5)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: cs.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Once deleted, all your data will be permanently lost.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: c.deleteAccount,
                  icon: Icon(Icons.delete_outline, color: cs.error),
                  label: Text(
                    "Delete Account",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.error,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.error.withOpacity(.55)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: theme.cardColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTopBar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "Account",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        if (!kIsWeb)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(color: cs.surface),
            child: content,
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: content,
          ),
      ],
    );
  }

  static Widget _divider(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: theme.dividerTheme.color ?? cs.outlineVariant),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
      ),
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
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.title,
    required this.value,
    this.trailingText,
    this.onTapTrailing,
    this.verified = false,
  });

  final String title;
  final String value;
  final String? trailingText;
  final VoidCallback? onTapTrailing;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (verified)
          _VerifiedPill(color: cs.primary)
        else if (trailingText != null)
          InkWell(
            onTap: onTapTrailing,
            child: Text(
              trailingText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            "Verified",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectedRow extends StatelessWidget {
  const _ConnectedRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.connected,
    required this.onConnect,
    required this.onDisconnect,
    required this.iconBg,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool connected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final Color iconBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant.withOpacity(.5)),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        connected
            ? Text(
                "Connected",
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                ),
              )
            : SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: onConnect,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    backgroundColor: theme.cardColor,
                  ),
                  child: Text(
                    "Connect",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
