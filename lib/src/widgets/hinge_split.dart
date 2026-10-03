import 'package:flutter/widgets.dart';

import '../helpers/fold_layout.dart';

/// Lays [first] and [second] out on either side of a separating hinge or
/// half-opened fold — left/right in [FoldPosture.book], top/bottom in
/// [FoldPosture.tabletop] — and shows [child] when nothing separates the
/// window (phones, tablets, a foldable lying flat, iOS).
///
/// Each pane gets its own [MediaQuery]: `size` is the pane's size, the
/// window's safe-area padding/insets are kept only on the edges the pane
/// shares with the window, and `displayFeatures` is emptied. So a
/// [SafeArea], `context.isTablet` or `context.windowWidthClass` inside a
/// pane behave as if that pane were the whole screen.
///
/// Display features are reported in window coordinates, so this widget must
/// fill the window — put it directly in a [Scaffold] body (no app bar),
/// outside any [SafeArea]. When its box doesn't match the window size it
/// falls back to [child] rather than guess where the hinge lands.
///
/// Switching between [child] and the split remounts the subtrees; give any
/// stateful widget that appears in both a [GlobalKey] so it is reparented
/// instead of rebuilt when the device folds/unfolds.
class HingeSplit extends StatelessWidget {
  const HingeSplit({
    super.key,
    required this.first,
    required this.second,
    required this.child,
    this.minPaneExtent = 0.0,
    this.postures = const {FoldPosture.book, FoldPosture.tabletop},
  });

  /// Left pane in book posture, top pane in tabletop posture.
  final Widget first;

  /// Right pane in book posture, bottom pane in tabletop posture.
  final Widget second;

  /// The regular single-pane layout.
  final Widget child;

  /// Falls back to [child] when either pane would be narrower (book) or
  /// shorter (tabletop) than this.
  final double minPaneExtent;

  /// Which postures split; any other posture shows [child].
  final Set<FoldPosture> postures;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final data = MediaQuery.of(context);
      final window = data.size;
      final box = constraints.biggest;
      final fillsWindow = (box.width - window.width).abs() < 1.0 &&
          (box.height - window.height).abs() < 1.0;
      if (!fillsWindow) return child;

      final layout = FoldLayout.fromData(window, data.displayFeatures);
      final panes = layout.panes;
      if (!postures.contains(layout.posture) || panes.length != 2) {
        return child;
      }
      final isBook = layout.posture == FoldPosture.book;
      final tooSmall = panes.any(
        (p) => (isBook ? p.width : p.height) < minPaneExtent,
      );
      if (tooSmall) return child;

      final separator = layout.separator!;
      Widget pane(Rect rect, Widget content) => SizedBox(
            width: rect.width,
            height: rect.height,
            child: MediaQuery(
              data: paneMediaQuery(data, rect),
              child: content,
            ),
          );

      return Flex(
        direction: isBook ? Axis.horizontal : Axis.vertical,
        children: [
          pane(panes[0], first),
          SizedBox(
            width: isBook ? separator.width : null,
            height: isBook ? null : separator.height,
          ),
          pane(panes[1], second),
        ],
      );
    });
  }

  /// [data] narrowed to the pane at [pane] (window coordinates). Also
  /// useful for any side-by-side layout whose children size themselves from
  /// [MediaQuery] (e.g. [DeviceWrapper]) rather than their constraints.
  static MediaQueryData paneMediaQuery(MediaQueryData data, Rect pane) {
    final window = data.size;
    EdgeInsets onWindowEdges(EdgeInsets e) => EdgeInsets.fromLTRB(
          pane.left <= 0 ? e.left : 0,
          pane.top <= 0 ? e.top : 0,
          pane.right >= window.width ? e.right : 0,
          pane.bottom >= window.height ? e.bottom : 0,
        );
    return data.copyWith(
      size: pane.size,
      padding: onWindowEdges(data.padding),
      viewPadding: onWindowEdges(data.viewPadding),
      viewInsets: onWindowEdges(data.viewInsets),
      systemGestureInsets: onWindowEdges(data.systemGestureInsets),
      displayFeatures: const [],
    );
  }
}
