import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/splash_screen.dart';
import 'utils/size_config.dart';

const Color kPrimaryColor = Color(0xFF109E4B);
const Color kBackgroundColor = Color(0xFFF4F8F8);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.outfitTextTheme(
      Theme.of(context).textTheme,
    ).apply(fontFamilyFallback: const ['Noto Sans']);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guyana Center',
      themeMode: ThemeMode.system, // figma-like: follow system
      theme: ThemeData(
        useMaterial3: true,
        textTheme: baseTextTheme,
        scaffoldBackgroundColor: Colors.white, // figma light bg

        colorScheme:
            ColorScheme.fromSeed(
              seedColor: kPrimaryColor,
              brightness: Brightness.light,
            ).copyWith(
              primary: kPrimaryColor,
              background: Colors.white,
              surface: Color(0xFFF5F5F5),
              outlineVariant: const Color(0xFFD6DAE3), // figma border
              onSurface: const Color(0xFF111827), // figma text
            ),

        appBarTheme: const AppBarTheme(
          backgroundColor: kBackgroundColor,
          foregroundColor: Color(0xFF111827),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: baseTextTheme.bodyMedium?.copyWith(
            color: const Color(0xFFB6BAC5),
          ),
          prefixIconColor: const Color(0xFF9CA3AF),
          suffixIconColor: const Color(0xFF9CA3AF),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD6DAE3), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const StadiumBorder(), // figma pill button
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            side: const BorderSide(color: Color(0xFFD6DAE3)),
            foregroundColor: const Color(0xFF111827),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor,
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        textTheme: baseTextTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0B0C),

        colorScheme:
            ColorScheme.fromSeed(
              seedColor: kPrimaryColor,
              brightness: Brightness.dark,
            ).copyWith(
              primary: kPrimaryColor,
              background: const Color(0xFF0B0B0C),
              surface: const Color(0xFF141416),
              outlineVariant: const Color(0xFF2A2A2E),
              onSurface: Colors.white,
            ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0B0C),
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF141416),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: baseTextTheme.bodyMedium?.copyWith(
            color: const Color(0xFF6C6C6C),
          ),
          prefixIconColor: const Color(0xFF9CA3AF),
          suffixIconColor: const Color(0xFF9CA3AF),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2A2A2E), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            side: const BorderSide(color: Color(0xFF2A2A2E)),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor,
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        cardColor: const Color(0xFF141416),
      ),

      builder: (context, child) {
        SizeConfig.init(context);
        return child ?? const SizedBox.shrink();
      },
      home: const SplashScreen(),
    );
  }
}
