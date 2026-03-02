// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/splash_screen.dart';
import 'utils/size_config.dart';

const Color kPrimaryColor = Color(0xFF109E4B);
const Color kBackgroundColor = Color(0xFFF4F8F8);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _lightTheme(BuildContext context) {
    final baseTextTheme = GoogleFonts.outfitTextTheme(
      Theme.of(context).textTheme,
    ).apply(fontFamilyFallback: ['Inter']);

    return ThemeData(
      useMaterial3: true,
      textTheme: baseTextTheme,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: kPrimaryColor,
            brightness: Brightness.light,
          ).copyWith(
            primary: kPrimaryColor,
            background: kBackgroundColor,
            surface: Colors.white,
            outlineVariant: const Color(0xFFD6DAE3),
          ),
      scaffoldBackgroundColor: kBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: kBackgroundColor,
        foregroundColor: kPrimaryColor,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Color(0xFFB6BAC5)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6DAE3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  ThemeData _darkTheme(BuildContext context) {
    final baseTextTheme = GoogleFonts.outfitTextTheme(
      Theme.of(context).textTheme,
    ).apply(fontFamilyFallback: ['Inter']);

    return ThemeData(
      useMaterial3: true,
      textTheme: baseTextTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: kPrimaryColor,
            brightness: Brightness.dark,
          ).copyWith(
            primary: kPrimaryColor,
            background: Colors.black,
            surface: const Color(0xFF1C1C1E),
            outlineVariant: const Color(0xFF2C2C2E),
          ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: kPrimaryColor,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        hintStyle: const TextStyle(color: Color(0xFF6C6C6C)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2C2C2E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GuyanaCentral',
      themeMode: ThemeMode.system,
      theme: _lightTheme(context),
      darkTheme: _darkTheme(context),
      builder: (context, child) {
        SizeConfig.init(context);
        return child!;
      },
      home: const SplashScreen(),
    );
  }
}
