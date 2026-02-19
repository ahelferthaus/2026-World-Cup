import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class AppTheme {
  AppTheme._();

  // The app now uses a dark-first design (like Stadium Live).
  // Both light and dark return the same premium dark theme.
  static ThemeData get light => _stadiumDark;
  static ThemeData get dark => _stadiumDark;

  static ThemeData get _stadiumDark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.lost,
          onPrimary: AppColors.textOnPrimary,
          onSecondary: AppColors.background,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showUnselectedLabels: false,
          showSelectedLabels: true,
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: AppColors.surface,
          selectedIconTheme: IconThemeData(color: AppColors.primary),
          unselectedIconTheme: IconThemeData(color: AppColors.textMuted),
          indicatorColor: AppColors.primaryGlow,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            side: const BorderSide(color: AppColors.divider, width: 1),
          ),
          color: AppColors.surfaceCard,
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          hintStyle: const TextStyle(color: AppColors.textMuted),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceLight,
          labelStyle: const TextStyle(color: AppColors.textPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          dividerColor: AppColors.divider,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 0,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.xl),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceElevated,
          contentTextStyle: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Poppins'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.surfaceLight,
          thumbColor: AppColors.primaryLight,
          overlayColor: AppColors.primaryGlow,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
        listTileTheme: const ListTileThemeData(
          textColor: AppColors.textPrimary,
          iconColor: AppColors.textSecondary,
        ),
      );
}
