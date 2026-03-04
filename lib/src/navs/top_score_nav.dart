import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// A generic top-score navigation widget that listens to
/// [TopScoreNavCubit] state changes and shows either a root
/// top-score list or a detail screen.
///
/// Type parameters:
/// - [TRecord]: The model type for a recorded score entry.
/// - [TPeriod]: The enum/type for ranking period.
///
/// Apps provide their own screen widgets via builder callbacks.
class TopScoreNav<TRecord, TPeriod> extends StatefulWidget {
  /// Builds the root top-score list screen.
  /// Receives the localized title for the screen.
  final Widget Function(BuildContext context, String title) rootScreenBuilder;

  /// Builds the detail screen for a specific score entry.
  /// Receives context, title, and the [TopScoreDetailState].
  final Widget Function(
    BuildContext context,
    String title,
    TopScoreDetailState<TRecord, TPeriod> detailState,
  ) detailScreenBuilder;

  /// Gets the localized title for the top-score screen.
  final String Function(BuildContext context) titleBuilder;

  /// Called when the root page is removed from the navigation stack.
  final VoidCallback? onRootPageRemoved;

  const TopScoreNav({
    super.key,
    required this.rootScreenBuilder,
    required this.detailScreenBuilder,
    required this.titleBuilder,
    this.onRootPageRemoved,
  });

  @override
  State<TopScoreNav<TRecord, TPeriod>> createState() =>
      _TopScoreNavState<TRecord, TPeriod>();
}

class _TopScoreNavState<TRecord, TPeriod>
    extends State<TopScoreNav<TRecord, TPeriod>> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopScoreNavCubit<TRecord, TPeriod>, TopScoreNavState>(
      builder: (context, state) {
        final title = widget.titleBuilder(context);
        return Navigator(
          onDidRemovePage: (page) async {
            if (widget.onRootPageRemoved != null) {
              widget.onRootPageRemoved!();
            } else {
              context.read<MenuBloc>().add(ShowMenu());
            }
          },
          pages: [
            MaterialPage(
              child: widget.rootScreenBuilder(context, title),
            ),
            if (state is TopScoreDetailState<TRecord, TPeriod>)
              MaterialPage(
                child: widget.detailScreenBuilder(context, title, state),
              ),
          ],
        );
      },
    );
  }
}
