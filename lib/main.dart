import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/splash_screen.dart';
import 'utils/size_config.dart';

const Color kPrimaryColor = Color(0xFF16A34A);
const Color kBackgroundColor = Color(0xFFF8FAFC);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme =
        GoogleFonts.outfitTextTheme(Theme.of(context).textTheme).apply(
          fontFamilyFallback: const ['Noto Sans'],
          bodyColor: const Color(0xFF111827),
          displayColor: const Color(0xFF111827),
        );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guyana Center',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: baseTextTheme,
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        colorScheme:
            ColorScheme.fromSeed(
              seedColor: kPrimaryColor,
              brightness: Brightness.light,
            ).copyWith(
              primary: kPrimaryColor,
              onPrimary: Colors.white,
              background: Colors.white,
              surface: const Color(0xFFF8FAFC),
              outlineVariant: const Color(0xFFE5E7EB),
              onSurface: const Color(0xFF111827),
              onSurfaceVariant: const Color(0xFF9CA3AF),
            ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF111827),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),

        dividerTheme: const DividerThemeData(
          color: Color(0xFFE5E7EB),
          thickness: 1,
          space: 1,
        ),

        cardColor: Colors.white,

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: baseTextTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
          prefixIconColor: const Color(0xFF9CA3AF),
          suffixIconColor: const Color(0xFF9CA3AF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1.4),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(0, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF111827),
            backgroundColor: Colors.white,
            minimumSize: const Size(0, 46),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: const StadiumBorder(),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor,
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),

        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: Color(0xFFD1D5DB)),
        ),

        iconTheme: const IconThemeData(color: Color(0xFF6B7280), size: 22),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        textTheme: baseTextTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        colorScheme:
            ColorScheme.fromSeed(
              seedColor: kPrimaryColor,
              brightness: Brightness.dark,
            ).copyWith(
              primary: kPrimaryColor,
              onPrimary: Colors.white,
              background: Colors.black,
              surface: Colors.black,
              outlineVariant: const Color(0xFF374151),
              onSurface: Colors.white,
              onSurfaceVariant: const Color(0xFF9CA3AF),
            ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),

        dividerTheme: const DividerThemeData(
          color: Color(0xFF374151),
          thickness: 1,
          space: 1,
        ),

        cardColor: Colors.black,

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF6B7280),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: baseTextTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
          prefixIconColor: const Color(0xFF6B7280),
          suffixIconColor: const Color(0xFF6B7280),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1.4),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(0, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF121212),
            minimumSize: const Size(0, 46),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: const StadiumBorder(),
            side: const BorderSide(color: Color(0xFF374151), width: 0),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor,
            textStyle: baseTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),

        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: Color(0xFF6B7280)),
        ),

        iconTheme: const IconThemeData(color: Color(0xFF9CA3AF), size: 22),
      ),

      builder: (context, child) {
        SizeConfig.init(context);
        return child ?? const SizedBox.shrink();
      },
      home: const SplashScreen(),
    );
  }
}
