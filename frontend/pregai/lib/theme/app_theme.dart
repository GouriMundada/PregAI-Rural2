import 'package:flutter/material.dart';

/// Centralized color palette for PregAI.
/// Keep every color reference in the app pointing back to this class
/// so the red/pink/white theme stays perfectly consistent.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFE91E63); // Deep Pink
  static const Color secondary = Color(0xFFFF4081); // Bright Pink
  static const Color accentRed = Color(0xFFD81B60);

  static const Color lightPink = Color(0xFFFFF0F5);
  static const Color veryLightPink = Color(0xFFFFF7FA);

  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF2D2D2D);
  static const Color greyText = Color(0xFF757575);

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color danger = Color(0xFFC62828);

  // Convenience gradient used across headers / splash / hero cards.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient softPinkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [veryLightPink, white],
  );
}

/// Shared radius / spacing constants so every card & button feels
/// consistent across the whole app.
class AppMetrics {
  AppMetrics._();

  static const double cardRadius = 20.0;
  static const double buttonRadius = 16.0;
  static const double chipRadius = 24.0;

  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.danger,
        surface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.veryLightPink,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.darkText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.darkText),
      ),
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(
          color: AppColors.darkText,
          fontWeight: FontWeight.w800,
          fontSize: 28,
        ),
        headlineMedium: const TextStyle(
          color: AppColors.darkText,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        titleLarge: const TextStyle(
          color: AppColors.darkText,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        titleMedium: const TextStyle(
          color: AppColors.darkText,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: const TextStyle(
          color: AppColors.darkText,
          fontSize: 16,
          height: 1.4,
        ),
        bodyMedium: const TextStyle(
          color: AppColors.greyText,
          fontSize: 14,
          height: 1.4,
        ),
        labelLarge: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 3,
        shadowColor: AppColors.primary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.veryLightPink,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppMetrics.spaceM,
          vertical: AppMetrics.spaceM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
          borderSide: const BorderSide(color: AppColors.lightPink, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.8),
        ),
        labelStyle: const TextStyle(color: AppColors.greyText),
        hintStyle: const TextStyle(color: AppColors.greyText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentRed,
          side: const BorderSide(color: AppColors.primary, width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.lightPink,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.darkText),
        secondaryLabelStyle: const TextStyle(color: AppColors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.chipRadius),
          side: BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkText,
        contentTextStyle: const TextStyle(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.buttonRadius),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightPink,
        thickness: 1,
      ),
    );
  }
}
