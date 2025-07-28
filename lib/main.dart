import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define our custom color scheme based on the PRD
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF0A4D87), // Deep Blue
      onPrimary: Colors.white,
      secondary: const Color(0xFF1A8C8E), // Teal
      onSecondary: Colors.white,
      tertiary: const Color(0xFF78B7E7), // Sky Blue
      onTertiary: Colors.black,
      error: Colors.red.shade700,
      onError: Colors.white,
      background: Colors.white,
      onBackground: const Color(0xFF0A1E34), // Dark Blue
      surface: Colors.white,
      onSurface: const Color(0xFF0A1E34), // Dark Blue
    );

    // Add elevated button theme to use our warm orange accent color
    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEB8E3E), // Warm Orange accent
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    return MaterialApp(
      title: 'EduKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        elevatedButtonTheme: elevatedButtonTheme,

        // Use Inter font family as specified in the PRD
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.light().textTheme.copyWith(
            headlineLarge: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              letterSpacing: -0.5,
            ),
            headlineMedium: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
            headlineSmall: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
            bodyLarge: const TextStyle(fontSize: 16, height: 1.5),
            bodyMedium: const TextStyle(fontSize: 16, height: 1.5),
            bodySmall: const TextStyle(fontSize: 14),
            labelLarge: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),

        // Bottom navigation bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Colors.grey.shade600,
        ),
      ),
      // Set SplashScreen as the initial screen
      home: const SplashScreen(),
    );
  }
}
