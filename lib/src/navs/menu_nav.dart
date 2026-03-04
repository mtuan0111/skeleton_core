import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// A generic menu navigation widget that listens to [MenuBloc] state changes
/// and displays pages based on the current menu selection.
///
/// Apps provide their own screen widgets via the builder callbacks.
class MenuNav extends StatefulWidget {
  /// Builder for the main menu (home) screen.
  final Widget Function(BuildContext context) menuScreenBuilder;

  /// Builder for the Play/InstantStart screen.
  /// Receives the current [MenuState] so the app can distinguish
  /// between [Play] and [InstantStart].
  final Widget Function(BuildContext context, MenuState state)?
      playScreenBuilder;

  /// Builder for the TopScore screen.
  final Widget Function(BuildContext context)? topScoreScreenBuilder;

  /// Builder for the Setting screen.
  /// Receives the localized title.
  final Widget Function(BuildContext context, String title)?
      settingScreenBuilder;

  /// Builder for the About screen.
  /// Receives the localized title.
  final Widget Function(BuildContext context, String title)? aboutScreenBuilder;

  /// Map of menu option labels/icons. Used for screen titles.
  /// Key: [MenuOption], Value: map with 'text' and/or 'icon'.
  final Map<MenuOption, Map<String, dynamic>> Function(BuildContext context)?
      menuArrayBuilder;

  const MenuNav({
    super.key,
    required this.menuScreenBuilder,
    this.playScreenBuilder,
    this.topScoreScreenBuilder,
    this.settingScreenBuilder,
    this.aboutScreenBuilder,
    this.menuArrayBuilder,
  });

  @override
  State<MenuNav> createState() => _MenuNavState();
}

class _MenuNavState extends State<MenuNav> {
  String _getMenuTitle(BuildContext context, MenuOption option) {
    if (widget.menuArrayBuilder != null) {
      final array = widget.menuArrayBuilder!(context);
      return array[option]?['text'] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: ((context, navState) => PopScope(
            canPop: false,
            onPopInvoked: (involked) {
              if (navState is Menu) {
                SnackBar snackBar = SnackBar(
                  content: Text(coreLang(context).doYouWantToExit),
                  action: SnackBarAction(
                    label: coreLang(context).yes,
                    onPressed: () {
                      context
                          .read<MenuBloc>()
                          .add(SelectOption(option: MenuOption.exit));
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              if (navState is! Play && navState is! InstantStart) {
                context.read<MenuBloc>().add(ShowMenu());
              }
            },
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                return Navigator(
                  onDidRemovePage: (page) =>
                      context.read<MenuBloc>().add(ShowMenu()),
                  pages: [
                    MaterialPage(
                      child: widget.menuScreenBuilder(context),
                    ),
                    if ((navState is Play || navState is InstantStart) &&
                        widget.playScreenBuilder != null)
                      MaterialPage(
                        child: widget.playScreenBuilder!(context, navState),
                      ),
                    if (navState is TopScore &&
                        widget.topScoreScreenBuilder != null)
                      MaterialPage(
                        child: widget.topScoreScreenBuilder!(context),
                      ),
                    if (navState is Setting &&
                        widget.settingScreenBuilder != null)
                      MaterialPage(
                        child: widget.settingScreenBuilder!(
                          context,
                          _getMenuTitle(context, MenuOption.setting),
                        ),
                      ),
                    if (navState is About && widget.aboutScreenBuilder != null)
                      MaterialPage(
                        child: widget.aboutScreenBuilder!(
                          context,
                          _getMenuTitle(context, MenuOption.about),
                        ),
                      ),
                  ],
                );
              },
            ),
          )),
    );
  }
}
