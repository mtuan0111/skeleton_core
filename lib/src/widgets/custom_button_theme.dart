import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// Data class holding the default visual style for [CustomElevatedButton].
///
/// At minimum, provide a [buttonRenderer] to completely replace the button's
/// visual layers while keeping the press/hit-test shell intact.
class CustomButtonThemeData {
  /// Optional override that completely replaces the visual layers of every
  /// [CustomElevatedButton] in the scope.  Receives the same arguments as
  /// the per-widget `buttonRenderer` parameter, including the resolved
  /// [backgroundColor], [isPressed] state, and [isClickable] (whether
  /// [onPressed] is non-null).
  final Widget Function(
    BuildContext context,
    BorderRadius borderRadius,
    Color backgroundColor,
    Color darkerColor,
    bool isPressed,
    bool isClickable,
    int contentSeed,
  )? buttonRenderer;

  /// Optional default text style for all [CustomElevatedButton] widgets in
  /// the scope.  Per-widget `style` overrides take priority.
  final TextStyle? textStyle;

  /// Optional overlay renderer that is drawn on top of the button's content.
  /// Receives the same arguments as [buttonRenderer].
  final Widget Function(
    BuildContext context,
    BorderRadius borderRadius,
    Color backgroundColor,
    Color darkerColor,
    bool isPressed,
    bool isClickable,
    int contentSeed,
  )? overlayBuilder;

  // Dialog-specific defaults for AlertTemplate
  final Color? dialogBackgroundColor;
  final Color? dialogTitleBackgroundColor;
  final RoundedWithShapeAt? dialogTitleShapeAt;
  final Widget Function(BuildContext context, Widget child)? dialogBodyWrapper;

  const CustomButtonThemeData({
    this.buttonRenderer,
    this.textStyle,
    this.overlayBuilder,
    this.dialogBackgroundColor,
    this.dialogTitleBackgroundColor,
    this.dialogTitleShapeAt,
    this.dialogBodyWrapper,
  });
}

/// An [InheritedWidget] that configures the default style for all
/// [CustomElevatedButton] widgets in the subtree.
///
/// Usage:
/// ```dart
/// CustomButtonTheme(
///   data: CustomButtonThemeData(
///     buttonRenderer: (ctx, br, bg, darker, pressed) => ...,
///   ),
///   child: MyApp(),
/// )
/// ```
///
/// [CustomElevatedButton] reads this via [CustomButtonTheme.of] and uses its
/// renderer if no local `buttonRenderer` is provided on the widget itself.
class CustomButtonTheme extends InheritedWidget {
  final CustomButtonThemeData data;

  const CustomButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Returns the nearest [CustomButtonThemeData] in the tree, or `null` if
  /// none is provided.
  static CustomButtonThemeData? of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<CustomButtonTheme>();
    return widget?.data;
  }

  @override
  bool updateShouldNotify(CustomButtonTheme oldWidget) =>
      data.buttonRenderer != oldWidget.data.buttonRenderer ||
      data.textStyle != oldWidget.data.textStyle ||
      data.overlayBuilder != oldWidget.data.overlayBuilder ||
      data.dialogBackgroundColor != oldWidget.data.dialogBackgroundColor ||
      data.dialogTitleBackgroundColor !=
          oldWidget.data.dialogTitleBackgroundColor ||
      data.dialogTitleShapeAt != oldWidget.data.dialogTitleShapeAt ||
      data.dialogBodyWrapper != oldWidget.data.dialogBodyWrapper;
}
