import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/splash_controller.dart';
import 'package:guyana_center_frontend/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => HomeScreen());
      });
      return;
    }

    Get.put(SplashController());
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Image.asset('assets/splash.gif', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
