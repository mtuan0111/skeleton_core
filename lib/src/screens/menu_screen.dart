import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// A generic, reusable Main Menu screen for all game apps.
///
/// Includes common UI scaffolding: gradient background, SliverAppBar with
/// MainLogo, welcome user text, holiday messages, and app version at the bottom.
///
/// Apps inject their specific visual identity via [title], [subtitle],
/// [headerIcon], and provide their own navigation buttons in [menuItems].
class MenuScreen extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? headerIcon;
  final Widget? greetingMessage;
  final List<Widget> menuItems;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final BoxDecoration? backgroundDecoration;

  /// Optional: fully replaces the Container+decoration background.
  /// Receives the scrollable body as a child to wrap.
  final Widget Function(Widget child)? backgroundWrapper;

  /// Opt-in: when true, [menuItems] flow into a 2-3 column [ResponsiveGrid]
  /// on any landscape orientation instead of the default single-column
  /// list. Defaults to false so existing consumers (e.g. o_an_quan) are
  /// completely unaffected unless they explicitly opt in.
  final bool enableLandscapeSplit;

  /// Opt-in: on a foldable held half-open (book/tabletop) or a spanned
  /// dual-screen device, put the header (logo, title, greeting) on one side
  /// of the hinge and [menuItems] on the other, so nothing straddles it.
  /// Defaults to false so existing consumers are unaffected.
  final bool enableHingeSplit;

  const MenuScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.headerIcon,
    this.greetingMessage,
    required this.menuItems,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundDecoration,
    this.backgroundWrapper,
    this.enableLandscapeSplit = false,
    this.enableHingeSplit = false,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with AppVersionStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        final body = widget.enableHingeSplit
            ? HingeSplit(
                minPaneExtent: 280,
                first: _buildHeaderPane(context, userState),
                second: _buildItemsPane(context),
                child: _buildScrollBody(context, userState),
              )
            : _buildScrollBody(context, userState);
        return Scaffold(
          body: widget.backgroundWrapper != null
              ? widget.backgroundWrapper!(body)
              : Container(
                  decoration: widget.backgroundDecoration ??
                      LayoutConfig(context).gradientDecoration,
                  child: body,
                ),
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
        );
      },
    );
  }

  Widget _buildScrollBody(BuildContext context, UserState userState) {
    return SafeArea(
      child: DeviceWrapper(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              pinned: true,
              flexibleSpace: widget.headerIcon == null
                  ? const Center(child: MainLogo())
                  : Center(
                      child: widget.headerIcon!,
                    ),
              expandedHeight: widget.headerIcon == null ? 240 : 220,
              toolbarHeight: widget.headerIcon == null ? 80 : 80,
            ),
            SliverToBoxAdapter(child: _buildTitleBlock(context, userState)),
            if (widget.greetingMessage != null)
              SliverToBoxAdapter(child: widget.greetingMessage!),
            if (SeasonalTheme.current != ThemeType.defaultTheme)
              SliverToBoxAdapter(child: _buildHolidayMessage(context)),
            if (widget.enableLandscapeSplit && context.isLandscapeOrientation)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ResponsiveGrid(
                    minItemWidth: 260,
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.menuItems,
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: widget.menuItems[index],
                  ),
                  childCount: widget.menuItems.length,
                ),
              ),
            if (appVersion?.isNotEmpty ?? false) _buildVersionSliver(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBlock(BuildContext context, UserState userState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title.isNotNullOrEmpty)
              Text(
                widget.title,
                style: AppTextStyles.headlineLarge(context),
              ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.subtitle!,
                style: AppTextStyles.bodyLarge(context),
              ),
            ],
            Text(
              userState.username != null
                  ? coreLang(context).welcomeUser(userState.username!)
                  : coreLang(context).welcome,
              style: AppTextStyles.titleLarge(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHolidayMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: Center(
        child: Text(
          _getHolidayMessage(context),
          style: AppTextStyles.bodyLargeMedium(context),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildVersionSliver(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        margin: const EdgeInsets.all(kPaddingM),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${coreLang(context).version}: ",
                style: AppTextStyles.bodyLarge(context)),
            Text(appVersion ?? "", style: AppTextStyles.bodyLarge(context)),
          ],
        ),
      ),
    );
  }

  /// [enableHingeSplit]'s look-at pane: logo, title, greeting.
  Widget _buildHeaderPane(BuildContext context, UserState userState) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kPaddingM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 180,
                child: Center(child: widget.headerIcon ?? const MainLogo()),
              ),
              _buildTitleBlock(context, userState),
              if (widget.greetingMessage != null) widget.greetingMessage!,
              if (SeasonalTheme.current != ThemeType.defaultTheme)
                _buildHolidayMessage(context),
            ],
          ),
        ),
      ),
    );
  }

  /// [enableHingeSplit]'s touch pane: the menu buttons and version.
  Widget _buildItemsPane(BuildContext context) {
    return SafeArea(
      child: DeviceWrapper(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: kPaddingM)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: widget.menuItems[index],
                ),
                childCount: widget.menuItems.length,
              ),
            ),
            if (appVersion?.isNotEmpty ?? false) _buildVersionSliver(context),
          ],
        ),
      ),
    );
  }

  String _getHolidayMessage(BuildContext context) {
    final currentTheme = SeasonalTheme.current;

    switch (currentTheme) {
      case ThemeType.newYear:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayNewYear,
          coreLang(context).greetingNewYear,
        );
      case ThemeType.lunarNewYear:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayLunarNewYear,
          coreLang(context).greetingLunarNewYear,
        );
      case ThemeType.valentine:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayValentine,
          coreLang(context).greetingValentine,
        );
      case ThemeType.holi:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayHoli,
          coreLang(context).greetingHoli,
        );
      case ThemeType.earthDay:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayEarthDay,
          coreLang(context).greetingEarthDay,
        );
      case ThemeType.easter:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayEaster,
          coreLang(context).greetingEaster,
        );
      case ThemeType.pride:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayPride,
          coreLang(context).greetingPride,
        );
      case ThemeType.halloween:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayHalloween,
          coreLang(context).greetingHalloween,
        );
      case ThemeType.diwali:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayDiwali,
          coreLang(context).greetingDiwali,
        );
      case ThemeType.hanukkah:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayHanukkah,
          coreLang(context).greetingHanukkah,
        );
      case ThemeType.christmas:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayChristmas,
          coreLang(context).greetingChristmas,
        );
      case ThemeType.kwanzaa:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayKwanzaa,
          coreLang(context).greetingKwanzaa,
        );
      default:
        return '';
    }
  }
}
