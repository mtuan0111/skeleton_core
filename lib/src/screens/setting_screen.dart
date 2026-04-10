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
      BuildContext context,
      Widget child,
      BorderRadius borderRadius,
      String title,
      IconData? iconData)? settingContainerBuilder;

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

  InputDecoration _buildInputDecoration(BuildContext context, String hintText) {
    final builder = CustomButtonTheme.of(context)?.inputDecorationBuilder;
    if (builder != null) {
      return builder(context, hintText);
    }
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildWrappedInput(BuildContext context, Widget child) {
    final builder = CustomButtonTheme.of(context)?.inputWrapperBuilder;
    if (builder != null) {
      return builder(context, child);
    }
    return child;
  }

  Widget _buildValueChip(BuildContext context, Widget child) {
    final builder = CustomButtonTheme.of(context)?.valueWrapperBuilder;
    if (builder != null) {
      return builder(context, child);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String title,
    required Widget child,
    IconData? iconData,
  }) {
    return _buildSettingContainer(
      context: context,
      borderRadius: BorderRadius.circular(LayoutConfig.layoutBorderRadius),
      icon: iconData,
      title: title,
      child: child,
    );
  }

  Widget _buildUsernameField(BuildContext context, UserState userState) {
    final textStyle =
        CustomButtonTheme.of(context)?.inputTextStyleBuilder?.call(context);

    return _buildField(
      context,
      iconData: Icons.person,
      title: coreLang(context).name,
      child: _buildWrappedInput(
        context,
        TextFormField(
          initialValue: userState.model.username,
          onChanged: (value) {
            userBloc.add(UsernameChanged(newUsername: value));
          },
          style: textStyle,
          decoration: CustomButtonTheme.of(context)
                  ?.inputDecorationBuilder
                  ?.call(context, coreLang(context).anonymous) ??
              _buildInputDecoration(context, coreLang(context).anonymous),
        ),
      ),
    );
  }

  Widget _buildSettingContainer({
    required BuildContext context,
    required Widget child,
    required String title,
    IconData? icon,
    BorderRadius? borderRadius,
  }) {
    final currentRadius = borderRadius ??
        BorderRadius.circular(LayoutConfig.layoutBorderRadius / 5);

    if (widget.settingContainerBuilder != null) {
      return widget.settingContainerBuilder!(
        context,
        child,
        currentRadius,
        title,
        icon,
      );
    }

    return DefaultTextStyle(
      style: _getSettingTextStyle(context),
      child: Container(
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
      ),
    );
  }

  Widget _buildFontSizeSlider(BuildContext context, SettingState settingState) {
    return _buildField(context,
        iconData: Icons.format_size,
        title: coreLang(context).fontSize,
        child: _buildWrappedInput(
            context,
            Row(
              children: [
                Expanded(
                  child: _buildThemedSlider(
                    context,
                    Slider(
                      value: settingState.fontSize.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (val) {
                        setState(() {
                          settingBloc
                              .add(ChangedFontSize(fontSize: val.round()));
                        });
                      },
                    ),
                  ),
                ),
                _buildValueChip(
                  context,
                  Text(
                    settingState.fontSize.toString(),
                    style: _getSettingValueTextStyle(context),
                  ),
                ),
              ],
            )));
  }

  Widget _buildVolumeSlider(BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: settingState.vol > 7
          ? FontAwesomeIcons.volumeHigh
          : settingState.vol > 3
              ? FontAwesomeIcons.volumeLow
              : FontAwesomeIcons.volumeOff,
      title: coreLang(context).volume,
      child: _buildWrappedInput(
          context,
          Row(
            children: [
              Expanded(
                child: _buildThemedSlider(
                  context,
                  Slider(
                    value: settingState.vol.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (val) {
                      setState(() {
                        settingBloc.add(ChangedVol(vol: val.round()));
                      });
                    },
                  ),
                ),
              ),
              _buildValueChip(
                context,
                Text(settingState.vol.toString(),
                    style: _getSettingValueTextStyle(context)),
              ),
            ],
          )),
    );
  }

  Widget _buildVibrateToggle(BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: FontAwesomeIcons.mobileVibrate,
      title: coreLang(context).vibrate,
      child: _buildWrappedInput(
          context,
          _buildThemedSwitch(
            context,
            Switch(
              value: settingState.isVibrate,
              onChanged: (val) {
                settingBloc.add(ChangedIsVibrate(isVibrate: val));
              },
            ),
          )),
    );
  }

  Widget _buildTopScoresSlider(
      BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: FontAwesomeIcons.ribbon,
      title: coreLang(context).topScore,
      child: _buildWrappedInput(
          context,
          Row(
            children: [
              Expanded(
                child: _buildThemedSlider(
                  context,
                  Slider(
                    value: settingState.numberOfTopBoard.toDouble(),
                    min: 20,
                    max: 100,
                    divisions: 8,
                    onChanged: (val) {
                      setState(() {
                        settingBloc.add(
                          ChangedNumberOfTopBoard(
                              numberOfTopBoard: val.round()),
                        );
                      });
                    },
                  ),
                ),
              ),
              _buildValueChip(
                context,
                Text(settingState.numberOfTopBoard.toString(),
                    style: _getSettingValueTextStyle(context)),
              ),
            ],
          )),
    );
  }

  Widget _buildOnlyMyRecordsToggle(
      BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: FontAwesomeIcons.userCheck,
      title: coreLang(context).personal,
      child: _buildWrappedInput(
          context,
          _buildThemedSwitch(
            context,
            Switch(
              value: settingState.onlyShowMyRecorded,
              onChanged: (val) {
                settingBloc.add(
                  ChangedOnlyShowMyRecorded(onlyShowMyRecorded: val),
                );
              },
            ),
          )),
    );
  }

  Widget _buildLanguageDropdown(
      BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: FontAwesomeIcons.language,
      title: coreLang(context).language,
      child: _buildWrappedInput(
          context,
          DropdownButtonFormField<String>(
            value: settingState.locale,
            items: languages.entries
                .map(
                  (lang) => DropdownMenuItem<String>(
                    value: lang.key,
                    child: Text(
                      lang.value,
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) {
                settingBloc.add(ChangedLocale(locale: val));
              }
            },
            decoration:
                _buildInputDecoration(context, coreLang(context).anonymous),
            dropdownColor: Theme.of(context).primaryColor,
            // style: _getSettingTextStyle(context),
          )),
    );
  }

  Widget _buildThemedSlider(BuildContext context, Widget child) {
    final themeData =
        CustomButtonTheme.of(context)?.sliderThemeBuilder?.call(context);
    if (themeData != null) {
      return SliderTheme(data: themeData, child: child);
    }
    return child;
  }

  Widget _buildThemedSwitch(BuildContext context, Widget child) {
    final themeData =
        CustomButtonTheme.of(context)?.switchThemeBuilder?.call(context);
    if (themeData != null) {
      return SwitchTheme(data: themeData, child: child);
    }
    return child;
  }
}
