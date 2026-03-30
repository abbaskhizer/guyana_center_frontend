import 'dart:convert';
import 'package:guyana_center_frontend/services/api_services.dart';

class ListingVM {
  final int id;
  final String categoryId;
  final String subType;
  final String title;
  final String description;
  final String price;
  final bool negotiable;
  final String location;
  final String contactPhone;
  final String contactMethod;
  final List<String> images;
  final String condition;
  final String status;
  final String? badge;
  final String timeAgo;
  final int userId;
  final String createdAt;
  final UserData? user;
  final int views;
  final bool favorited;

  // Location coordinates
  final double? latitude;
  final double? longitude;

  // Vehicle specific fields
  final String? brand;
  final String? model;
  final int? year;
  final int? mileage;
  final String? transmission;
  final String? fuelType;

  // Real Estate specific fields
  final String? propertyType;
  final int? bedrooms;
  final int? bathrooms;
  final double? area;
  final bool? furnished;
  final String? parking;
  final bool? gated;
  final bool? tiled;
  final String? ac;
  final bool? ensuite;
  final String? water;
  final String? amenities;
  final String? cupboards;
  final String? village;

  // Jobs specific fields
  final String? jobType;
  final String? experienceLevel;
  final String? salaryPeriod;
  final String? companyName;
  final String? industry;
  final String? currency;

  const ListingVM({
    required this.id,
    required this.categoryId,
    this.subType = "",
    required this.title,
    this.description = "",
    required this.price,
    this.negotiable = false,
    required this.location,
    this.contactPhone = "",
    this.contactMethod = "chat",
    this.images = const [],
    required this.condition,
    this.status = "active",
    this.badge,
    this.timeAgo = "1 day ago",
    required this.userId,
    this.createdAt = "",
    this.user,
    this.brand,
    this.model,
    this.year,
    this.mileage,
    this.transmission,
    this.fuelType,
    this.propertyType,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.furnished,
    this.parking,
    this.gated,
    this.tiled,
    this.ac,
    this.ensuite,
    this.water,
    this.amenities,
    this.cupboards,
    this.village,
    // Jobs
    this.jobType,
    this.experienceLevel,
    this.salaryPeriod,
    this.companyName,
    this.industry,
    this.currency,
    this.views = 0,
    this.favorited = false,
    this.latitude,
    this.longitude,
  });

  factory ListingVM.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['images'] != null) {
      if (json['images'] is List) {
        images = List<String>.from(json['images'].map((e) => e.toString()));
      } else if (json['images'] is String) {
        try {
          final decoded = jsonDecode(json['images']);
          if (decoded is List) {
            images = List<String>.from(decoded.map((e) => e.toString()));
          }
        } catch (_) {}
      }
    }

    // Determine currency symbol
    String currencySymbol = '\$';
    if (json['currency'] == 'TTD') currencySymbol = 'TT\$';
    if (json['currency'] == 'USD') currencySymbol = 'US\$';

    // Parse price to formatted string
    String priceStr = "${currencySymbol}0";
    if (json['price'] != null) {
      final priceNum = json['price'];
      if (priceNum is num) {
        priceStr =
            '$currencySymbol${priceNum.toStringAsFixed(priceNum.truncateToDouble() == priceNum ? 0 : 2)}';
      } else if (priceNum is String) {
        priceStr = priceNum.startsWith('\$') ? priceNum : '$currencySymbol$priceNum';
      }
    }

    // Calculate time ago from createdAt
    String timeAgo = "Just now";
    if (json['createdAt'] != null) {
      try {
        final createdAt = DateTime.parse(json['createdAt']);
        final diff = DateTime.now().difference(createdAt);
        if (diff.inDays > 0) {
          timeAgo = "${diff.inDays}d ago";
        } else if (diff.inHours > 0) {
          timeAgo = "${diff.inHours}h ago";
        } else if (diff.inMinutes > 0) {
          timeAgo = "${diff.inMinutes}m ago";
        }
      } catch (_) {}
    }

    return ListingVM(
      id: json['id'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      subType: _categoryToSubType(json['categoryId'] ?? ''),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: priceStr,
      negotiable: _parseBool(json['negotiable']),
      location: json['location'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      contactMethod: json['contactMethod'] ?? 'chat',
      images: images,
      condition: json['condition'] ?? 'used',
      status: json['status'] ?? 'active',
      badge: null,
      timeAgo: timeAgo,
      userId: json['userId'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      mileage: json['mileage'],
      transmission: json['transmission'],
      fuelType: json['fuelType'],
      propertyType: json['propertyType'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      area: json['area']?.toDouble(),
      furnished: json['furnished'],
      parking: json['parking'],
      gated: json['gated'],
      tiled: json['tiled'],
      ac: json['ac'],
      ensuite: json['ensuite'],
      water: json['water'],
      amenities: json['amenities'],
      cupboards: json['cupboards'],
      village: json['village'],
      jobType: json['jobType'],
      experienceLevel: json['experienceLevel'],
      salaryPeriod: json['salaryPeriod'],
      companyName: json['companyName'],
      industry: json['industry'],
      currency: json['currency'],
      views: json['views'] ?? 0,
      favorited: json['favorited'] ?? false,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  static String _categoryToSubType(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'vehicles':
        return 'Cars for Sale';
      case 'real_estate':
        return 'Properties';
      case 'jobs':
        return 'Job Listings';
      case 'electronics':
        return 'Electronics';
      case 'fashion':
        return 'Fashion Items';
      case 'home_garden':
        return 'Home & Garden';
      case 'sports_hobbies':
        return 'Sports & Hobbies';
      case 'kids':
        return 'Kids Items';
      case 'pets':
        return 'Pets';
      case 'health_beauty':
        return 'Health & Beauty';
      case 'services':
        return 'Services';
      case 'business':
        return 'Business';
      default:
        return 'Other';
    }
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int || value is double) {
      return value == 1;
    }
    return false;
  }

  String get imageUrl {
    if (images.isEmpty) return '';
    final url = images.first;
    if (url.startsWith('http')) return url;
    return '${ApiService.baseUrl}$url';
  }

  bool get isVehicle => categoryId.toLowerCase() == 'vehicles';
  bool get isRealEstate => categoryId.toLowerCase() == 'real_estate';
  bool get isJob => categoryId.toLowerCase() == 'jobs';

  String get vehicleInfo {
    if (!isVehicle) return '';
    final parts = <String>[];
    if (brand != null) parts.add(brand!);
    if (model != null) parts.add(model!);
    if (year != null) parts.add('$year');
    return parts.join(' ');
  }

  String get realEstateInfo {
    if (!isRealEstate) return '';
    final parts = <String>[];
    if (bedrooms != null) parts.add('$bedrooms beds');
    if (bathrooms != null) parts.add('$bathrooms baths');
    if (area != null) parts.add('${area!.toStringAsFixed(0)} sqft');
    if (propertyType != null) parts.add(propertyType!);
    return parts.join('  •  ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'negotiable': negotiable,
      'location': location,
      'contactPhone': contactPhone,
      'contactMethod': contactMethod,
      'images': images,
      'condition': condition,
      'status': status,
      'userId': userId,
      'createdAt': createdAt,
      'brand': brand,
      'model': model,
      'year': year,
      'mileage': mileage,
      'transmission': transmission,
      'fuelType': fuelType,
      'propertyType': propertyType,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'furnished': furnished,
      'parking': parking,
      'gated': gated,
      'tiled': tiled,
      'ac': ac,
      'ensuite': ensuite,
      'water': water,
      'amenities': amenities,
      'cupboards': cupboards,
      'village': village,
      'jobType': jobType,
      'experienceLevel': experienceLevel,
      'salaryPeriod': salaryPeriod,
      'companyName': companyName,
      'industry': industry,
      'currency': currency,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  ListingVM copyWith({
    int? id,
    String? categoryId,
    String? subType,
    String? title,
    String? description,
    String? price,
    bool? negotiable,
    String? location,
    String? contactPhone,
    String? contactMethod,
    List<String>? images,
    String? condition,
    String? status,
    String? badge,
    String? timeAgo,
    int? userId,
    String? createdAt,
    UserData? user,
    int? views,
    bool? favorited,
    double? latitude,
    double? longitude,
    String? brand,
    String? model,
    int? year,
    int? mileage,
    String? transmission,
    String? fuelType,
    String? propertyType,
    int? bedrooms,
    int? bathrooms,
    double? area,
    bool? furnished,
    String? parking,
    bool? gated,
    bool? tiled,
    String? ac,
    bool? ensuite,
    String? water,
    String? amenities,
    String? cupboards,
    String? village,
    String? jobType,
    String? experienceLevel,
    String? salaryPeriod,
    String? companyName,
    String? industry,
    String? currency,
  }) {
    return ListingVM(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      subType: subType ?? this.subType,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      negotiable: negotiable ?? this.negotiable,
      location: location ?? this.location,
      contactPhone: contactPhone ?? this.contactPhone,
      contactMethod: contactMethod ?? this.contactMethod,
      images: images ?? this.images,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      badge: badge ?? this.badge,
      timeAgo: timeAgo ?? this.timeAgo,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      views: views ?? this.views,
      favorited: favorited ?? this.favorited,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      mileage: mileage ?? this.mileage,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      propertyType: propertyType ?? this.propertyType,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      furnished: furnished ?? this.furnished,
      parking: parking ?? this.parking,
      gated: gated ?? this.gated,
      tiled: tiled ?? this.tiled,
      ac: ac ?? this.ac,
      ensuite: ensuite ?? this.ensuite,
      water: water ?? this.water,
      amenities: amenities ?? this.amenities,
      cupboards: cupboards ?? this.cupboards,
      village: village ?? this.village,
      jobType: jobType ?? this.jobType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      currency: currency ?? this.currency,
    );
  }
}

class UserData {
  final int id;
  final String? name;
  final String email;
  final String? phone;
  final String? photoUrl;

  const UserData({
    required this.id,
    this.name,
    required this.email,
    this.phone,
    this.photoUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'],
      email: json['email'] ?? '',
      phone: json['phone'],
      photoUrl: json['photoUrl'] ?? json['photoURL'] ?? json['photo'],
    );
  }
}
