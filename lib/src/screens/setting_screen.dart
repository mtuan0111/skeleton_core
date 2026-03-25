import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// A generic, reusable Setting screen for all game apps.
///
/// Includes common settings: username, font size, volume, vibration,
/// number of top scores, "only show my records" toggle, and language.
///
/// Pass [additionalSettingsBuilder] to inject app-specific settings
/// (e.g. nucatch's "Restart Tour" button).
class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
    required this.title,
    this.additionalSettingsBuilder,
    this.settingContainerBuilder,
    this.onNumberOfTopBoardChanged,
    this.backgroundDecoration,
    this.backgroundWrapper,
    this.backgroundColor,
    this.fontFamily,
  });

  final String title;

  /// Optional builder to inject app-specific settings widgets
  /// after the common settings. Receives the current [SettingState].
  final List<Widget> Function(BuildContext context, SettingState settingState)?
      additionalSettingsBuilder;

  /// Optional builder to customise the appearance of each setting's container.
  final Widget Function(
          BuildContext context, Widget child, BorderRadius borderRadius)?
      settingContainerBuilder;

  /// Optional callback when the number of top board changes,
  /// so apps can sync their TurnRecordedListBloc.
  final void Function(int numberOfTopBoard)? onNumberOfTopBoardChanged;

  final BoxDecoration? backgroundDecoration;
  final Widget Function(Widget child)? backgroundWrapper;

  /// The dominant background color behind the settings content.
  /// Used to compute a contrasting text/icon color via [getSmartColor].
  /// Falls back to the theme's primary color if null.
  final Color? backgroundColor;

  /// Optional font family to apply to all setting label text.
  /// When set, overrides the font family from [AppTextStyles.titleLarge].
  final String? fontFamily;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String get screenTitle => widget.title;

  UserBloc get userBloc => context.read<UserBloc>();
  SettingBloc get settingBloc => context.read<SettingBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, settingState) {
        // Notify app when numberOfTopBoard changes
        if (widget.onNumberOfTopBoardChanged != null) {
          widget.onNumberOfTopBoardChanged!(settingState.numberOfTopBoard);
        }

        final scrollBody = CustomScrollView(
          slivers: [
            CustomSliverAppBar(
              title: screenTitle,
              onBackPressed: () {
                context.read<MenuBloc>().add(ShowMenu());
              },
              expandedHeight: 100,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SafeArea(
                      top: false,
                      child: DeviceWrapper(
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, userState) {
                            return Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildUsernameField(context, userState),
                                  const SizedBox(height: kSpace2XL),
                                  _buildFontSizeSlider(context, settingState),
                                  const SizedBox(height: kSpaceL),
                                  _buildVolumeSlider(context, settingState),
                                  const SizedBox(height: kSpaceL),
                                  _buildVibrateToggle(context, settingState),
                                  const SizedBox(height: kSpaceL),
                                  _buildTopScoresSlider(context, settingState),
                                  const SizedBox(height: kSpaceL),
                                  _buildOnlyMyRecordsToggle(
                                      context, settingState),
                                  const SizedBox(height: kSpaceL),
                                  _buildLanguageDropdown(context, settingState),
                                  const SizedBox(height: kSpace2XL),
                                  if (widget.additionalSettingsBuilder != null)
                                    ...widget.additionalSettingsBuilder!(
                                        context, settingState),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

        return Scaffold(
          body: widget.backgroundWrapper != null
              ? widget.backgroundWrapper!(scrollBody)
              : Container(
                  decoration: widget.backgroundDecoration ??
                      LayoutConfig(context).gradientDecoration,
                  child: scrollBody,
                ),
        );
      },
    );
  }

  TextStyle _getSettingTextStyle(BuildContext context) {
    final bg = widget.backgroundColor ?? Theme.of(context).primaryColor;
    final textColor = bg.getSmartColor(context);
    final buttonStyle = CustomButtonTheme.of(context)?.textStyle;
    return (buttonStyle ?? AppTextStyles.displayLarge(context)).copyWith(
      fontFamily: widget.fontFamily,
      color: textColor,
    );
  }

  TextStyle _getSettingValueTextStyle(BuildContext context) {
    final buttonStyle = CustomButtonTheme.of(context)?.textStyle;
    return (buttonStyle ?? AppTextStyles.bodyLargeBold(context)).copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildUsernameField(BuildContext context, UserState userState) {
    final bg = widget.backgroundColor ?? Theme.of(context).primaryColor;
    final textColor = bg.getSmartColor(context);
    return _buildSettingContainer(
      context: context,
      borderRadius: BorderRadius.circular(LayoutConfig.layoutBorderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: textColor, size: kIconSizeM),
              const SizedBox(width: kSpaceML),
              Expanded(
                child: Text(
                  coreLang(context).name,
                  style: _getSettingTextStyle(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceM),
          TextFormField(
            decoration: InputDecoration(
              hintText: coreLang(context).anonymous,
              hintStyle: AppTextStyles.withColor(
                AppTextStyles.bodyLarge(context),
                textColor,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
                borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
                borderSide: BorderSide(color: textColor, width: 2),
              ),
            ),
            style: _getSettingTextStyle(context),
            initialValue: userState.model.username,
            onChanged: (value) {
              userBloc.add(UsernameChanged(newUsername: value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingContainer({
    required BuildContext context,
    required Widget child,
    BorderRadius? borderRadius,
  }) {
    final currentRadius = borderRadius ??
        BorderRadius.circular(LayoutConfig.layoutBorderRadius / 5);

    if (widget.settingContainerBuilder != null) {
      return widget.settingContainerBuilder!(context, child, currentRadius);
    }

    return Container(
      padding: const EdgeInsets.all(kPaddingL),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: currentRadius,
        border: Border.all(
          color: Theme.of(context)
              .primaryColor
              .getSmartColor(context)
              .withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );
  }

  Widget _buildFontSizeSlider(BuildContext context, SettingState settingState) {
    final textColor = _getSettingTextStyle(context).color!;
    return _buildSettingContainer(
      context: context,
      borderRadius: BorderRadius.circular(LayoutConfig.layoutBorderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.textWidth,
                color: textColor,
                size: kIconSizeM,
              ),
              const SizedBox(width: kSpaceML),
              Expanded(
                child: Text(
                  coreLang(context).fontSize,
                  style: _getSettingTextStyle(context),
                ),
              ),
              const SizedBox(width: kSpaceML),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  settingState.fontSize.toString(),
                  style: _getSettingValueTextStyle(context),
                ),
              ),
            ],
          ),
          Slider(
            value: settingState.fontSize.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            activeColor: textColor,
            inactiveColor: textColor.withValues(alpha: 0.3),
            onChanged: (val) {
              setState(() {
                settingBloc.add(ChangedFontSize(fontSize: val.round()));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeSlider(BuildContext context, SettingState settingState) {
    final textColor = _getSettingTextStyle(context).color!;
    return _buildSettingContainer(
      context: context,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
        topRight: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                settingState.vol > 7
                    ? FontAwesomeIcons.volumeHigh
                    : settingState.vol > 4
                        ? FontAwesomeIcons.volumeLow
                        : settingState.vol > 0
                            ? FontAwesomeIcons.volumeOff
                            : FontAwesomeIcons.volumeXmark,
                color: textColor,
                size: kIconSizeM,
              ),
              const SizedBox(width: kSpaceML),
              Text(coreLang(context).volume,
                  style: _getSettingTextStyle(context)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(settingState.vol.toString(),
                    style: _getSettingValueTextStyle(context)),
              ),
            ],
          ),
          Slider(
            value: settingState.vol.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            activeColor: textColor,
            inactiveColor: textColor.withValues(alpha: 0.3),
            onChanged: (val) {
              settingBloc.add(ChangedVol(vol: val.round()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVibrateToggle(BuildContext context, SettingState settingState) {
    final textColor = _getSettingTextStyle(context).color!;
    return _buildSettingContainer(
      context: context,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
        topRight: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius),
      ),
      child: Row(
        children: [
          Icon(
            settingState.isVibrate
                ? FontAwesomeIcons.mobileScreenButton
                : FontAwesomeIcons.mobile,
            color: textColor,
            size: kIconSizeM,
          ),
          const SizedBox(width: kSpaceML),
          Text(coreLang(context).vibrate, style: _getSettingTextStyle(context)),
          const Spacer(),
          Switch(
            value: settingState.isVibrate,
            activeThumbColor: Theme.of(context).primaryColor,
            onChanged: (val) {
              settingBloc.add(ChangedIsVibrate(isVibrate: val));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopScoresSlider(
      BuildContext context, SettingState settingState) {
    final textColor = _getSettingTextStyle(context).color!;
    return _buildSettingContainer(
      context: context,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
        topRight: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FontAwesomeIcons.ribbon, color: textColor, size: kIconSizeM),
              const SizedBox(width: kSpaceML),
              Expanded(
                child: Text(coreLang(context).topScore,
                    style: _getSettingTextStyle(context)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(settingState.numberOfTopBoard.toString(),
                    style: _getSettingValueTextStyle(context)),
              ),
            ],
          ),
          Slider(
            value: settingState.numberOfTopBoard.toDouble(),
            min: 20,
            max: 100,
            divisions: 8,
            activeColor: textColor,
            inactiveColor: textColor.withValues(alpha: 0.3),
            onChanged: (val) {
              setState(() {
                settingBloc.add(
                  ChangedNumberOfTopBoard(numberOfTopBoard: val.round()),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOnlyMyRecordsToggle(
      BuildContext context, SettingState settingState) {
    final textColor = _getSettingTextStyle(context).color!;
    return _buildSettingContainer(
      context: context,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
        topRight: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius),
      ),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.userCheck, color: textColor, size: kIconSizeM),
          const SizedBox(width: kSpaceML),
          Expanded(
            child: Text(coreLang(context).personal,
                style: _getSettingTextStyle(context)),
          ),
          const SizedBox(width: kSpaceML),
          Switch(
            value: settingState.onlyShowMyRecorded,
            activeThumbColor: Theme.of(context).primaryColor,
            onChanged: (val) {
              settingBloc.add(
                ChangedOnlyShowMyRecorded(onlyShowMyRecorded: val),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(
      BuildContext context, SettingState settingState) {
    final textColor = _getSettingTextStyle(context).color!;
    return _buildSettingContainer(
      context: context,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
        topRight: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
        bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FontAwesomeIcons.language,
                  color: textColor, size: kIconSizeM),
              const SizedBox(width: kSpaceML),
              Text(coreLang(context).language,
                  style: _getSettingTextStyle(context)),
            ],
          ),
          const SizedBox(height: kSpaceML),
          DropdownButtonFormField<String>(
            initialValue: settingState.locale,
            items: languages.entries
                .map(
                  (lang) => DropdownMenuItem<String>(
                    value: lang.key,
                    child: Text(
                      lang.value,
                      style: _getSettingTextStyle(context),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) {
                settingBloc.add(ChangedLocale(locale: val));
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  LayoutConfig.layoutBorderRadius,
                ),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  LayoutConfig.layoutBorderRadius,
                ),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  LayoutConfig.layoutBorderRadius,
                ),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor.getSmartColor(context),
                  width: 2,
                ),
              ),
            ),
            dropdownColor: Theme.of(context).primaryColor,
            style: _getSettingTextStyle(context),
          ),
        ],
      ),
    );
  }
}
