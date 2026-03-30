import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/browse_categoryVM.dart';
import 'package:guyana_center_frontend/controller/bottomNavbar/home_tab_controller.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

enum ContactMethod { chat, call }

enum ItemCondition { brandNew, likeNew, used }

class SellController extends GetxController {
  // steps: 1,2,3
  final step = 1.obs;

  final categories = <BrowseCategoryVM>[].obs;

  final selectedCategory = 0.obs;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final descCount = 0.obs;

  final conditionIndex = 0.obs;
  static const int maxDesc = 500;

  final images = <String>[].obs;
  final priceCtrl = TextEditingController();
  final negotiable = false.obs;

  final _picker = ImagePicker();

  final areas = const [
    "Port of Spain",
    "Chaguanas",
    "San Fernando",
    "Arima",
    "Couva",
    "Cunupia",
  ];
  final selectedArea = "Select your area".obs;

  final phoneCtrl = TextEditingController(text: "");
  final contactMethod = ContactMethod.chat.obs;

  // Map and location fields
  final currentLocation = Rxn<LatLng>();
  final mapController = Rxn<MapController>();
  final isLoadingLocation = false.obs;

  // Vehicle specific fields
  final brandCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final mileageCtrl = TextEditingController();
  final transmission = 'automatic'.obs;
  final fuelType = 'petrol'.obs;

  // Real Estate specific fields
  final propertyType = 'house'.obs;
  final bedroomsCtrl = TextEditingController(text: '3');
  final bathroomsCtrl = TextEditingController(text: '2');
  final areaCtrl = TextEditingController();
  final furnished = false.obs;
  final parking = 'No'.obs;
  final gated = false.obs;
  final tiled = false.obs;
  final ac = 'None'.obs;
  final ensuite = false.obs;
  final waterHot = false.obs;
  final waterCold = false.obs;
  final amenityPool = false.obs;
  final amenityElevator = false.obs;
  final amenityPatio = false.obs;
  final cupboards = 'No'.obs;
  final villageCtrl = TextEditingController();

  // Jobs specific fields
  final jobType = 'full-time'.obs;
  final experienceLevel = 'entry'.obs;
  final salaryPeriod = 'monthly'.obs;
  final companyNameCtrl = TextEditingController();
  final industryCtrl = TextEditingController();
  final currency = 'TTD'.obs;

  // Loading state
  final isLoading = false.obs;

  // Edit mode tracking
  final isEditing = false.obs;
  final editingListingId = RxnInt();

  // Check if selected category is vehicles
  bool get isVehicleCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'vehicles';
  }

  // Check if selected category is real estate
  bool get isRealEstateCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'real_estate';
  }

  // Check if selected category is jobs
  bool get isJobCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'jobs';
  }

  // Check if selected category is electronics
  bool get isElectronicsCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'electronics';
  }

  // Check if selected category is fashion
  bool get isFashionCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'fashion';
  }

  // Check if selected category is home_garden
  bool get isHomeGardenCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'home_garden';
  }

  // Check if selected category is kids
  bool get isKidsCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'kids';
  }

  // Check if selected category is pets
  bool get isPetsCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'pets';
  }

  // Check if selected category is health_beauty
  bool get isHealthBeautyCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'health_beauty';
  }

  // Check if selected category is services
  bool get isServicesCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'services';
  }

  // Check if selected category is business
  bool get isBusinessCategory {
    if (selectedCategory.value >= categories.length) return false;
    return categories[selectedCategory.value].id.toLowerCase() == 'business';
  }

  String get adTitleHint {
    if (selectedCategory.value >= categories.length) return "e.g. Toyota Hilux 2022 Super GL...";
    final catId = categories[selectedCategory.value].id.toLowerCase();
    switch (catId) {
      case 'vehicles':
        return "e.g. Toyota Hilux 2022 Super GL...";
      case 'real_estate':
        return "e.g. 3 Bedroom House for Sale in Georgetown...";
      case 'jobs':
        return "e.g. Senior Software Engineer Wanted...";
      case 'electronics':
        return "e.g. iPhone 15 Pro Max - 256GB - Unlocked...";
      case 'fashion':
        return "e.g. Nike Air Max 270 - Size 10...";
      case 'home_garden':
        return "e.g. L-Shaped Sectional Sofa - Grey Fabric...";
      case 'kids':
        return "e.g. Fisher-Price 4-in-1 Baby Stroller...";
      case 'pets':
        return "e.g. Friendly 2-Month-Old Golden Retriever Puppet...";
      case 'services':
        return "e.g. Professional House Painting & Renovation...";
      case 'business':
        return "e.g. Fully Equipped Restaurant for Sale...";
      case 'health_beauty':
        return "e.g. L'Oréal Revitalift Anti-Aging Serum...";
      default:
        return "e.g. Toyota Hilux 2022 Super GL...";
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize map controller
    mapController.value = MapController();
    
    final homeController = Get.isRegistered<HomeTabController>()
        ? Get.find<HomeTabController>()
        : Get.put(HomeTabController());
    categories.value = homeController.categories
        .where((c) => c.id.toLowerCase() != "all")
        .toList();

    descCtrl.addListener(() {
      final t = descCtrl.text;
      if (t.length > maxDesc) {
        descCtrl.text = t.substring(0, maxDesc);
        descCtrl.selection = TextSelection.collapsed(offset: maxDesc);
      }
      descCount.value = descCtrl.text.length;
    });
  }

  void setStep(int s) {
    final targetStep = s.clamp(1, 3);
    
    // Prevent moving forward if current step is not valid
    if (targetStep > step.value) {
      if (step.value == 1 && !_isStep1Valid()) {
        Get.snackbar(
          "Required Fields",
          "Please fill in title, description, and select a category",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      if (step.value == 2 && !_isStep2Valid()) {
        Get.snackbar(
          "Required Fields",
          "Please add at least one photo",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
    }
    
    step.value = targetStep;
  }

  bool _isStep1Valid() {
    final category = categories[selectedCategory.value];
    if (titleCtrl.text.trim().isEmpty) return false;
    if (descCtrl.text.trim().isEmpty) return false;
    if (category.id == 'all') return false;
    return true;
  }

  bool _isStep2Valid() {
    return images.isNotEmpty;
  }

  void goBack() {
    if (step.value > 1) {
      step.value--;
    } else {
      Get.back();
    }
  }

  void continueNext() {
    if (step.value < 3) {
      // Validate current step before proceeding
      if (step.value == 1 && !_validateStep1()) {
        return;
      }
      if (step.value == 2 && !_validateStep2()) {
        return;
      }
      step.value++;
      return;
    }
    // On step 3, submit the listing
    _submitListing();
  }

  bool _validateStep1() {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter a title for your ad");
      return false;
    }
    if (descCtrl.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter a description");
      return false;
    }

    // Validate vehicle specific fields if category is vehicles
    if (isVehicleCategory) {
      if (brandCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter vehicle brand");
        return false;
      }
      if (modelCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter vehicle model");
        return false;
      }
      if (yearCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter manufacturing year");
        return false;
      }
    }

    // Validate electronics specific fields
    if (isElectronicsCategory) {
      if (brandCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter device brand");
        return false;
      }
      if (modelCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter device model");
        return false;
      }
    }

    // Validate fashion specific fields
    if (isFashionCategory) {
      if (brandCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter brand");
        return false;
      }
    }

    // Validate home_garden specific fields
    if (isHomeGardenCategory) {
      if (brandCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter brand");
        return false;
      }
    }

    // Validate kids specific fields
    if (isKidsCategory) {
      if (brandCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter brand");
        return false;
      }
    }

    // Validate pets specific fields
    if (isPetsCategory) {
      if (brandCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter species or type");
        return false;
      }
    }

    // Validate health_beauty specific fields
    if (isHealthBeautyCategory) {
      if (brandCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter brand");
        return false;
      }
    }

    // Validate services specific fields
    if (isServicesCategory) {
      if (brandCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter service type");
        return false;
      }
    }

    // Validate business specific fields
    if (isBusinessCategory) {
      if (brandCtrl.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter business type");
        return false;
      }
    }

    // Validate real estate specific fields if category is real estate
    if (isRealEstateCategory) {
      if (propertyType.isEmpty) {
        Get.snackbar("Error", "Please select property type");
        return false;
      }
    }

    return true;
  }

  bool _validateStep2() {
    if (priceCtrl.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter a price");
      return false;
    }
    return true;
  }

  Future<void> _submitListing() async {
    // Check if user is authenticated
    final authService = Get.isRegistered<AuthService>()
        ? Get.find<AuthService>()
        : Get.put(AuthService());

    final token = await authService.getToken();
    if (token == null) {
      Get.snackbar("Authentication Required", "Please login to post a listing");
      Get.toNamed('/login');
      return;
    }

    // Validate all fields
    if (!_validateStep1() || !_validateStep2()) {
      return;
    }

    if (selectedArea.value == "Select your area") {
      Get.snackbar("Error", "Please select a location");
      return;
    }

    // Only require phone number if contact method is call
    if (contactMethod.value == ContactMethod.call && phoneCtrl.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter a phone number for phone call contact method");
      return;
    }

    isLoading.value = true;

    try {
      final category = categories[selectedCategory.value];
      final conditionValue = ['new', 'like-new', 'used'][conditionIndex.value];

      print('📝 Creating listing with data:');
      print('  Title: ${titleCtrl.text.trim()}');
      print('  Category: ${category.id}');
      print('  Price: ${priceCtrl.text}');
      print('  Location: ${selectedArea.value}');
      print('  Phone: ${phoneCtrl.text.trim()}');
    print('  Negotiable (sending): ${negotiable.value}');

      // Prepare phone number - empty if chat method
      final phoneNumber = contactMethod.value == ContactMethod.chat
          ? ''
          : phoneCtrl.text.trim();

      final result = isEditing.value
          ? await ApiService.updateListing(
              token: token,
              id: editingListingId.value!,
              title: titleCtrl.text.trim(),
              description: descCtrl.text.trim(),
              price: double.tryParse(priceCtrl.text) ?? 0,
              negotiable: negotiable.value,
              categoryId: category.id,
              condition: conditionValue,
              location: selectedArea.value,
              contactPhone: phoneNumber,
              contactMethod: contactMethod.value == ContactMethod.chat ? 'chat' : 'call',
              imagePaths: images.isEmpty ? null : images.toList(),
              // Category specific
              brand: isVehicleCategory || isElectronicsCategory || isFashionCategory || isHomeGardenCategory || isKidsCategory || isPetsCategory || isHealthBeautyCategory || isServicesCategory || isBusinessCategory ? brandCtrl.text.trim() : null,
              model: isVehicleCategory || isElectronicsCategory || isFashionCategory || isHomeGardenCategory || isKidsCategory || isPetsCategory || isHealthBeautyCategory || isServicesCategory || isBusinessCategory ? modelCtrl.text.trim() : null,
              year: isVehicleCategory ? int.tryParse(yearCtrl.text) : null,
              mileage: isVehicleCategory ? int.tryParse(mileageCtrl.text) : null,
              transmission: isVehicleCategory ? transmission.value : null,
              fuelType: isVehicleCategory ? fuelType.value : null,
              propertyType: isRealEstateCategory ? propertyType.value : null,
              bedrooms: isRealEstateCategory ? int.tryParse(bedroomsCtrl.text) : null,
              bathrooms: isRealEstateCategory ? int.tryParse(bathroomsCtrl.text) : null,
              area: isRealEstateCategory ? double.tryParse(areaCtrl.text) : null,
              furnished: isRealEstateCategory ? furnished.value : null,
              parking: isRealEstateCategory ? parking.value : null,
              gated: isRealEstateCategory ? gated.value : null,
              tiled: isRealEstateCategory ? tiled.value : null,
              ac: isRealEstateCategory ? ac.value : null,
              ensuite: isRealEstateCategory ? ensuite.value : null,
              water: isRealEstateCategory ? jsonEncode({'hot': waterHot.value, 'cold': waterCold.value}) : null,
              amenities: isRealEstateCategory ? jsonEncode({'pool': amenityPool.value, 'elevator': amenityElevator.value, 'patio': amenityPatio.value}) : null,
              cupboards: isRealEstateCategory ? cupboards.value : null,
              village: isRealEstateCategory ? villageCtrl.text.trim() : null,
              jobType: isJobCategory ? jobType.value : null,
              experienceLevel: isJobCategory ? experienceLevel.value : null,
              salaryPeriod: isJobCategory ? salaryPeriod.value : null,
              companyName: isJobCategory ? companyNameCtrl.text.trim() : null,
              industry: isJobCategory ? industryCtrl.text.trim() : null,
              currency: isJobCategory ? currency.value : null,
            )
          : await ApiService.createListing(
              token: token,
              title: titleCtrl.text.trim(),
              description: descCtrl.text.trim(),
              price: double.tryParse(priceCtrl.text) ?? 0,
              negotiable: negotiable.value,
              categoryId: category.id,
              condition: conditionValue,
              location: selectedArea.value,
              contactPhone: phoneNumber,
              contactMethod: contactMethod.value == ContactMethod.chat ? 'chat' : 'call',
              imagePaths: images.isEmpty ? null : images.toList(),
              // Location coordinates
              latitude: currentLocation.value?.latitude,
              longitude: currentLocation.value?.longitude,
              // ... category specific fields (only supported on create now for simplicity, can extend update later)
              brand: isVehicleCategory || isElectronicsCategory || isFashionCategory || isHomeGardenCategory || isKidsCategory || isPetsCategory || isHealthBeautyCategory || isServicesCategory || isBusinessCategory ? brandCtrl.text.trim() : null,
              model: isVehicleCategory || isElectronicsCategory || isFashionCategory || isHomeGardenCategory || isKidsCategory || isPetsCategory || isHealthBeautyCategory || isServicesCategory || isBusinessCategory ? modelCtrl.text.trim() : null,
              year: isVehicleCategory ? int.tryParse(yearCtrl.text) : null,
              mileage: isVehicleCategory ? int.tryParse(mileageCtrl.text) : null,
              transmission: isVehicleCategory ? transmission.value : null,
              fuelType: isVehicleCategory ? fuelType.value : null,
              propertyType: isRealEstateCategory ? propertyType.value : null,
              bedrooms: isRealEstateCategory ? int.tryParse(bedroomsCtrl.text) : null,
              bathrooms: isRealEstateCategory ? int.tryParse(bathroomsCtrl.text) : null,
              area: isRealEstateCategory ? double.tryParse(areaCtrl.text) : null,
              furnished: isRealEstateCategory ? furnished.value : null,
              parking: isRealEstateCategory ? parking.value : null,
              gated: isRealEstateCategory ? gated.value : null,
              tiled: isRealEstateCategory ? tiled.value : null,
              ac: isRealEstateCategory ? ac.value : null,
              ensuite: isRealEstateCategory ? ensuite.value : null,
              water: isRealEstateCategory ? jsonEncode({'hot': waterHot.value, 'cold': waterCold.value}) : null,
              amenities: isRealEstateCategory ? jsonEncode({'pool': amenityPool.value, 'elevator': amenityElevator.value, 'patio': amenityPatio.value}) : null,
              cupboards: isRealEstateCategory ? cupboards.value : null,
              village: isRealEstateCategory ? villageCtrl.text.trim() : null,
              jobType: isJobCategory ? jobType.value : null,
              experienceLevel: isJobCategory ? experienceLevel.value : null,
              salaryPeriod: isJobCategory ? salaryPeriod.value : null,
              companyName: isJobCategory ? companyNameCtrl.text.trim() : null,
              industry: isJobCategory ? industryCtrl.text.trim() : null,
              currency: isJobCategory ? currency.value : null,
            );

      isLoading.value = false;

      if (result != null && result['success'] == true) {
        // 1. Pop back immediately and signal success to the caller
         Get.back(result: true); 

        // 2. Show notification on the previous screen after a small delay to ensure cleanup
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.snackbar(
            "Success",
            isEditing.value ? "Listing updated successfully!" : "Your listing has been posted successfully!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          
          if (Get.isRegistered<HomeTabController>()) {
            Get.find<HomeTabController>().loadFeaturedListings();
          }
          _resetForm(); 
        });
      } else {
        Get.snackbar(
          "Error", 
          result?['message'] ?? "Operation failed", 
          backgroundColor: Colors.red.withOpacity(.1),
          snackPosition: SnackPosition.TOP
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Failed: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(.1),
      );
    }
  }

  void _resetForm() {
    titleCtrl.clear();
    descCtrl.clear();
    priceCtrl.clear();
    phoneCtrl.clear();
    brandCtrl.clear();
    modelCtrl.clear();
    yearCtrl.clear();
    mileageCtrl.clear();
    bedroomsCtrl.text = '3';
    bathroomsCtrl.text = '2';
    areaCtrl.clear();
    images.clear();
    negotiable.value = false;
    furnished.value = false;
    selectedCategory.value = 0;
    conditionIndex.value = 0;
    selectedArea.value = "Select your area";
    contactMethod.value = ContactMethod.chat;
    transmission.value = 'automatic';
    fuelType.value = 'petrol';
    propertyType.value = 'house';
    parking.value = 'No';
    gated.value = false;
    tiled.value = false;
    ac.value = 'None';
    ensuite.value = false;
    waterHot.value = false;
    waterCold.value = false;
    amenityPool.value = false;
    amenityElevator.value = false;
    amenityPatio.value = false;
    cupboards.value = 'No';
    villageCtrl.clear();
    companyNameCtrl.clear();
    industryCtrl.clear();
    jobType.value = 'full-time';
    experienceLevel.value = 'entry';
    salaryPeriod.value = 'monthly';
    currentLocation.value = null;
    step.value = 1;
    isEditing.value = false;
    editingListingId.value = null;
  }

  // Pre-populate form for editing
  void loadListingToEdit(dynamic listing) {
    _resetForm();
    isEditing.value = true;
    editingListingId.value = listing.id;

    titleCtrl.text = listing.title;
    descCtrl.text = listing.description;
    
    // Parse price
    String priceStr = listing.price.toString();
    priceStr = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    priceCtrl.text = priceStr;
    
    negotiable.value = listing.negotiable;
    print('  Negotiable (loaded): ${listing.negotiable}');
    selectedArea.value = listing.location;
    phoneCtrl.text = listing.contactPhone;
    contactMethod.value = (listing.contactMethod == 'chat') ? ContactMethod.chat : ContactMethod.call;
    
    // Find category index
    final catIdx = categories.indexWhere((c) => c.id.toLowerCase() == listing.categoryId.toLowerCase());
    if (catIdx != -1) {
      selectedCategory.value = catIdx;
    }

    // Condition
    final cond = listing.condition.toLowerCase();
    if (cond == 'new') conditionIndex.value = 0;
    else if (cond == 'like-new') conditionIndex.value = 1;
    else conditionIndex.value = 2;

    // images
    images.addAll(listing.images);

    // Specific fields
    if (listing.brand != null) brandCtrl.text = listing.brand!;
    if (listing.model != null) modelCtrl.text = listing.model!;
    if (listing.year != null) yearCtrl.text = listing.year.toString();
    if (listing.mileage != null) mileageCtrl.text = listing.mileage.toString();
    if (listing.transmission != null) transmission.value = listing.transmission!;
    if (listing.fuelType != null) fuelType.value = listing.fuelType!;
    
    if (listing.propertyType != null) propertyType.value = listing.propertyType!;
    if (listing.bedrooms != null) bedroomsCtrl.text = listing.bedrooms.toString();
    if (listing.bathrooms != null) bathroomsCtrl.text = listing.bathrooms.toString();
    if (listing.area != null) areaCtrl.text = listing.area.toString();
    if (listing.furnished != null) furnished.value = listing.furnished!;
    if (listing.parking != null) parking.value = listing.parking!;
    if (listing.gated != null) gated.value = listing.gated!;
    if (listing.tiled != null) tiled.value = listing.tiled!;
    if (listing.ac != null) ac.value = listing.ac!;
    if (listing.ensuite != null) ensuite.value = listing.ensuite!;
    if (listing.cupboards != null) cupboards.value = listing.cupboards!;
    if (listing.village != null) villageCtrl.text = listing.village!;

    if (listing.jobType != null) jobType.value = listing.jobType!;
    if (listing.experienceLevel != null) experienceLevel.value = listing.experienceLevel!;
    if (listing.salaryPeriod != null) salaryPeriod.value = listing.salaryPeriod!;
    if (listing.companyName != null) companyNameCtrl.text = listing.companyName!;
    if (listing.industry != null) industryCtrl.text = listing.industry!;
    if (listing.currency != null) currency.value = listing.currency!;
  }

  void selectCategoryIndex(int i) => selectedCategory.value = i;
  void setCondition(int i) => conditionIndex.value = i.clamp(0, 2);

  Future<void> addPhoto() async {
    if (images.length >= 10) {
      Get.snackbar("Limit Reached", "You can only add up to 10 photos");
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        images.add(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  Future<void> addPhotoFromCamera() async {
    if (images.length >= 10) {
      Get.snackbar("Limit Reached", "You can only add up to 10 photos");
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        images.add(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to take photo: $e");
    }
  }

  void addMockPhoto() {
    // For demo purposes - show picker dialog
    if (kIsWeb) {
      // On web, directly open file picker
      addPhoto();
    } else {
      // On mobile, show bottom sheet with camera/gallery options
      Get.bottomSheet(
        Container(
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Get.back();
                  addPhoto();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Get.back();
                  addPhotoFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text("Cancel"),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      );
    }
  }

  void removePhoto(int i) {
    if (i < 0 || i >= images.length) return;
    images.removeAt(i);
  }

  void setArea(String v) => selectedArea.value = v;
  void setContactMethod(ContactMethod m) => contactMethod.value = m;

  void setTransmission(String v) => transmission.value = v;
  void setFuelType(String v) => fuelType.value = v;
  void setPropertyType(String v) => propertyType.value = v;

  Future<void> getCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          "Location Service Disabled",
          "Please enable location services to use this feature",
          snackPosition: SnackPosition.TOP,
        );
        isLoadingLocation.value = false;
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            "Permission Denied",
            "Location permission is required to show your position",
            snackPosition: SnackPosition.TOP,
          );
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Denied",
          "Please enable location permission in app settings",
          snackPosition: SnackPosition.TOP,
        );
        isLoadingLocation.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLocation.value = LatLng(position.latitude, position.longitude);

      // Move map to current position
      if (mapController.value != null) {
        mapController.value!.move(
          LatLng(position.latitude, position.longitude),
          15,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get location: $e",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void onMapCreated(MapController controller) {
    mapController.value = controller;
    // If location is already available, move camera to it
    if (currentLocation.value != null) {
      controller.move(currentLocation.value!, 15);
    }
  }

  @override
  void onClose() {
    mapController.value?.dispose();
    titleCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    phoneCtrl.dispose();
    brandCtrl.dispose();
    modelCtrl.dispose();
    yearCtrl.dispose();
    mileageCtrl.dispose();
    bedroomsCtrl.dispose();
    bathroomsCtrl.dispose();
    areaCtrl.dispose();
    villageCtrl.dispose();
    companyNameCtrl.dispose();
    industryCtrl.dispose();
    super.onClose();
  }
}
