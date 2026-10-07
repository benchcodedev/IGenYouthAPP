import 'package:flutter/material.dart';

/// Design tokens & color palette for IGen Youth App.
/// Centralized in a single file for easy rebranding / theme adjustments.
class AppColors {
  AppColors._();

  // Core Brand Colors (Faith Notes reference palette)
  static const Color maroon = Color(0xFF4B1D1D);        // Primary Maroon
  static const Color maroonDark = Color(0xFF2E1010);    // Deep Dark Maroon
  static const Color redAccent = Color(0xFFEE3A35);     // Accent Red / Coral
  static const Color yellowHighlight = Color(0xFFFFC93C); // Highlight Yellow / Gold
  static const Color mauve = Color(0xFF6B4A5A);         // Mauve / Muted Purple
  static const Color softMint = Color(0xFFE6EEF0);      // Soft Mint / Light Grey-Mint
  static const Color softBg = Color(0xFFF3F6F7);        // Soft Background Canvas
  static const Color surfaceWhite = Color(0xFFFFFFFF);  // Pure White Surface

  // Neutral / Grayscale
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderSubtle = Color(0xFFECEFF1);

  // Dark Mode Overrides
  static const Color darkBg = Color(0xFF141212);
  static const Color darkSurface = Color(0xFF1F1B1B);
  static const Color darkSurfaceElevated = Color(0xFF2C2525);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0BEC5);

  // Category Theme Colors for Stacked Category Cards
  static const Color catInfo = maroon;
  static const Color catEvent = redAccent;
  static const Color catKomsel = yellowHighlight;
  static const Color catActivities = mauve;
  static const Color catGallery = maroonDark;

  // Semantic
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);
}
