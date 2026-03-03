import 'package:flutter/material.dart';
import 'package:skeleton_core/src/helpers/ui_constants.dart';
import 'package:skeleton_core/src/helpers/extension.dart';

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

  // ============================================================================
  // DISPLAY STYLES - Extra large text for prominent UI elements
  // ============================================================================

  /// Extra large display text (for game challenges, main numbers)
  /// Font: Inter, Weight: 900, Italic
  static TextStyle displayLarge(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
          fontFamily: "Inter",
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  /// Medium display text
  /// Font: Inter, Weight: Bold
  static TextStyle displayMedium(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          fontFamily: "Inter",
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  /// Small display text (screen titles)
  /// Font: Theme default, Weight: Bold
  static TextStyle displaySmall(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  /// Display small with text shadow (for title screens)
  static TextStyle displaySmallWithShadow(BuildContext context) {
    return displaySmall(context).copyWith(
      shadows: [
        BoxShadow(
          color:
              Theme.of(context).colorScheme.onPrimary.computeLuminance() > 0.5
                  ? Colors.black.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.6),
          blurRadius: 10,
          offset: const Offset(-2, 4),
        ),
      ],
    );
  }

  /// Display small with italic style
  static TextStyle displaySmallItalic(BuildContext context) {
    return displaySmall(context).copyWith(fontStyle: FontStyle.italic);
  }

  /// Display small with shadow and italic (title screen style)
  static TextStyle displaySmallTitleScreen(BuildContext context) {
    return displaySmall(context).copyWith(
      fontStyle: FontStyle.italic,
      shadows: [
        BoxShadow(
          color:
              Theme.of(context).colorScheme.onPrimary.computeLuminance() > 0.5
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

  static TextStyle headlineLarge(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  // ============================================================================
  // TITLE STYLES
  // ============================================================================

  static TextStyle titleLarge(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  static TextStyle titleLargeWithShadow(BuildContext context) {
    return titleLarge(context).copyWith(
      shadows: [
        const BoxShadow(
          color: Colors.black54,
          blurRadius: 0,
          offset: Offset(-2, 4),
        ),
      ],
    );
  }

  static TextStyle titleLargeItalic(BuildContext context) {
    return titleLarge(context).copyWith(fontStyle: FontStyle.italic);
  }

  static TextStyle titleMedium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  static TextStyle titleMediumBold(BuildContext context) {
    return titleMedium(context).copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle titleSmall(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  // ============================================================================
  // BODY STYLES
  // ============================================================================

  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  static TextStyle bodyLargeBold(BuildContext context) {
    return bodyLarge(context).copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle bodyLargeMedium(BuildContext context) {
    return bodyLarge(context).copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle bodyLargeOnDialogBackground(BuildContext context) {
    return bodyLarge(
      context,
    ).copyWith(color: Theme.of(context).colorScheme.primary.getDarker());
  }

  static TextStyle bodyLargeBoldOnDialogBackground(BuildContext context) {
    return bodyLargeBold(
      context,
    ).copyWith(color: Theme.of(context).colorScheme.primary.getDarker());
  }

  static TextStyle bodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  static TextStyle bodyMediumBold(BuildContext context) {
    return bodyMedium(context).copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle bodyMediumSecondary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
  }

  static TextStyle bodyMediumLight(BuildContext context) {
    return bodyMedium(context).copyWith(color: Colors.white70);
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  static TextStyle bodySmallHint(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
  }

  static TextStyle bodySmallSecondary(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
  }

  // ============================================================================
  // LABEL STYLES
  // ============================================================================

  static TextStyle labelLarge(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  static TextStyle labelMedium(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  static TextStyle labelSmallLight(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          color: Colors.white,
          fontSize: kFontSizeXS,
        );
  }

  // ============================================================================
  // SPECIALIZED STYLES
  // ============================================================================

  static TextStyle handwriting(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
          fontFamily: "Dancing Script",
          color: Theme.of(context).colorScheme.onPrimary,
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
  static TextStyle forChallenge(int characterCount, BuildContext context) {
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

    return displayLarge(context).copyWith(fontSize: fontSize);
  }

  static TextStyle forCountdown(BuildContext context) {
    return displaySmallItalic(context).copyWith(
      fontSize: kFontSize3XL,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  static TextStyle forCountdownReady(BuildContext context) {
    return titleLargeItalic(context).copyWith(
      fontSize: kFontSizeM,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  static TextStyle forCountdownGo(BuildContext context) {
    return titleLargeItalic(context).copyWith(
      fontSize: kFontSize2XL,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
