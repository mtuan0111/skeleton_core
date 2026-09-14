import 'package:flutter/material.dart';

import '../helpers/device_type.dart';
import '../helpers/ui_constants.dart';

/// Lays out [children] as a single vertical column on mobile portrait
/// (identical to `Column(spacing: ..., children: children)`), and as a 2-3
/// column [Wrap] on tablet-class screens OR any landscape orientation
/// (phone included), with the column count derived from [minItemWidth].
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double minItemWidth;
  final int mobileColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = kSpaceL,
    this.runSpacing = kSpaceL,
    this.minItemWidth = 320,
    this.mobileColumns = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (context.isTablet || context.isLandscapeOrientation)
            ? (constraints.maxWidth / minItemWidth).floor().clamp(2, 3)
            : mobileColumns;

        if (columns <= 1) {
          return Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: runSpacing),
                children[i],
              ],
            ],
          );
        }

        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}
