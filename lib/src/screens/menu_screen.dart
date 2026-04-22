import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? _version;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      if (mounted) {
        setState(() {
          _version = packageInfo.version;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        return Scaffold(
          body: widget.backgroundWrapper != null
              ? widget.backgroundWrapper!(_buildScrollBody(context, userState))
              : Container(
                  decoration: widget.backgroundDecoration ??
                      LayoutConfig(context).gradientDecoration,
                  child: _buildScrollBody(context, userState),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    children: [
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
              ),
            ),
            if (widget.greetingMessage != null)
              SliverToBoxAdapter(child: widget.greetingMessage!),
            if (SeasonalTheme.current != ThemeType.defaultTheme)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Center(
                    child: Text(
                      _getHolidayMessage(context),
                      style: AppTextStyles.bodyLargeMedium(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: widget.menuItems[index],
                ),
                childCount: widget.menuItems.length,
              ),
            ),
            if (_version?.isNotEmpty ?? false)
              SliverFillRemaining(
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
                      Text(_version ?? "",
                          style: AppTextStyles.bodyLarge(context)),
                    ],
                  ),
                ),
              ),
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
