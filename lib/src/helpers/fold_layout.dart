import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/widgets.dart';

/// How a foldable or dual-screen device is being held, as far as layout is
/// concerned.
enum FoldPosture {
  /// No separating feature: a phone, a tablet, a foldable lying flat.
  flat,

  /// A vertical separating feature — a Fold half-opened like a book, or a
  /// Surface Duo spanned in dual-portrait. Two side-by-side panes.
  book,

  /// A horizontal separating feature — a Flip or Fold half-opened on a
  /// table (Flex Mode), or a Duo spanned in dual-landscape. A top pane to
  /// look at and a bottom pane to touch.
  tabletop,
}

/// The single place hinge and posture decisions are made — screens ask this
/// instead of reading [MediaQueryData.displayFeatures] themselves.
///
/// A feature *separates* the screen when its bounds cover real pixels (a
/// Duo hinge, which hides whatever is drawn under it) or when it is a fold
/// that is half-opened. That is exactly the rule Flutter's own
/// [DisplayFeatureSubScreen] applies to dialogs and sheets, so app layouts
/// and the framework's routes agree on where the panes are. Nothing
/// readable or tappable may straddle a separating feature. A fold lying
/// flat is only a [crease]: content may cross it.
///
/// iOS reports no display features, so there this is always
/// [FoldPosture.flat] and every decision falls back to window size alone.
@immutable
class FoldLayout {
  const FoldLayout._(this.size, this.separator, this.crease);

  /// Computes the layout of a box of [size] whose display features, in that
  /// box's own coordinates, are [features]. Features outside the box are
  /// ignored and ones overlapping its edge are clipped to it.
  factory FoldLayout.fromData(Size size, Iterable<DisplayFeature> features) {
    final box = Offset.zero & size;
    Rect? separator;
    Rect? crease;
    for (final feature in features) {
      if (feature.type == DisplayFeatureType.cutout) continue;
      final bounds = _clip(feature.bounds, box);
      if (bounds == null) continue;
      if (_isSeparating(feature)) {
        separator ??= bounds;
      } else {
        crease ??= bounds;
      }
    }
    return FoldLayout._(size, separator, crease);
  }

  /// The layout of the window as [context] sees it: [MediaQuery]'s size and
  /// display features. Below a [LocalDisplayFeatures] the features have
  /// been rebased, so pass that box's own [size] (from a [LayoutBuilder]).
  factory FoldLayout.of(BuildContext context, {Size? size}) =>
      FoldLayout.fromData(
        size ?? MediaQuery.sizeOf(context),
        MediaQuery.displayFeaturesOf(context),
      );

  /// The box this layout describes.
  final Size size;

  /// The hinge or half-opened fold splitting [size] into two panes, if any.
  /// May be zero-width (a fold) or cover real pixels (a hinge).
  final Rect? separator;

  /// A fold lying flat — not separating, only a line content may cross.
  final Rect? crease;

  bool get hasSeparator => separator != null;

  /// Orientation of the separator: [Axis.vertical] for a hinge running top
  /// to bottom (book posture), null when there is none.
  Axis? get separatorAxis => _axisOf(separator);

  FoldPosture get posture => switch (separatorAxis) {
        null => FoldPosture.flat,
        Axis.vertical => FoldPosture.book,
        Axis.horizontal => FoldPosture.tabletop,
      };

  bool get isBook => posture == FoldPosture.book;
  bool get isTabletop => posture == FoldPosture.tabletop;

  /// The regions content can safely use: the whole box when nothing
  /// separates it, otherwise the one or two non-empty areas on either side
  /// of the [separator] — left then right, or top then bottom.
  List<Rect> get panes {
    final box = Offset.zero & size;
    final s = separator;
    if (s == null) return [box];
    final candidates = s.height >= s.width
        ? [
            Rect.fromLTRB(0, 0, s.left, size.height),
            Rect.fromLTRB(s.right, 0, size.width, size.height),
          ]
        : [
            Rect.fromLTRB(0, 0, size.width, s.top),
            Rect.fromLTRB(0, s.bottom, size.width, size.height),
          ];
    return [
      for (final pane in candidates)
        if (pane.width > 0 && pane.height > 0) pane,
    ];
  }

  /// The pane [point] falls in — or, for a point on the separator itself,
  /// the nearer one.
  Rect paneContaining(Offset point) {
    final all = panes;
    for (final pane in all) {
      if (pane.contains(point)) return pane;
    }
    var best = all.first;
    var bestDistance = double.infinity;
    for (final pane in all) {
      final distance = (pane.center - point).distanceSquared;
      if (distance < bestDistance) {
        best = pane;
        bestDistance = distance;
      }
    }
    return best;
  }

  /// Whether [rect] crosses (or sits on) the separator. Always false with no
  /// separator. A zero-width fold counts as crossed when it runs through
  /// [rect]'s interior.
  bool straddlesSeparator(Rect rect) {
    final s = separator;
    if (s == null) return false;
    return rect.left < s.right &&
        rect.right > s.left &&
        rect.top < s.bottom &&
        rect.bottom > s.top;
  }

  /// [features] (window coordinates) moved into the coordinates of a box at
  /// [local] (also window coordinates), clipped to it. Features that miss the
  /// box entirely are dropped.
  static List<DisplayFeature> rebase(
    Iterable<DisplayFeature> features,
    Rect local,
  ) {
    final box = Offset.zero & local.size;
    return [
      for (final feature in features)
        if (_clip(feature.bounds.shift(-local.topLeft), box) case final bounds?)
          DisplayFeature(
            bounds: bounds,
            type: feature.type,
            state: feature.state,
          ),
    ];
  }

  static bool _isSeparating(DisplayFeature feature) =>
      feature.bounds.shortestSide > 0 ||
      feature.state == DisplayFeatureState.postureHalfOpened;

  static Axis? _axisOf(Rect? rect) => rect == null
      ? null
      : rect.height >= rect.width
          ? Axis.vertical
          : Axis.horizontal;

  /// [rect] ∩ [box], keeping zero-width/height lines (a fold) that lie
  /// inside it; null when they don't meet at all. [Rect.intersect] alone
  /// can't tell those apart: it returns a negative-size rect for a miss.
  static Rect? _clip(Rect rect, Rect box) {
    final clipped = rect.intersect(box);
    if (clipped.width < 0 || clipped.height < 0) return null;
    // A line exactly on the box's edge isn't inside it in any useful sense.
    if (clipped.width == 0 &&
        (clipped.left <= box.left || clipped.left >= box.right)) {
      return null;
    }
    if (clipped.height == 0 &&
        (clipped.top <= box.top || clipped.top >= box.bottom)) {
      return null;
    }
    return clipped;
  }

  @override
  bool operator ==(Object other) =>
      other is FoldLayout &&
      other.size == size &&
      other.separator == separator &&
      other.crease == crease;

  @override
  int get hashCode => Object.hash(size, separator, crease);

  @override
  String toString() => 'FoldLayout($posture, size: $size, '
      'separator: $separator, crease: $crease)';
}

/// Rebases the [MediaQueryData.displayFeatures] [child] sees into its own
/// coordinates, so [FoldLayout.of] below it can be given the child's own
/// size. The platform reports hinges in window coordinates; a child that
/// starts [origin] from the window's top-left (e.g. inside a [SafeArea])
/// would otherwise place its panes that far off the real hinge.
///
/// Always builds the same tree shape whether or not any features are
/// reported: unfolding a Fold turns a featureless cover screen into a
/// creased inner one, and a changed shape here would remount everything
/// underneath.
class LocalDisplayFeatures extends StatelessWidget {
  const LocalDisplayFeatures({
    super.key,
    required this.origin,
    required this.child,
  });

  /// [child]'s top-left corner in window coordinates.
  final Offset origin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final data = MediaQuery.of(context);
        final local = origin &
            Size(constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : data.size.width,
                constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : data.size.height);
        return MediaQuery(
          data: data.copyWith(
            displayFeatures: FoldLayout.rebase(data.displayFeatures, local),
          ),
          child: child,
        );
      },
    );
  }
}

extension FoldLayoutContext on BuildContext {
  /// [FoldLayout.of] for the whole window.
  FoldLayout get foldLayout => FoldLayout.of(this);
}
