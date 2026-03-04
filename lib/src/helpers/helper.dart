import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// Enum to specify which corner(s) should have a smaller radius
enum RoundedWithShapeAt {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  top,
  bottom,
  left,
  right,
  all,
}

/// Common helper utilities shared across game projects.
///
/// Game-specific helpers (equation generation, difficulty logic, etc.)
/// should be defined in the game package.
class CoreHelper {
  /// Creates a BorderRadius with customizable corner shapes
  ///
  /// [radius] - Base radius for all corners (defaults to LayoutConfig.layoutBorderRadius)
  /// [shapeAt] - Which corner(s) to apply a smaller radius to (1/5 of base radius)
  /// [adjustment] - Additional adjustment to add to the base radius
  ///
  /// Returns a BorderRadius with the specified configuration
  static BorderRadius getBorderRadius({
    double? radius,
    RoundedWithShapeAt? shapeAt,
    double adjustment = 0,
  }) {
    double adjustedRadius =
        (radius ?? LayoutConfig.layoutBorderRadius) + adjustment;
    BorderRadius baseRadius = BorderRadius.only(
      topLeft: Radius.circular(adjustedRadius),
      topRight: Radius.circular(adjustedRadius),
      bottomLeft: Radius.circular(adjustedRadius),
      bottomRight: Radius.circular(adjustedRadius),
    );

    switch (shapeAt) {
      case RoundedWithShapeAt.topLeft:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.topRight:
        baseRadius = baseRadius.copyWith(
          topRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.bottomLeft:
        baseRadius = baseRadius.copyWith(
          bottomLeft: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.bottomRight:
        baseRadius = baseRadius.copyWith(
          bottomRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.top:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius / 5),
          topRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.bottom:
        baseRadius = baseRadius.copyWith(
          bottomLeft: Radius.circular(adjustedRadius / 5),
          bottomRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.left:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius / 5),
          bottomLeft: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.right:
        baseRadius = baseRadius.copyWith(
          topRight: Radius.circular(adjustedRadius / 5),
          bottomRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.all:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius),
          topRight: Radius.circular(adjustedRadius),
          bottomLeft: Radius.circular(adjustedRadius),
          bottomRight: Radius.circular(adjustedRadius),
        );
      default:
        break;
    }

    return baseRadius;
  }

  /// Launch a URL in the external browser
  static Future<void> launchURL(String url,
      {String? fallbackUrl, String? scheme}) async {
    final Uri uri = Uri.tryParse(
        scheme != null ? url.replaceFirst('https://', '$scheme://') : url)!;

    await launchUrl(uri);

    if (fallbackUrl != null) {
      final Uri? fallbackUri = Uri.tryParse(fallbackUrl);
      if (fallbackUri != null && await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri);
      }
    }
  }

  /// Capture a widget as an image
  static Future capture(GlobalKey key) async {
    RenderRepaintBoundary? boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage(pixelRatio: 3);
    final byteData = await image?.toByteData(format: ImageByteFormat.png);

    return byteData;
  }
}
