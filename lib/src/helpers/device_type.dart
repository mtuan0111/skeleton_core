import 'package:flutter/widgets.dart';

import 'ui_constants.dart';

/// Coarse device-class classification, orientation-independent.
enum DeviceType { mobile, tablet, desktop }

/// Responsive helpers keyed off [MediaQuery]'s `shortestSide` — the same
/// convention Apple/Flutter use to distinguish iPad-class hardware from
/// phones regardless of current rotation.
extension ResponsiveContext on BuildContext {
  DeviceType get deviceType {
    final shortestSide = MediaQuery.of(this).size.shortestSide;
    if (shortestSide >= kBreakpointDesktop) return DeviceType.desktop;
    if (shortestSide >= kBreakpointTablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  bool get isTablet => deviceType != DeviceType.mobile;

  /// Orientation-only check, independent of device class — true for a
  /// rotated phone just as much as a rotated tablet. Use this (rather than
  /// [isTabletLandscape]) for layout adaptations that should apply on any
  /// landscape screen, not just tablet-class hardware.
  ///
  /// Named `isLandscapeOrientation` (not the shorter `isLandscape`)
  /// deliberately — `o_an_quan`, a sibling app on this same shared package,
  /// already declares its own `OrientationHelper.isLandscape` extension;
  /// reusing that name here would make `context.isLandscape` ambiguous for
  /// any file that has both extensions in scope.
  bool get isLandscapeOrientation =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  bool get isTabletLandscape =>
      isTablet && MediaQuery.of(this).orientation == Orientation.landscape;

  bool get isTabletPortrait =>
      isTablet && MediaQuery.of(this).orientation == Orientation.portrait;
}
