import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {
  // HTTP Client that bypasses SSL certificate verification (DEV ONLY)
  static http.Client get _client {
    if (kIsWeb) {
      return http.Client();
    }
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }

  // Base URL configuration
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://185.197.194.139';
    }
    // Android emulator uses 10.0.2.2 to access localhost
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://185.197.194.139';
    }
    // iOS and others
    return 'http://185.197.194.139';
  }

  // AUTH ENDPOINTS
  // --------------

  // 1. Signup
  static Future<Map<String, dynamic>?> signup(String email, String password, {String? name}) async {
    try {
      print('🚀 Attempting signup for $email');
      final bodyData = {'email': email, 'password': password};
      if (name != null) bodyData['name'] = name;
      
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      return _handleResponse(response, 'Signup');
    } catch (e) {
      return _handleError(e, 'Signup');
    }
  }

  // 2. Verify OTP
  static Future<Map<String, dynamic>?> verifyOtp(String email, String otp) async {
    try {
      print('🔐 Verifying OTP $otp for $email');
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      return _handleResponse(response, 'OTP Verification');
    } catch (e) {
      return _handleError(e, 'OTP Verification');
    }
  }

  // 3. Forgot Password
  static Future<Map<String, dynamic>?> forgotPassword(String email) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return _handleResponse(response, 'Forgot Password');
    } catch (e) {
      return _handleError(e, 'Forgot Password');
    }
  }

  // 4. Reset Password
  static Future<Map<String, dynamic>?> resetPassword(String email, String otp, String newPassword) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp, 'password': newPassword}),
      );
      return _handleResponse(response, 'Reset Password');
    } catch (e) {
      return _handleError(e, 'Reset Password');
    }
  }

  // 5. Login
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      print('🔑 Logging in user $email');
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      return _handleResponse(response, 'Login');
    } catch (e) {
      return _handleError(e, 'Login');
    }
  }

  // 6. Check Auth Status
  static Future<Map<String, dynamic>?> checkAuthStatus(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return _handleResponse(response, 'Auth Check');
    } catch (e) {
      return _handleError(e, 'Auth Check');
    }
  }

  // 7. Update Profile
  static Future<Map<String, dynamic>?> updateProfile(String token, Map<String, dynamic> data) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      return _handleResponse(response, 'Update Profile');
    } catch (e) {
      return _handleError(e, 'Update Profile');
    }
  }

  // 8. Delete Account
  static Future<Map<String, dynamic>?> deleteAccount(String token) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/auth/delete-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return _handleResponse(response, 'Delete Account');
    } catch (e) {
      return _handleError(e, 'Delete Account');
    }
  }

  // 9. Resend OTP
  static Future<Map<String, dynamic>?> resendOtp(String email) async {
    try {
      print('🔄 Resending OTP for $email');
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      return _handleResponse(response, 'Resend OTP');
    } catch (e) {
      return _handleError(e, 'Resend OTP');
    }
  }

  // 10. Google Authentication
  static Future<Map<String, dynamic>?> googleAuth(
    String idToken,
    String email, {
    String? name,
    String? photoURL,
  }) async {
    try {
      print('🔐 Google auth for $email');
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
          'email': email,
          if (name != null) 'name': name,
          if (photoURL != null) 'photoURL': photoURL,
        }),
      );

      return _handleResponse(response, 'Google Auth');
    } catch (e) {
      return _handleError(e, 'Google Auth');
    }
  }

  // 11. Facebook Authentication
  static Future<Map<String, dynamic>?> facebookAuth(
    String idToken,
    String email, {
    String? name,
    String? photoURL,
  }) async {
    try {
      print('🔐 Facebook auth for $email');
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/facebook'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
          'email': email,
          if (name != null) 'name': name,
          if (photoURL != null) 'photoURL': photoURL,
        }),
      );

      return _handleResponse(response, 'Facebook Auth');
    } catch (e) {
      return _handleError(e, 'Facebook Auth');
    }
  }

  // 12. Upload Profile Photo
  static Future<Map<String, dynamic>?> uploadProfilePhoto(
    String token,
    String imagePath,
  ) async {
    try {
      print('📸 Uploading profile photo from $imagePath');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/auth/upload-profile-photo'),
      );

      // Add auth header
      request.headers['Authorization'] = 'Bearer $token';

      // Add file
      final fileBytes = await File(imagePath).readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'photo',
        fileBytes,
        filename: 'profile_photo.jpg',
      );
      request.files.add(multipartFile);

      // Send request using custom client to bypass SSL verification
      final streamedResponse = await IOClient(HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true).send(request);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, 'Upload Profile Photo');
    } catch (e) {
      return _handleError(e, 'Upload Profile Photo');
    }
  }

  // LISTINGS ENDPOINTS
  // ------------------

  // 1. Create Listing (with image files)
  static Future<Map<String, dynamic>?> createListing({
    required String token,
    required String title,
    required String description,
    required double price,
    required bool negotiable,
    required String categoryId,
    required String condition,
    required String location,
    required String contactPhone,
    required String contactMethod,
    List<String>? imagePaths,
    // Vehicle specific fields
    String? brand,
    String? model,
    int? year,
    int? mileage,
    String? transmission,
    String? fuelType,
    // Real Estate specific fields
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
    // Jobs specific fields
    String? jobType,
    String? experienceLevel,
    String? salaryPeriod,
    String? companyName,
    String? industry,
    String? currency,
    double? latitude,
    double? longitude,
  }) async {
    try {
      print('📝 Creating listing: $title');

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/listings'),
      );

      // Add auth header
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['negotiable'] = negotiable.toString();
      request.fields['categoryId'] = categoryId;
      request.fields['condition'] = condition;
      request.fields['location'] = location;
      request.fields['contactPhone'] = contactPhone;
      request.fields['contactMethod'] = contactMethod;

      // Add vehicle specific fields
      if (brand != null) request.fields['brand'] = brand;
      if (model != null) request.fields['model'] = model;
      if (year != null) request.fields['year'] = year.toString();
      if (mileage != null) request.fields['mileage'] = mileage.toString();
      if (transmission != null) request.fields['transmission'] = transmission;
      if (fuelType != null) request.fields['fuelType'] = fuelType;

      // Add real estate specific fields
      if (propertyType != null) request.fields['propertyType'] = propertyType;
      if (bedrooms != null) request.fields['bedrooms'] = bedrooms.toString();
      if (bathrooms != null) request.fields['bathrooms'] = bathrooms.toString();
      if (area != null) request.fields['area'] = area.toString();
      if (furnished != null) request.fields['furnished'] = furnished.toString();
      if (parking != null) request.fields['parking'] = parking;
      if (gated != null) request.fields['gated'] = gated.toString();
      if (tiled != null) request.fields['tiled'] = tiled.toString();
      if (ac != null) request.fields['ac'] = ac;
      if (ensuite != null) request.fields['ensuite'] = ensuite.toString();
      if (water != null) request.fields['water'] = water;
      if (amenities != null) request.fields['amenities'] = amenities;
      if (cupboards != null) request.fields['cupboards'] = cupboards;
      if (village != null) request.fields['village'] = village;

      // Add jobs specific fields
      if (jobType != null) request.fields['jobType'] = jobType;
      if (experienceLevel != null) request.fields['experienceLevel'] = experienceLevel;
      if (salaryPeriod != null) request.fields['salaryPeriod'] = salaryPeriod;
      if (companyName != null) request.fields['companyName'] = companyName;
      if (industry != null) request.fields['industry'] = industry;
      if (currency != null) request.fields['currency'] = currency;
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();

      // Add image files if provided
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (int i = 0; i < imagePaths.length; i++) {
          final imagePath = imagePaths[i];
          final file = File(imagePath);
          if (await file.exists()) {
            final fileBytes = await file.readAsBytes();
            final mimeType = lookupMimeType(imagePath) ?? 'image/jpeg';
            final multipartFile = http.MultipartFile.fromBytes(
              'images',
              fileBytes,
              filename: 'image_${i}.jpg',
              contentType: MediaType.parse(mimeType),
            );
            request.files.add(multipartFile);
          }
        }
      }

      // Send request using custom client to bypass SSL verification
      final streamedResponse = await IOClient(HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true).send(request);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, 'Create Listing');
    } catch (e) {
      return _handleError(e, 'Create Listing');
    }
  }

  // 2. Get All Listings (with filters)
  static Future<dynamic> getListings({
    String? category,
    String? search,
    String? sort,
    int? page,
    int? pageSize,
    String? token, // Added token for optional auth
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (sort != null) queryParams['sort'] = sort;
      if (page != null) queryParams['page'] = page.toString();
      if (pageSize != null) queryParams['pageSize'] = pageSize.toString();

      final uri = Uri.parse('$baseUrl/listings').replace(queryParameters: queryParams);
      print('📋 Fetching listings from $uri');

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final response = await _client.get(uri, headers: headers);
      return _handleResponse(response, 'Get Listings');
    } catch (e) {
      return _handleError(e, 'Get Listings');
    }
  }

  // 3. Get Listing by ID
  static Future<Map<String, dynamic>?> getListingById(int id, {String? token}) async {
    try {
      print('📋 Fetching listing $id');
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (token != null) headers['Authorization'] = 'Bearer $token';

      final response = await _client.get(Uri.parse('$baseUrl/listings/$id'), headers: headers);
      return _handleResponse(response, 'Get Listing');
    } catch (e) {
      return _handleError(e, 'Get Listing');
    }
  }

  // 4. Get User's Listings
  static Future<Map<String, dynamic>?> getUserListings(int userId) async {
    try {
      print('📋 Fetching listings for user $userId');
      final response = await _client.get(Uri.parse('$baseUrl/listings/user/$userId'));
      return _handleResponse(response, 'Get User Listings');
    } catch (e) {
      return _handleError(e, 'Get User Listings');
    }
  }

  // 4.5 Get Favorite Listings
  static Future<dynamic> getFavorites(String token) async {
    try {
      print('📋 Fetching favorite listings');
      final response = await _client.get(
        Uri.parse('$baseUrl/listings/favorites/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return _handleResponse(response, 'Get Favorites');
    } catch (e) {
      return _handleError(e, 'Get Favorites');
    }
  }

  // 4.6 Toggle Favorite
  static Future<dynamic> toggleFavorite(String token, int listingId) async {
    try {
      print('❤️ Toggling favorite for listing $listingId');
      final response = await _client.post(
        Uri.parse('$baseUrl/listings/$listingId/favorite'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return _handleResponse(response, 'Toggle Favorite');
    } catch (e) {
      return _handleError(e, 'Toggle Favorite');
    }
  }

  // 5. Update Listing
  static Future<Map<String, dynamic>?> updateListing({
    required String token,
    required int id,
    String? title,
    String? description,
    double? price,
    bool? negotiable,
    String? categoryId,
    String? condition,
    String? location,
    String? contactPhone,
    String? contactMethod,
    List<String>? imagePaths,
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
    String? status,
    double? latitude,
    double? longitude,
  }) async {
    try {
      print('✏️ Updating listing $id');

      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl/listings/$id'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add only provided fields
      if (title != null) request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (price != null) request.fields['price'] = price.toString();
      if (negotiable != null) request.fields['negotiable'] = negotiable.toString();
      if (categoryId != null) request.fields['categoryId'] = categoryId;
      if (condition != null) request.fields['condition'] = condition;
      if (location != null) request.fields['location'] = location;
      if (contactPhone != null) request.fields['contactPhone'] = contactPhone;
      if (contactMethod != null) request.fields['contactMethod'] = contactMethod;
      
      // Category specific
      if (brand != null) request.fields['brand'] = brand;
      if (model != null) request.fields['model'] = model;
      if (year != null) request.fields['year'] = year.toString();
      if (mileage != null) request.fields['mileage'] = mileage.toString();
      if (transmission != null) request.fields['transmission'] = transmission;
      if (fuelType != null) request.fields['fuelType'] = fuelType;
      
      if (propertyType != null) request.fields['propertyType'] = propertyType;
      if (bedrooms != null) request.fields['bedrooms'] = bedrooms.toString();
      if (bathrooms != null) request.fields['bathrooms'] = bathrooms.toString();
      if (area != null) request.fields['area'] = area.toString();
      if (furnished != null) request.fields['furnished'] = furnished.toString();
      if (parking != null) request.fields['parking'] = parking;
      if (gated != null) request.fields['gated'] = gated.toString();
      if (tiled != null) request.fields['tiled'] = tiled.toString();
      if (ac != null) request.fields['ac'] = ac;
      if (ensuite != null) request.fields['ensuite'] = ensuite.toString();
      if (water != null) request.fields['water'] = water;
      if (amenities != null) request.fields['amenities'] = amenities;
      if (cupboards != null) request.fields['cupboards'] = cupboards;
      if (village != null) request.fields['village'] = village;

      if (jobType != null) request.fields['jobType'] = jobType;
      if (experienceLevel != null) request.fields['experienceLevel'] = experienceLevel;
      if (salaryPeriod != null) request.fields['salaryPeriod'] = salaryPeriod;
      if (companyName != null) request.fields['companyName'] = companyName;
      if (industry != null) request.fields['industry'] = industry;
      if (currency != null) request.fields['currency'] = currency;
      if (status != null) request.fields['status'] = status;
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();

      // Add image files if provided
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (int i = 0; i < imagePaths.length; i++) {
          final imagePath = imagePaths[i];
          final file = File(imagePath);
          if (await file.exists()) {
            final fileBytes = await file.readAsBytes();
            final mimeType = lookupMimeType(imagePath) ?? 'image/jpeg';
            final multipartFile = http.MultipartFile.fromBytes(
              'images',
              fileBytes,
              filename: 'image_${i}.jpg',
              contentType: MediaType.parse(mimeType),
            );
            request.files.add(multipartFile);
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, 'Update Listing');
    } catch (e) {
      return _handleError(e, 'Update Listing');
    }
  }

  // 6. Delete Listing
  static Future<Map<String, dynamic>?> deleteListing(String token, int id) async {
    try {
      print('🗑️ Deleting listing $id');
      final response = await _client.delete(
        Uri.parse('$baseUrl/listings/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return _handleResponse(response, 'Delete Listing');
    } catch (e) {
      return _handleError(e, 'Delete Listing');
    }
  }

  // RESPONSE HANDLERS
  // -----------------

  static dynamic _handleResponse(http.Response response, String method) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      print('✅ $method successful');
      return data;
    } else {
      final errorData = json.decode(response.body);
      print('❌ $method failed: ${response.statusCode} - ${response.body}');
      // We return the parsed body even on error so controller can show the error message
      return errorData;
    }
  }

  static dynamic _handleError(dynamic e, String method) {
    print('⚠️ Exception during $method: $e');
    
    String message = 'Could not connect to server. Check logs.';
    
    if (e.toString().contains('SocketException')) {
      print('🌐 Network error: Check server connection');
      message = 'Network error. Is the server running?';
    } else if (e.toString().contains('TimeoutException')) {
      print('⏱️ Request timed out');
      message = 'Request timed out.';
    }
    
    return {'message': message};
  }
}
