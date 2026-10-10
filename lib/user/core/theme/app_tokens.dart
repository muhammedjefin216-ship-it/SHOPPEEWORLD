import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTokens {
  AppTokens._();

  // ---------------------------------------------------------------
  // COLORS (dark)
  // ---------------------------------------------------------------
  static const Color background = Color(0xff0B0D0E);
  static const Color surface = Color(0xff141718);
  static const Color border = Color(0xff262B2D);
  static const Color borderStrong = Color(0xff3A4144);

  static const Color textPrimary = Color(0xffF2F4F5);
  static const Color textSecondary = Color(0xff9BA3A7);
  static const Color textTertiary = Color(0xff687074);

  // Single brand accent: Buy now, discount, in-stock status.
  static const Color accent = Color.fromARGB(255, 212, 175, 114);
  static const Color onAccent = Color(0xff0B0D0E);

  // Neutral solid fill for selected chips and similar controls.
  static const Color fill = Color(0xffF2F4F5);
  static const Color onFill = Color(0xff0B0D0E);

  static const Color success = Color(0xff3FB97F);
  static const Color danger = Color(0xffE5645F);

  // Semi-transparent backing for controls placed over images.
  static const Color overlay = Color(0xE60B0D0E);

  // ---------------------------------------------------------------
  // SPACING (8px grid)
  // ---------------------------------------------------------------
  static const double gutter = 16;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;

  // ---------------------------------------------------------------
  // RADIUS
  // ---------------------------------------------------------------
  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusButton = 10;
  static const double radiusLg = 12;
  static const double radiusSheet = 20;

  // ---------------------------------------------------------------
  // TEXT STYLES (Inter)
  // ---------------------------------------------------------------
  static TextStyle get pageTitle => GoogleFonts.inter(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get headline => GoogleFonts.inter(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get sectionTitle => GoogleFonts.inter(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      );

  static TextStyle get price => GoogleFonts.inter(
        color: textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      );

  static TextStyle get bodyStrong => GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get body => GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get caption => GoogleFonts.inter(
        color: textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get overline => GoogleFonts.inter(
        color: textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );
}