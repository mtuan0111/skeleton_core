import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';

typedef InputWrapperBuilder = Widget Function(
    BuildContext context, Widget child,
    {EdgeInsetsGeometry? customPadding});
typedef InputDecorationBuilder = InputDecoration Function(
    BuildContext context, String? hintText);
typedef ValueWrapperBuilder = Widget Function(
    BuildContext context, Widget child);
typedef InputTextStyleBuilder = TextStyle Function(BuildContext context);
typedef SliderThemeBuilder = SliderThemeData Function(BuildContext context);
typedef SwitchThemeBuilder = SwitchThemeData Function(BuildContext context);
typedef SegmentedButtonThemeBuilder = SegmentedButtonThemeData Function(
    BuildContext context);
typedef SettingContainerBuilder = Widget Function(
  BuildContext context,
  Widget child,
  BorderRadius borderRadius,
  String title,
  dynamic icon,
);
typedef RankingDecorationBuilder = Widget Function(
    BuildContext context, int position);
typedef RankingCenterBuilder = Widget Function(
    BuildContext context, int position, Widget? childElement);
typedef SliverAppBarBackgroundBuilder = Widget Function(
    BuildContext context, bool isCollapsed);

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

  /// Optional builder to wrap input fields (e.g. TextFormField) in a custom container.
  final InputWrapperBuilder? inputWrapperBuilder;

  /// Optional builder to customize the InputDecoration for fields.
  final InputDecorationBuilder? inputDecorationBuilder;

  /// Optional builder to wrap value displays in a custom container.
  final ValueWrapperBuilder? valueWrapperBuilder;

  /// Optional builder to provide text style for input fields.
  final InputTextStyleBuilder? inputTextStyleBuilder;

  /// Optional builder to provide a custom SliderThemeData.
  final SliderThemeBuilder? sliderThemeBuilder;

  /// Optional builder to provide a custom SwitchThemeData.
  final SwitchThemeBuilder? switchThemeBuilder;

  /// Optional builder to provide a custom SegmentedButtonThemeData.
  final SegmentedButtonThemeBuilder? segmentedButtonThemeBuilder;

  /// Optional builder to customise the appearance of each setting's container.
  final SettingContainerBuilder? settingContainerBuilder;

  /// Optional builder to customise the outer decoration of the ranking sorting widget.
  final RankingDecorationBuilder? rankingDecorationBuilder;

  /// Optional builder to customise the center widget of the ranking sorting widget.
  final RankingCenterBuilder? rankingCenterBuilder;

  /// Optional global background builder for every [CustomSliverAppBar] in the tree.
  ///
  /// Receives [isCollapsed] so the background can adapt when the app bar
  /// collapses. When `null` the default animated solid-colour behaviour is used.
  final SliverAppBarBackgroundBuilder? sliverAppBarBackgroundBuilder;

  const CustomButtonThemeData({
    this.buttonRenderer,
    this.textStyle,
    this.overlayBuilder,
    this.dialogBackgroundColor,
    this.dialogTitleBackgroundColor,
    this.dialogTitleShapeAt,
    this.dialogBodyWrapper,
    this.inputWrapperBuilder,
    this.inputDecorationBuilder,
    this.valueWrapperBuilder,
    this.inputTextStyleBuilder,
    this.sliderThemeBuilder,
    this.switchThemeBuilder,
    this.segmentedButtonThemeBuilder,
    this.settingContainerBuilder,
    this.rankingDecorationBuilder,
    this.rankingCenterBuilder,
    this.sliverAppBarBackgroundBuilder,
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

  /// Global fallback for wrapping input fields (e.g. TextFormField).
  /// Used if no [CustomButtonTheme] is found in the tree, or if the
  /// theme's [CustomButtonThemeData.inputWrapperBuilder] is null.
  static InputWrapperBuilder? defaultInputWrapperBuilder;

  /// Global fallback for wrapping setting items.
  /// Used if no [CustomButtonTheme] is found in the tree, or if the
  /// theme's [CustomButtonThemeData.settingContainerBuilder] is null.
  static SettingContainerBuilder? defaultSettingContainerBuilder;

  @override
  bool updateShouldNotify(CustomButtonTheme oldWidget) =>
      data.buttonRenderer != oldWidget.data.buttonRenderer ||
      data.textStyle != oldWidget.data.textStyle ||
      data.overlayBuilder != oldWidget.data.overlayBuilder ||
      data.dialogBackgroundColor != oldWidget.data.dialogBackgroundColor ||
      data.dialogTitleBackgroundColor !=
          oldWidget.data.dialogTitleBackgroundColor ||
      data.dialogTitleShapeAt != oldWidget.data.dialogTitleShapeAt ||
      data.dialogBodyWrapper != oldWidget.data.dialogBodyWrapper ||
      data.inputWrapperBuilder != oldWidget.data.inputWrapperBuilder ||
      data.inputDecorationBuilder != oldWidget.data.inputDecorationBuilder ||
      data.valueWrapperBuilder != oldWidget.data.valueWrapperBuilder ||
      data.inputTextStyleBuilder != oldWidget.data.inputTextStyleBuilder ||
      data.sliderThemeBuilder != oldWidget.data.sliderThemeBuilder ||
      data.switchThemeBuilder != oldWidget.data.switchThemeBuilder ||
      data.segmentedButtonThemeBuilder !=
          oldWidget.data.segmentedButtonThemeBuilder ||
      data.settingContainerBuilder != oldWidget.data.settingContainerBuilder ||
      data.rankingDecorationBuilder !=
          oldWidget.data.rankingDecorationBuilder ||
      data.rankingCenterBuilder != oldWidget.data.rankingCenterBuilder ||
      data.sliverAppBarBackgroundBuilder !=
          oldWidget.data.sliverAppBarBackgroundBuilder;
}
