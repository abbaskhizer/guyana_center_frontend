import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthService extends GetxService {
  static FirebaseAuthService get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize Firebase Auth state listener
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // User signed out - but we keep local token until explicitly logged out
      }
    });
  }

  /// Sign in with Google - returns ID token for backend verification
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        isLoading.value = false;
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user == null) {
        isLoading.value = false;
        return {'error': 'Google sign-in failed'};
      }

      // Get the ID token from Firebase for backend verification
      final String? idToken = await user.getIdToken(true); // force refresh to get fresh token

      isLoading.value = false;

      return {
        'idToken': idToken,
        'email': user.email,
        'name': user.displayName,
        'photoURL': user.photoURL,
        'uid': user.uid,
      };
    } catch (e) {
      isLoading.value = false;
      print('Google Sign-In Error: $e');
      return {'error': _getErrorMessage(e)};
    }
  }

  /// Sign out from Google and Firebase
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }

  /// Handle Google Sign-In for login/signup
  Future<void> handleGoogleSignIn() async {
    final result = await signInWithGoogle();

    if (result == null) {
      // User cancelled
      return;
    }

    if (result.containsKey('error')) {
      Get.snackbar('Error', result['error']);
      return;
    }

    // Send ID token to backend for verification and user creation/login
    final backendResponse =
        await ApiService.googleAuth(result['idToken'], result['email'],
            name: result['name'], photoURL: result['photoURL']);

    if (backendResponse != null &&
        backendResponse.containsKey('accessToken')) {
      final userData = backendResponse['user'] as Map<String, dynamic>?;
      print('Backend response user data: $userData');
      await AuthService.to.onLoginSuccess(
        backendResponse['accessToken'],
        result['email'],
        id: userData?['id'] ?? userData?['userId'],
        name: userData?['name'] ?? result['name'],
        phone: userData?['phone'],
        verified: true, // Google users are pre-verified
        loginMethod: 'google',
      );
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Error',
          backendResponse?['message'] ?? 'Google authentication failed');
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'account-exists-with-different-credential':
          return 'An account already exists with this email';
        case 'invalid-credential':
          return 'Invalid credentials';
        case 'operation-not-allowed':
          return 'Google Sign-In is not enabled';
        case 'user-disabled':
          return 'This user has been disabled';
        default:
          return error.message ?? 'Authentication failed';
      }
    }
    return 'Google Sign-In failed';
  }

  /// Sign in with Facebook - returns ID token for backend verification
  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      isLoading.value = true;

      // Trigger the Facebook Sign-In flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.cancelled) {
        isLoading.value = false;
        return null;
      }

      if (loginResult.status != LoginStatus.success) {
        isLoading.value = false;
        return {'error': 'Facebook sign-in cancelled or failed'};
      }

      final accessToken = loginResult.accessToken;
      if (accessToken == null) {
        isLoading.value = false;
        return {'error': 'Failed to get Facebook access token'};
      }

      // Create a Facebook credential
      final credential = FacebookAuthProvider.credential(accessToken.tokenString);

      // Sign in to Firebase with Facebook credentials
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user == null) {
        isLoading.value = false;
        return {'error': 'Facebook sign-in failed'};
      }

      // Get the ID token from Firebase for backend verification
      final String? idToken = await user.getIdToken(true); // force refresh to get fresh token

      // Get user data from Facebook
      final userData = await FacebookAuth.instance.getUserData();

      isLoading.value = false;

      return {
        'idToken': idToken,
        'email': user.email,
        'name': user.displayName ?? userData['name'],
        'photoURL': user.photoURL ?? userData['picture']?['data']?['url'],
        'uid': user.uid,
      };
    } catch (e) {
      isLoading.value = false;
      print('Facebook Sign-In Error: $e');
      return {'error': 'Facebook Sign-In failed'};
    }
  }

  /// Handle Facebook Sign-In for login/signup
  Future<void> handleFacebookSignIn() async {
    final result = await signInWithFacebook();

    if (result == null) {
      // User cancelled
      return;
    }

    if (result.containsKey('error')) {
      Get.snackbar('Error', result['error']);
      return;
    }

    // Send ID token to backend for verification and user creation/login
    final backendResponse =
        await ApiService.facebookAuth(result['idToken'], result['email'],
            name: result['name'], photoURL: result['photoURL']);

    if (backendResponse != null &&
        backendResponse.containsKey('accessToken')) {
      final userData = backendResponse['user'] as Map<String, dynamic>?;
      print('Backend response user data: $userData');
      await AuthService.to.onLoginSuccess(
        backendResponse['accessToken'],
        result['email'],
        id: userData?['id'] ?? userData?['userId'],
        name: userData?['name'] ?? result['name'],
        phone: userData?['phone'],
        verified: true, // Facebook users are pre-verified
        loginMethod: 'facebook',
      );
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Error',
          backendResponse?['message'] ?? 'Facebook authentication failed');
    }
  }
}
