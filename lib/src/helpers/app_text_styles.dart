import 'package:flutter/material.dart';
import 'package:skeleton_core/src/helpers/ui_constants.dart';
import 'package:skeleton_core/src/helpers/extension.dart';
import 'package:skeleton_core/src/config/skeleton_config.dart';

/// Centralized TextStyle system for the app
///
/// This class provides static TextStyle constants based on Material Design 3.
/// All text styles are theme-aware and adapt to seasonal themes automatically.
///
/// **Usage Rules:**
/// - Use static methods that take BuildContext to access theme colors
/// - NO copyWith allowed in application code
/// - For customization, use factory methods or define new static variants
///
/// **Examples:**
/// ```dart
/// Text('Title', style: AppTextStyles.displaySmall(context))
/// Text('Body', style: AppTextStyles.bodyLarge(context))
/// Text('Challenge', style: AppTextStyles.forChallenge(5, context))
/// ```
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  static Color _getColor(BuildContext context, Color defaultColor, Color? backgroundColor) {
    return backgroundColor != null ? backgroundColor.getSmartColor(context) : defaultColor;
  }

  // ============================================================================
  // DISPLAY STYLES - Extra large text for prominent UI elements
  // ============================================================================

  /// Extra large display text (for game challenges, main numbers)
  /// Font: Inter, Weight: 900, Italic
  static TextStyle displayLarge(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
          fontFamily: SkeletonConfig.primaryFontFamily ?? "Inter",
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  /// Medium display text
  /// Font: Inter, Weight: Bold
  static TextStyle displayMedium(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          fontFamily: SkeletonConfig.primaryFontFamily ?? "Inter",
          fontWeight: FontWeight.bold,
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  /// Small display text (screen titles)
  /// Font: Theme default, Weight: Bold
  static TextStyle displaySmall(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  /// Display small bold
  static TextStyle displaySmallBold(BuildContext context, [Color? backgroundColor]) {
    return displaySmall(context, backgroundColor).copyWith(fontWeight: FontWeight.bold);
  }

  /// Display small with text shadow (for title screens)
  static TextStyle displaySmallWithShadow(BuildContext context, [Color? backgroundColor]) {
    final color = _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor);
    return displaySmall(context, backgroundColor).copyWith(
      shadows: [
        BoxShadow(
          color:
              color.computeLuminance() > 0.5
                  ? Colors.black.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.6),
          blurRadius: 10,
          offset: const Offset(-2, 4),
        ),
      ],
    );
  }

  /// Display small with italic style
  static TextStyle displaySmallItalic(BuildContext context, [Color? backgroundColor]) {
    return displaySmall(context, backgroundColor).copyWith(fontStyle: FontStyle.italic);
  }

  /// Display small with shadow and italic (title screen style)
  static TextStyle displaySmallTitleScreen(BuildContext context, [Color? backgroundColor]) {
    final color = _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor);
    return displaySmall(context, backgroundColor).copyWith(
      fontStyle: FontStyle.italic,
      shadows: [
        BoxShadow(
          color:
              color.computeLuminance() > 0.5
                  ? Colors.black.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.6),
          blurRadius: 10,
          offset: const Offset(-2, 4),
        ),
      ],
    );
  }

  // ============================================================================
  // HEADLINE STYLES
  // ============================================================================

  static TextStyle headlineLarge(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle headlineMedium(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle headlineSmall(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  // ============================================================================
  // TITLE STYLES
  // ============================================================================

  static TextStyle titleLarge(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w600,
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle titleLargeWithShadow(BuildContext context, [Color? backgroundColor]) {
    return titleLarge(context, backgroundColor).copyWith(
      shadows: [
        const BoxShadow(
          color: Colors.black54,
          blurRadius: 0,
          offset: Offset(-2, 4),
        ),
      ],
    );
  }

  static TextStyle titleLargeItalic(BuildContext context, [Color? backgroundColor]) {
    return titleLarge(context, backgroundColor).copyWith(fontStyle: FontStyle.italic);
  }

  static TextStyle titleMedium(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle titleMediumBold(BuildContext context, [Color? backgroundColor]) {
    return titleMedium(context, backgroundColor).copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle titleSmall(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle titleSmallBold(BuildContext context, [Color? backgroundColor]) {
    return titleSmall(context, backgroundColor).copyWith(fontWeight: FontWeight.bold);
  }

  // ============================================================================
  // BODY STYLES
  // ============================================================================

  static TextStyle bodyLarge(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle bodyLargeBold(BuildContext context, [Color? backgroundColor]) {
    return bodyLarge(context, backgroundColor).copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle bodyLargeMedium(BuildContext context, [Color? backgroundColor]) {
    return bodyLarge(context, backgroundColor).copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle bodyLargeOnDialogBackground(BuildContext context, [Color? backgroundColor]) {
    return bodyLarge(
      context,
      backgroundColor,
    ).copyWith(color: _getColor(context, Theme.of(context).colorScheme.primary.getDarker(), backgroundColor));
  }

  static TextStyle bodyLargeBoldOnDialogBackground(BuildContext context, [Color? backgroundColor]) {
    return bodyLargeBold(
      context,
      backgroundColor,
    ).copyWith(color: _getColor(context, Theme.of(context).colorScheme.primary.getDarker(), backgroundColor));
  }

  static TextStyle bodyMedium(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle bodyMediumBold(BuildContext context, [Color? backgroundColor]) {
    return bodyMedium(context, backgroundColor).copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle bodyMediumSecondary(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onSurfaceVariant, backgroundColor),
        );
  }

  static TextStyle bodyMediumLight(BuildContext context, [Color? backgroundColor]) {
    return bodyMedium(context, backgroundColor).copyWith(color: _getColor(context, Colors.white70, backgroundColor));
  }

  static TextStyle bodySmall(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle bodySmallHint(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onSurfaceVariant, backgroundColor),
        );
  }

  static TextStyle bodySmallSecondary(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onSurfaceVariant, backgroundColor),
        );
  }

  // ============================================================================
  // LABEL STYLES
  // ============================================================================

  static TextStyle labelLarge(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle labelMedium(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  static TextStyle labelSmallLight(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          color: _getColor(context, Colors.white, backgroundColor),
        );
  }

  // ============================================================================
  // SPECIALIZED STYLES
  // ============================================================================

  static TextStyle handwriting(BuildContext context, [Color? backgroundColor]) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
          fontFamily: SkeletonConfig.handwritingFontFamily ?? "Dancing Script",
          color: _getColor(context, Theme.of(context).colorScheme.onPrimary, backgroundColor),
        );
  }

  // ============================================================================
  // FACTORY METHODS
  // ============================================================================

  static TextStyle withColor(TextStyle base, Color color) {
    return base.copyWith(color: color);
  }

  static TextStyle withFontFamily(TextStyle base, String fontFamily) {
    return base.copyWith(fontFamily: fontFamily);
  }

  /// Get appropriate text style for game challenge display
  static TextStyle forChallenge(int characterCount, BuildContext context, [Color? backgroundColor]) {
    double fontSize;

    if (characterCount >= 10) {
      fontSize = kFontSizeXL;
    } else if (characterCount >= 8) {
      fontSize = kFontSize2XL;
    } else if (characterCount >= 6) {
      fontSize = kFontSize3XL;
    } else if (characterCount >= 4) {
      fontSize = kFontSize4XL;
    } else {
      fontSize = 50;
    }

    return displayLarge(context, backgroundColor).copyWith(fontSize: fontSize);
  }

  static TextStyle forCountdown(BuildContext context, [Color? backgroundColor]) {
    return displaySmallItalic(context, backgroundColor).copyWith(
      fontSize: kFontSize3XL,
      fontWeight: FontWeight.bold,
      color: _getColor(context, Theme.of(context).scaffoldBackgroundColor, backgroundColor),
    );
  }

  static TextStyle forCountdownReady(BuildContext context, [Color? backgroundColor]) {
    return titleLargeItalic(context, backgroundColor).copyWith(
      fontSize: kFontSizeM,
      fontWeight: FontWeight.bold,
      color: _getColor(context, Theme.of(context).scaffoldBackgroundColor, backgroundColor),
    );
  }

  static TextStyle forCountdownGo(BuildContext context, [Color? backgroundColor]) {
    return titleLargeItalic(context, backgroundColor).copyWith(
      fontSize: kFontSize2XL,
      fontWeight: FontWeight.bold,
      color: _getColor(context, Theme.of(context).scaffoldBackgroundColor, backgroundColor),
    );
  }
}
