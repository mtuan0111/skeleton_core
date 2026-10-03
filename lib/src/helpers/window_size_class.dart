import 'package:flutter/widgets.dart';

/// Material 3 window size classes, keyed off the *current window* size
/// ([MediaQuery.sizeOf]) rather than the device. Unlike [ResponsiveContext]'s
/// `isTablet` (shortestSide >= 600), these follow the window as it changes:
/// a Galaxy Fold's cover vs. inner screen, a Flip's cover screen, Android
/// split-screen, iPad Split View / Stage Manager, and each pane of a
/// [HingeSplit] (which gives every pane its own [MediaQuery] size).
enum WindowSizeClass { compact, medium, expanded }

/// Window widths at or above this are [WindowSizeClass.medium].
const double kWindowMediumWidth = 600.0;

/// Window widths at or above this are [WindowSizeClass.expanded].
const double kWindowExpandedWidth = 840.0;

/// Window heights at or above this are [WindowSizeClass.medium] — below it
/// is a phone in landscape, a Flip's cover screen, or half of a foldable in
/// tabletop posture.
const double kWindowMediumHeight = 480.0;

/// Window heights at or above this are [WindowSizeClass.expanded].
const double kWindowExpandedHeight = 900.0;

extension WindowSizeClassContext on BuildContext {
  WindowSizeClass get windowWidthClass {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= kWindowExpandedWidth) return WindowSizeClass.expanded;
    if (width >= kWindowMediumWidth) return WindowSizeClass.medium;
    return WindowSizeClass.compact;
  }

  WindowSizeClass get windowHeightClass {
    final height = MediaQuery.sizeOf(this).height;
    if (height >= kWindowExpandedHeight) return WindowSizeClass.expanded;
    if (height >= kWindowMediumHeight) return WindowSizeClass.medium;
    return WindowSizeClass.compact;
  }

  /// A window too short for stacked chrome: collapse toolbars, shrink
  /// controls, prefer side-by-side over top-to-bottom.
  bool get isHeightCompact => windowHeightClass == WindowSizeClass.compact;
}
