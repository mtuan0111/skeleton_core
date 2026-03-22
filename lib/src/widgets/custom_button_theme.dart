import 'package:flutter/material.dart';

/// Data class holding the default visual style for [CustomElevatedButton].
///
/// At minimum, provide a [buttonRenderer] to completely replace the button's
/// visual layers while keeping the press/hit-test shell intact.
class CustomButtonThemeData {
  /// Optional override that completely replaces the visual layers of every
  /// [CustomElevatedButton] in the scope.  Receives the same arguments as
  /// the per-widget `buttonRenderer` parameter, including the resolved
  /// [backgroundColor] and [isPressed] state.
  final Widget Function(
    BuildContext context,
    BorderRadius borderRadius,
    Color backgroundColor,
    Color darkerColor,
    bool isPressed,
  )? buttonRenderer;

  const CustomButtonThemeData({this.buttonRenderer});
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
      data.buttonRenderer != oldWidget.data.buttonRenderer;
}
