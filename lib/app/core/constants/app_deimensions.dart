import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* =============================================================================
 * FONT SIZES
============================================================================= */

/// Display Large - 64
const double DISPLAY_LARGE = 64;

/// Display Medium - 48
const double DISPLAY_MEDIUM = 48;

/// Display Small - 36
const double DISPLAY_SMALL = 36;

/// Headline Large - 32
const double HEADLINE_LARGE = 32;

/// Headline Medium - 28
const double HEADLINE_MEDIUM = 28;

/// Headline Small - 24
const double HEADLINE_SMALL = 24;

/// Title Large - 22
const double TITLE_LARGE = 22;

/// Title Medium - 20
const double TITLE_MEDIUM = 20;

/// Title Small - 18
const double TITLE_SMALL = 18;

/// Label Large - 16
const double LABEL_LARGE = 16;

/// Label Medium - 14
const double LABEL_MEDIUM = 14;

/// Label Small - 12
const double LABEL_SMALL = 12;

/// Body Large - 14
const double BODY_LARGE = 14;

/// Body Medium - 12
const double BODY_MEDIUM = 12;

/// Body Small - 10
const double BODY_SMALL = 10;

/* =============================================================================
 * FONT WEIGHTS
============================================================================= */
const FontWeight LIGHT_WEIGHT = FontWeight.normal;
const FontWeight REGULAR_WEIGHT = FontWeight.w400;
const FontWeight MEDIUM_WEIGHT = FontWeight.w500;
const FontWeight SEMI_BOLD_WEIGHT = FontWeight.w600;
const FontWeight BOLD_WEIGHT = FontWeight.bold;

/* =============================================================================
 * FONT FAMILY
============================================================================= */
String get FONT_FAMILY => GoogleFonts.inter().fontFamily ?? '';

/* =============================================================================
 * SPACING
============================================================================= */
const double SPACE_2 = 2;
const double SPACE_4 = 4;
const double SPACE_8 = 8;
const double SPACE_12 = 12;
const double SPACE_16 = 16;
const double SPACE_20 = 20;
const double SPACE_24 = 24;
const double SPACE_32 = 32;
const double SPACE_36 = 36;

/* =============================================================================
 * PADDING
============================================================================= */
const EdgeInsetsDirectional SCREEN_PADDING = EdgeInsetsDirectional.symmetric(
  horizontal: SPACE_16,
  vertical: SPACE_20,
);
