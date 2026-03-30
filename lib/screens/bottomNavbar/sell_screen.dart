import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/sell_controller.dart';
import 'package:guyana_center_frontend/widgets/mobile_header.dart';
import 'package:guyana_center_frontend/widgets/web_footer.dart';
import 'package:guyana_center_frontend/widgets/web_header.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'dart:io' show File;

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  bool _isWebDesktop(BuildContext context) =>
      kIsWeb && MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SellController>()
        ? Get.find<SellController>()
        : Get.put(SellController(), permanent: true);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _isWebDesktop(context)
            ? _WebLayout(controller: controller)
            : _MobileLayout(controller: controller),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final SellController controller;
  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.dividerTheme.color ?? theme.colorScheme.outlineVariant;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        const MobileHeader(),
        const SizedBox(height: 10),
        const _SellHeaderBlock(isWeb: false),
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
    );
  }
}

class _WebLayout extends StatelessWidget {
  final SellController controller;
  const _WebLayout({required this.controller});

  double _contentMaxWidth(double w) {
    if (w >= 1440) return 1100;
    if (w >= 1200) return 1000;
    if (w >= 1000) return 900;
    return w - 32;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = _contentMaxWidth(constraints.maxWidth);

        Widget centered(Widget child) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: child,
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const WebHeader(),
                  Container(
                    width: double.infinity,
                    color: theme.cardColor,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: centered(const _SellHeaderBlock(isWeb: true)),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: centered(
                Column(
                  children: [
                    const SizedBox(height: 24),
                    const _StepStripWrapper(),
                    const SizedBox(height: 24),
                    Divider(color: cs.outlineVariant),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: WebFooter()),
          ],
        );
      },
    );
  }
}

class _SellHeaderBlock extends StatelessWidget {
  final bool isWeb;
  const _SellHeaderBlock({required this.isWeb});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final controller = Get.find<SellController>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isWeb) ...[
          InkWell(
            onTap: controller.goBack,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cs.outlineVariant.withOpacity(.5),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.chevron_left_rounded,
                color: cs.onSurface,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Post a Free Ad",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                  fontSize: isWeb ? 28 : 20,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Reach thousands of buyers across Trinidad & Tobago",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(.55),
                  fontWeight: FontWeight.w600,
                  fontSize: isWeb ? 14 : 10,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
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
        Obx(
          () => TextField(
            controller: controller.titleCtrl,
            decoration: InputDecoration(
              hintText: controller.adTitleHint,
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
        Obx(() {
          if (controller.isJobCategory || controller.isPetsCategory || controller.isServicesCategory || controller.isBusinessCategory) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Text(
                "Condition",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface.withOpacity(.45),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _PillChoice(
                      text: "Brand New",
                      active: controller.conditionIndex.value == 0,
                      onTap: () => controller.setCondition(0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PillChoice(
                      text: "Like New",
                      active: controller.conditionIndex.value == 1,
                      onTap: () => controller.setCondition(1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PillChoice(
                      text: "Used",
                      active: controller.conditionIndex.value == 2,
                      onTap: () => controller.setCondition(2),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
        // Vehicle/Electronics/Fashion/HomeGarden/Kids/Pets/HealthBeauty/Services/Business specific fields
        Obx(() {
          if (!(controller.isVehicleCategory || controller.isElectronicsCategory || controller.isFashionCategory || controller.isHomeGardenCategory || controller.isKidsCategory || controller.isPetsCategory || controller.isHealthBeautyCategory || controller.isServicesCategory || controller.isBusinessCategory)) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                controller.isVehicleCategory
                    ? "Vehicle Details"
                    : controller.isPetsCategory
                        ? "Animal Details"
                        : controller.isServicesCategory
                            ? "Service Details"
                            : controller.isBusinessCategory
                                ? "Business Details"
                                : controller.isElectronicsCategory
                                    ? "Device Details"
                                    : controller.isHealthBeautyCategory
                                        ? "Product Details"
                                        : controller.isFashionCategory
                                            ? "Brand Details"
                                            : "Item Details",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                controller.isPetsCategory 
                    ? "Species / Type" 
                    : controller.isServicesCategory 
                        ? "Service Type" 
                        : controller.isBusinessCategory
                            ? "Business Type"
                            : "Brand",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.brandCtrl,
                decoration: InputDecoration(
                  hintText: controller.isVehicleCategory
                      ? "e.g. Toyota, Nissan, Honda"
                      : controller.isPetsCategory
                          ? "e.g. Dog, Cat, Bird"
                          : controller.isBusinessCategory
                              ? "e.g. Restaurant, Retail, Salon"
                              : controller.isServicesCategory
                                  ? "e.g. Plumbing, Cleaning, Handyman"
                                  : controller.isElectronicsCategory
                                      ? "e.g. Apple, Samsung, Sony"
                                      : controller.isHealthBeautyCategory
                                          ? "e.g. L'Oréal, MAC, Dove"
                                          : controller.isFashionCategory
                                              ? "e.g. Nike, Zara, Gucci"
                                              : controller.isKidsCategory
                                                  ? "e.g. Fisher-Price, Graco, Carter's"
                                                  : "e.g. LG, Ashley Furniture, Custom",
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
              if (!controller.isFashionCategory && !controller.isHealthBeautyCategory && !controller.isServicesCategory && !controller.isBusinessCategory) ...[
                const SizedBox(height: 14),
                Text(
                  controller.isPetsCategory ? "Breed" : "Model",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface.withOpacity(.7),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.modelCtrl,
                  decoration: InputDecoration(
                    hintText: controller.isVehicleCategory 
                          ? "e.g. Hilux, Juke, Civic" 
                          : controller.isPetsCategory
                              ? "e.g. German Shepherd, Persian (Optional)"
                              : controller.isElectronicsCategory
                                  ? "e.g. iPhone 15, Galaxy S24"
                                  : controller.isKidsCategory
                                      ? "e.g. 4-in-1 Stroller (Optional)"
                                      : "e.g. WRX735SDHZ (Optional)",
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
              ],
              if (controller.isVehicleCategory) ...[
                const SizedBox(height: 14),
                Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Year",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface.withOpacity(.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.yearCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "2020",
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mileage (km)",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface.withOpacity(.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.mileageCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "50000",
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
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                "Transmission",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _TransmissionPill(
                    text: "Automatic",
                    active: controller.transmission.value == "automatic",
                    onTap: () => controller.setTransmission("automatic"),
                  ),
                  _TransmissionPill(
                    text: "Manual",
                    active: controller.transmission.value == "manual",
                    onTap: () => controller.setTransmission("manual"),
                  ),
                  _TransmissionPill(
                    text: "CVT",
                    active: controller.transmission.value == "cvt",
                    onTap: () => controller.setTransmission("cvt"),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                "Fuel Type",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FuelPill(
                    text: "Petrol",
                    active: controller.fuelType.value == "petrol",
                    onTap: () => controller.setFuelType("petrol"),
                  ),
                  _FuelPill(
                    text: "Diesel",
                    active: controller.fuelType.value == "diesel",
                    onTap: () => controller.setFuelType("diesel"),
                  ),
                  _FuelPill(
                    text: "Hybrid",
                    active: controller.fuelType.value == "hybrid",
                    onTap: () => controller.setFuelType("hybrid"),
                  ),
                  _FuelPill(
                      text: "Electric",
                      active: controller.fuelType.value == "electric",
                      onTap: () => controller.setFuelType("electric"),
                    ),
                  ],
                ),
              ],
            ],
          );
        }),
        // Real Estate specific fields
        Obx(() {
          if (!controller.isRealEstateCategory) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Property Details",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 14),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _DropdownField(
                      label: "Bedrooms",
                      hint: "Choose one...",
                      value: controller.bedroomsCtrl.text,
                      items: const ["1", "2", "3", "4", "5", "6+"],
                      onChanged: (v) => controller.bedroomsCtrl.text = v!,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DropdownField(
                      label: "Bathrooms",
                      hint: "Choose one...",
                      value: controller.bathroomsCtrl.text,
                      items: const ["1", "2", "3", "4", "5+"],
                      onChanged: (v) => controller.bathroomsCtrl.text = v!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _DropdownField(
                      label: "Parking",
                      hint: "Choose one...",
                      value: controller.parking.value,
                      items: const ["No", "1 space", "2 spaces", "3+ spaces"],
                      onChanged: (v) => controller.parking.value = v!,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DropdownField(
                      label: "Gated",
                      hint: "Choose one...",
                      value: controller.gated.value ? "Yes" : "No",
                      items: const ["Yes", "No"],
                      onChanged: (v) => controller.gated.value = v == "Yes",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _DropdownField(
                      label: "Tiled",
                      hint: "Choose one...",
                      value: controller.tiled.value ? "Yes" : "No",
                      items: const ["Yes", "No"],
                      onChanged: (v) => controller.tiled.value = v == "Yes",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DropdownField(
                      label: "Air Conditioning",
                      hint: "Choose one...",
                      value: controller.ac.value,
                      items: const ["None", "Partial", "Full"],
                      onChanged: (v) => controller.ac.value = v!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _DropdownField(
                      label: "Master Ensuite",
                      hint: "Choose one...",
                      value: controller.ensuite.value ? "Yes" : "No",
                      items: const ["Yes", "No"],
                      onChanged: (v) => controller.ensuite.value = v == "Yes",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DropdownField(
                      label: "Furnishing",
                      hint: "Choose one...",
                      value: controller.furnished.value == true ? "Fully" : "Unfurnished",
                      items: const ["Fully", "Semi", "Unfurnished"],
                      onChanged: (v) => controller.furnished.value = v != "Unfurnished",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                "Floor area (sqft)",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.areaCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "e.g. 1500 sq.ft",
                  filled: true,
                  fillColor: cs.surface,
                  suffixText: "sq.ft",
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
              const SizedBox(height: 14),
              Text(
                "Village",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.villageCtrl,
                decoration: InputDecoration(
                  hintText: "Enter village name",
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
              const SizedBox(height: 14),
              Text(
                "Water",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => CheckboxListTile(
                      value: controller.waterHot.value,
                      onChanged: (v) => controller.waterHot.value = v ?? false,
                      title: const Text("Hot"),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    )),
                  ),
                  Expanded(
                    child: Obx(() => CheckboxListTile(
                      value: controller.waterCold.value,
                      onChanged: (v) => controller.waterCold.value = v ?? false,
                      title: const Text("Cold"),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Includes",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              Obx(() => CheckboxListTile(
                value: controller.amenityPool.value,
                onChanged: (v) => controller.amenityPool.value = v ?? false,
                title: const Text("Pool"),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              )),
              Obx(() => CheckboxListTile(
                value: controller.amenityElevator.value,
                onChanged: (v) => controller.amenityElevator.value = v ?? false,
                title: const Text("Elevator Access"),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              )),
              Obx(() => CheckboxListTile(
                value: controller.amenityPatio.value,
                onChanged: (v) => controller.amenityPatio.value = v ?? false,
                title: const Text("Patio"),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              )),
              const SizedBox(height: 8),
              _DropdownField(
                label: "Built-in Cupboards",
                hint: "Choose one...",
                value: controller.cupboards.value,
                items: const ["Yes", "No"],
                onChanged: (v) => controller.cupboards.value = v!,
              ),
            ],
          );
        }),
        // Jobs specific fields
        Obx(() {
          if (!controller.isJobCategory) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Job Details",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Company / Employer Name",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.companyNameCtrl,
                decoration: InputDecoration(
                  hintText: "e.g. Guyana Oil Company",
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
              const SizedBox(height: 14),
              Text(
                "Job Type",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final type in [
                        ('full-time', 'Full-Time'),
                        ('part-time', 'Part-Time'),
                        ('contract', 'Contract'),
                        ('internship', 'Internship'),
                        ('remote', 'Remote'),
                      ])
                        _JobPill(
                          text: type.$2,
                          active: controller.jobType.value == type.$1,
                          onTap: () => controller.jobType.value = type.$1,
                        ),
                    ],
                  )),
              const SizedBox(height: 14),
              Text(
                "Experience Level",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final lvl in [
                        ('entry', 'Entry Level'),
                        ('mid', 'Mid Level'),
                        ('senior', 'Senior'),
                        ('executive', 'Executive'),
                      ])
                        _JobPill(
                          text: lvl.$2,
                          active: controller.experienceLevel.value == lvl.$1,
                          onTap: () => controller.experienceLevel.value = lvl.$1,
                        ),
                    ],
                  )),
              const SizedBox(height: 14),
              _DropdownField(
                label: "Salary Period",
                hint: "Choose one...",
                value: controller.salaryPeriod.value,
                items: const ["monthly", "annually", "hourly"],
                onChanged: (v) => controller.salaryPeriod.value = v!,
              ),
              const SizedBox(height: 14),
              Text(
                "Industry / Sector",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.industryCtrl,
                decoration: InputDecoration(
                  hintText: "e.g. Oil & Gas, Construction, Finance",
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

                Widget imageWidget;
                if (url.startsWith('http') || url.startsWith('/uploads')) {
                  // Network image
                  final fullUrl = url.startsWith('http') ? url : '${ApiService.baseUrl}$url';
                  imageWidget = Image.network(
                    fullUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: cs.surface,
                      child: Icon(Icons.broken_image, color: cs.onSurface.withOpacity(.2)),
                    ),
                  );
                } else if (kIsWeb) {
                  // Web platform - usually a blob or network-like path for picked files
                  imageWidget = Image.network(
                    url,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  );
                } else {
                  // Mobile platform - use file image
                  imageWidget = Image.file(
                    File(url),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  );
                }

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: imageWidget,
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
        Obx(() => Text(
          controller.isJobCategory ? "Salary" : "Pricing",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        )),
        const SizedBox(height: 12),
        Obx(() => Text(
          controller.isJobCategory ? "Salary amount" : "Price (TTD)",
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: cs.onSurface.withOpacity(.7),
          ),
        )),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (!controller.isJobCategory) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                height: 48,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.currency.value,
                    items: const [
                      DropdownMenuItem(value: 'TTD', child: Text('TT\$')),
                      DropdownMenuItem(value: 'USD', child: Text('US\$')),
                    ],
                    onChanged: (v) => controller.currency.value = v ?? 'TTD',
                    icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: cs.onSurface.withOpacity(.5)),
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }),
            Expanded(
              child: TextField(
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
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => CheckboxListTile(
            value: controller.negotiable.value,
            onChanged: (v) => controller.negotiable.value = v ?? false,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              controller.isJobCategory ? "Salary is negotiable" : "Price is negotiable",
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
        // OpenStreetMap Preview with Current Location
        Text(
          "Map Location",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface.withOpacity(.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Obx(() {
              return Stack(
                children: [
                  FlutterMap(
                    mapController: controller.mapController.value,
                    options: MapOptions(
                      initialCenter: controller.currentLocation.value ??
                          const LatLng(10.6918, -61.2225), // Default to Port of Spain, Trinidad
                      initialZoom: 15,
                      onTap: (tapPosition, latLng) {
                        // Set location when user taps on map
                        controller.currentLocation.value = latLng;
                        controller.mapController.value?.move(latLng, 15);
                      },
                      onMapReady: () {
                        // Auto-get location when map is created
                        if (controller.currentLocation.value == null) {
                          controller.getCurrentLocation();
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.guyanacentral.www',
                      ),
                      Obx(() => controller.currentLocation.value != null
                        ? MarkerLayer(
                          markers: [
                            Marker(
                              point: controller.currentLocation.value!,
                              width: 40,
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.location_on_rounded,
                                  color: cs.onPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                        : const SizedBox.shrink()),
                    ],
                  ),
                  // Loading indicator
                  if (controller.isLoadingLocation.value)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),
                  // Get current location button
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Material(
                      color: Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () => controller.getCurrentLocation(),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.my_location,
                            color: cs.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Tap the map to set location, or tap the button to get your current location",
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontSize: 11,
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
        Obx(() {
          // Only show phone number field if contact method is call
          if (controller.contactMethod.value == ContactMethod.chat) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
            ],
          );
        }),
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
  final List<BrowseCategoryVM> categories;

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
        childAspectRatio: 0.82,
      ),
      itemBuilder: (_, i) {
        final BrowseCategoryVM cat = categories[i];
        final active = i == selected;
        final isDark = theme.brightness == Brightness.dark;

        return InkWell(
          onTap: () => onTap(i),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: active ? cs.primary.withOpacity(.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: active ? cs.primary.withOpacity(.25) : cs.outlineVariant.withOpacity(.7),
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.9)
                        : cat.tint,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      if (!isDark && active)
                        BoxShadow(
                          color: cat.tint.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: cat.assetImage != null
                      ? Image.asset(
                          cat.assetImage!,
                          fit: BoxFit.contain,
                        )
                      : Icon(
                          cat.icon ?? Icons.category_outlined,
                          size: 20,
                          color: isDark ? Colors.black87 : cs.onSurface,
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                    color: active ? cs.primary : cs.onSurface.withOpacity(.65),
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

class _TransmissionPill extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _TransmissionPill({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.surface,
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
            color: active ? Colors.white : cs.onSurface.withOpacity(.7),
          ),
        ),
      ),
    );
  }
}

class _FuelPill extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _FuelPill({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.surface,
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
            color: active ? Colors.white : cs.onSurface.withOpacity(.7),
          ),
        ),
      ),
    );
  }
}


class _DropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface.withOpacity(.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : null,
              hint: Text(hint, style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(.5))),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: cs.onSurface.withOpacity(.4)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: theme.textTheme.bodyMedium),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _JobPill extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _JobPill({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: active ? cs.primary : cs.outlineVariant,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: active ? cs.onPrimary : cs.onSurface.withOpacity(.75),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
