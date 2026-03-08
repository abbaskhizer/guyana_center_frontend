import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/sell_controller.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dividerColor = theme.dividerTheme.color ?? cs.outlineVariant;
    final controller = Get.isRegistered<SellController>()
        ? Get.find<SellController>()
        : Get.put(SellController(), permanent: true);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            if (!kIsWeb) const MobileHeader(),
            if (!kIsWeb) const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: controller.goBack,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: cs.outlineVariant.withOpacity(.5),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: cs.onSurface,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Post a Free Ad",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                            fontSize: 20,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Reach thousands of buyers across Trinidad & Tobago",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(.55),
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: _StepStripWrapper(),
            ),
            const SizedBox(height: 10),
            Divider(color: dividerColor),
            const SizedBox(height: 10),
            Obx(() {
              switch (controller.step.value) {
                case 1:
                  return const _Step1Details();
                case 2:
                  return const _Step2PhotosPrice();
                case 3:
                  return const _Step3Contact();
                default:
                  return const _Step1Details();
              }
            }),
          ],
        ),
      ),
    );
  }
}

class _StepStripWrapper extends StatelessWidget {
  const _StepStripWrapper();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellController>();

    return Obx(
      () => _StepStrip(step: controller.step.value, onTap: controller.setStep),
    );
  }
}

class _Step1Details extends StatelessWidget {
  const _Step1Details();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final inputFill = theme.inputDecorationTheme.fillColor ?? cs.surface;
    final controller = Get.find<SellController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ad Details",
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Category",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface.withOpacity(.7),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => _CategoryGrid(
            selected: controller.selectedCategory.value,
            onTap: controller.selectCategoryIndex,
            categories: controller.categories,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "Ad Title",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface.withOpacity(.45),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.titleCtrl,
          decoration: InputDecoration(
            hintText: "e.g. Toyota Hilux 2022 Super GL...",
            filled: true,
            fillColor: cs.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.primary, width: 1.4),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Be specific, include brand, model and key details",
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withOpacity(.45),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "Description",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface.withOpacity(.45),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.descCtrl,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Describe your item in detail - condition, features...",
            filled: true,
            fillColor: cs.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.primary, width: 1.4),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () => Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${controller.descCount.value} / ${SellController.maxDesc} characters",
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(.45),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "Condition",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface.withOpacity(.45),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          final active = controller.conditionIndex.value;
          return Row(
            children: [
              Expanded(
                child: _PillChoice(
                  text: "Brand New",
                  active: active == 0,
                  onTap: () => controller.setCondition(0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PillChoice(
                  text: "Like New",
                  active: active == 1,
                  onTap: () => controller.setCondition(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PillChoice(
                  text: "Used",
                  active: active == 2,
                  onTap: () => controller.setCondition(2),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 25),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: controller.continueNext,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Continue",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: cs.onPrimary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Step2PhotosPrice extends StatelessWidget {
  const _Step2PhotosPrice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dividerColor = theme.dividerTheme.color ?? cs.outlineVariant;
    final inputFill = theme.inputDecorationTheme.fillColor ?? cs.surface;
    final controller = Get.find<SellController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Photos",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Add up to 10 photos. The first photo will be the cover.",
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withOpacity(.55),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final imgs = controller.images;

          return AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: imgs.length < 10 ? imgs.length + 1 : imgs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: 110 / 86,
              ),
              itemBuilder: (_, i) {
                if (i == imgs.length && imgs.length < 10) {
                  return InkWell(
                    onTap: controller.addMockPhoto,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Add Photo",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface.withOpacity(.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final url = imgs[i];

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        url,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: InkWell(
                        onTap: () => controller.removePhoto(i),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cs.onSurface.withOpacity(.7),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (i == 0)
                      Positioned(
                        left: 6,
                        bottom: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Cover",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        }),
        const SizedBox(height: 18),
        Divider(color: dividerColor),
        const SizedBox(height: 18),
        Text(
          "Pricing",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Price (TTD)",
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: cs.onSurface.withOpacity(.7),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.priceCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '\$0.00',
            filled: true,
            fillColor: cs.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.primary, width: 1.4),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => CheckboxListTile(
            value: controller.negotiable.value,
            onChanged: (v) => controller.negotiable.value = v ?? false,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              "Price is negotiable",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withOpacity(.7),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Divider(color: dividerColor),
        const SizedBox(height: 12),
        Row(
          children: [
            InkWell(
              onTap: controller.goBack,
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Back",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface.withOpacity(.7),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: controller.continueNext,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "Continue",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: cs.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _Step3Contact extends StatelessWidget {
  const _Step3Contact();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dividerColor = theme.dividerTheme.color ?? cs.outlineVariant;
    final controller = Get.find<SellController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact & Location",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Location",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface.withOpacity(.7),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final current = controller.selectedArea.value;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                value: current == "Select your area" ? null : current,
                hint: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: cs.onSurfaceVariant,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Select your area",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(.55),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                items: controller.areas
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Center(
                          child: Text(
                            e,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.setArea(v);
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 35),
        Text(
          "Phone Number",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface.withOpacity(.7),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "(868) 000-0000",
            prefixIcon: Icon(Icons.phone_outlined, color: cs.onSurfaceVariant),
            filled: true,
            fillColor: cs.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.primary, width: 1.4),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Buyers will contact you in this number",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: cs.onSurface.withOpacity(.7),
          ),
        ),
        const SizedBox(height: 35),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Text(
            "Preferred Contact Method",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            final m = controller.contactMethod.value;

            Widget tile({
              String? image,
              required ContactMethod value,
              IconData? icon,
              required String label,
            }) {
              final active = m == value;

              const red = Color(0xFFE53935);
              const lightRed = Color(0xFFFFEBEE);

              final borderColor = active ? red : cs.outlineVariant;
              final bg = active ? lightRed : theme.cardColor;
              final txt = active ? red : cs.onSurfaceVariant;

              return InkWell(
                onTap: () => controller.setContactMethod(value),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: borderColor,
                      width: active ? 1.4 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (image != null)
                        Image.asset(image, width: 18, height: 18, color: txt)
                      else if (icon != null)
                        Icon(icon, size: 18, color: txt),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: txt,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                tile(
                  value: ContactMethod.chat,
                  image: 'assets/chat.png',
                  label: "In-app Chat",
                ),
                const SizedBox(height: 12),
                tile(
                  value: ContactMethod.call,
                  icon: Icons.call_rounded,
                  label: "Phone Call",
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE53935).withOpacity(.35)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 25,
                color: Color(0xFFE53935),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ready to Publish",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFB71C1C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Your ad will be live immediately and visible to\n"
                      "thousands of buyers across Trinidad & Tobago.\n"
                      "You can edit or remove it anytime.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        color: cs.onSurfaceVariant,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Divider(color: dividerColor),
        const SizedBox(height: 14),
        Row(
          children: [
            TextButton.icon(
              onPressed: controller.goBack,
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              label: Text(
                "Back",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: controller.continueNext,
                icon: Icon(Icons.upload_rounded, size: 18, color: cs.onPrimary),
                label: Text(
                  "Post ad for free",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final int selected;
  final void Function(int) onTap;
  final List categories;

  const _CategoryGrid({
    required this.selected,
    required this.onTap,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GridView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (_, i) {
        final cat = categories[i];
        final active = i == selected;

        return InkWell(
          onTap: () => onTap(i),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: active ? cs.primary.withOpacity(.10) : theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: active ? cs.primary.withOpacity(.15) : cs.outlineVariant,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  cat.icon,
                  height: 22,
                  width: 22,
                  color: active ? cs.primary : cs.onSurfaceVariant,
                ),
                const SizedBox(height: 6),
                Text(
                  cat.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: active ? cs.primary : cs.onSurface.withOpacity(.75),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StepStrip extends StatelessWidget {
  final int step;
  final void Function(int) onTap;

  const _StepStrip({required this.step, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    const currentYellow = Color(0xFFFFC107);

    Widget node(int n, String label) {
      final active = n == step;
      final done = n < step;

      final fill = active
          ? currentYellow
          : done
          ? cs.primary
          : theme.cardColor;

      final border = active
          ? currentYellow
          : done
          ? cs.primary
          : cs.outlineVariant;

      final textC = active
          ? Colors.black
          : done
          ? cs.onPrimary
          : cs.onSurface.withOpacity(.55);

      final labelC = (active || done)
          ? cs.onSurface.withOpacity(.65)
          : cs.onSurface.withOpacity(.45);

      return InkWell(
        onTap: () => onTap(n),
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: Border.all(color: border),
              ),
              alignment: Alignment.center,
              child: done
                  ? Icon(Icons.check_rounded, size: 16, color: cs.onPrimary)
                  : Text(
                      "$n",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: textC,
                      ),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: labelC,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    Widget line(bool doneLine) {
      return Expanded(
        child: Container(
          height: 2,
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: doneLine ? cs.primary.withOpacity(.45) : cs.outlineVariant,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      );
    }

    return Row(
      children: [
        node(1, "Details"),
        const SizedBox(width: 8),
        line(step >= 2),
        const SizedBox(width: 8),
        node(2, "Photos & Price"),
        const SizedBox(width: 8),
        line(step >= 3),
        const SizedBox(width: 8),
        node(3, "Contact"),
      ],
    );
  }
}

class _PillChoice extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _PillChoice({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? cs.primary.withOpacity(.10) : cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? cs.primary : cs.outlineVariant,
            width: active ? 1.4 : 1,
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: active ? cs.primary : cs.onSurface.withOpacity(.7),
          ),
        ),
      ),
    );
  }
}
