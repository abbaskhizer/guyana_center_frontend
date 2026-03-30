import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/services/api_services.dart';

class ProfileDot extends StatelessWidget {
  const ProfileDot({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Obx(() {
        final photoUrl = AuthService.to.userPhotoUrl.value;
        String? fullPhotoUrl;
        if (photoUrl != null && photoUrl.isNotEmpty) {
          if (photoUrl.startsWith('http')) {
            fullPhotoUrl = photoUrl;
          } else {
            fullPhotoUrl = '${ApiService.baseUrl}${photoUrl.startsWith('/') ? '' : '/'}$photoUrl';
          }
        }
        if (fullPhotoUrl != null && fullPhotoUrl.isNotEmpty) {
          return CircleAvatar(
            radius: 14,
            backgroundColor: cs.primary,
            backgroundImage: NetworkImage(fullPhotoUrl),
            onBackgroundImageError: (_, __) {},
          );
        }
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(Icons.person_rounded, color: cs.onPrimary, size: 16),
        );
      }),
    );
  }
}
