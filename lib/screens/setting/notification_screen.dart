import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/setting/notification_controller.dart';
import 'package:guyana_center_frontend/widgets/section_card.dart';
import 'package:guyana_center_frontend/widgets/switch_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: NotificationsContent(showTopBar: true),
        ),
      ),
    );
  }
}

class NotificationsContent extends StatelessWidget {
  final bool showTopBar;
  const NotificationsContent({super.key, this.showTopBar = false});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put(NotificationController());

    final cs = Theme.of(context).colorScheme;

    final content = Column(
      children: [
        SectionCard(
          icon: Icons.mail_outline_rounded,
          title: "Email",
          children: [
            Obx(
              () => SwitchTile(
                title: "Pin activity",
                value: c.emailPinActivity.value,
                onChanged: (v) => c.emailPinActivity.value = v,
                showTopDivider: false,
              ),
            ),
            Obx(
              () => SwitchTile(
                title: "Comments",
                value: c.emailComments.value,
                onChanged: (v) => c.emailComments.value = v,
              ),
            ),
            Obx(
              () => SwitchTile(
                title: "New followers",
                value: c.emailFollowers.value,
                onChanged: (v) => c.emailFollowers.value = v,
              ),
            ),
            Obx(
              () => SwitchTile(
                title: "Newsletter",
                value: c.emailNewsletter.value,
                onChanged: (v) => c.emailNewsletter.value = v,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SectionCard(
          icon: Icons.smartphone_rounded,
          title: "Push Notification",
          children: [
            Obx(
              () => SwitchTile(
                title: "Likes",
                value: c.pushLikes.value,
                onChanged: (v) => c.pushLikes.value = v,
                showTopDivider: false,
              ),
            ),
            Obx(
              () => SwitchTile(
                title: "Comments",
                value: c.pushComments.value,
                onChanged: (v) => c.pushComments.value = v,
              ),
            ),
            Obx(
              () => SwitchTile(
                title: "Mentions",
                value: c.pushMentions.value,
                onChanged: (v) => c.pushMentions.value = v,
              ),
            ),
            Obx(
              () => SwitchTile(
                title: "Followers",
                value: c.pushFollowers.value,
                onChanged: (v) => c.pushFollowers.value = v,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SectionCard(
          icon: Icons.notifications_active_outlined,
          title: "In-App Notification",
          children: [
            Obx(
              () => SwitchTile(
                title: "Activity feed",
                value: c.inAppActivity.value,
                onChanged: (v) => c.inAppActivity.value = v,
                showTopDivider: false,
              ),
            ),
            Obx(
              () => SwitchTile(
                title: "Product updates",
                value: c.inAppProductUpdates.value,
                onChanged: (v) => c.inAppProductUpdates.value = v,
              ),
            ),
          ],
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTopBar)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                ),
                const SizedBox(width: 4),
                Text(
                  "Notifications",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),

        if (!kIsWeb)
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            width: double.infinity,
            decoration: BoxDecoration(color: cs.surface),
            child: content,
          )
        else
          content,
      ],
    );
  }
}
