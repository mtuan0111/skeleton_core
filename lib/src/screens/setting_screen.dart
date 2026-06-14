import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_core/src/blocs/menu/menu_bloc.dart';
import 'package:skeleton_core/src/blocs/setting/setting_bloc.dart';
import 'package:skeleton_core/src/blocs/setting/setting_event.dart';
import 'package:skeleton_core/src/blocs/setting/setting_state.dart';
import 'package:skeleton_core/src/blocs/user/user_bloc.dart';
import 'package:skeleton_core/src/blocs/user/user_event.dart';
import 'package:skeleton_core/src/blocs/user/user_state.dart';
import 'package:skeleton_core/src/helpers/app_text_styles.dart';
import 'package:skeleton_core/src/helpers/const.dart';
import 'package:skeleton_core/src/helpers/core_lang.dart';
import 'package:skeleton_core/src/helpers/extension.dart';
import 'package:skeleton_core/src/helpers/ui_constants.dart';
import 'package:skeleton_core/src/widgets/custom_button_theme.dart';
import 'package:skeleton_core/src/widgets/custom_sliver_app_bar.dart';
import 'package:skeleton_core/src/widgets/template_widgets.dart';

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
  final List<Widget> Function(
    BuildContext context,
    SettingState settingState,
    Widget Function(
      BuildContext context, {
      required String title,
      required Widget child,
      FaIconData? iconData,
    }) buildField,
  )? additionalSettingsBuilder;

  /// Optional builder to customise the appearance of each setting's container.
  final Widget Function(
    BuildContext context,
    Widget child,
    BorderRadius borderRadius,
    String title,
    FaIconData? icon,
  )? settingContainerBuilder;

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

        final scrollBody = SafeArea(
          child: CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                title: screenTitle,
                onBackPressed: () {
                  context.read<MenuBloc>().add(ShowMenu());
                },
                expandedHeight: 100,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, userState) {
                        return DeviceWrapper(
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: kSpaceL,
                              children: [
                                _buildUsernameField(context, userState),
                                _buildFontSizeSlider(context, settingState),
                                _buildVolumeSlider(context, settingState),
                                _buildVibrateToggle(context, settingState),
                                _buildTopScoresSlider(context, settingState),
                                _buildOnlyMyRecordsToggle(
                                    context, settingState),
                                _buildLanguageDropdown(context, settingState),
                                if (widget.additionalSettingsBuilder != null)
                                  ...widget.additionalSettingsBuilder!(
                                    context,
                                    settingState,
                                    _buildField,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  TextStyle _getSettingValueTextStyle(BuildContext context) {
    final themeData = CustomButtonTheme.of(context);
    final buttonStyle = themeData?.textStyle;
    final bgColor = themeData?.valueWrapperBackgroundColor;

    final baseStyle = buttonStyle ??
        (bgColor != null
            ? AppTextStyles.bodyLargeBold(context, bgColor)
            : AppTextStyles.bodyLargeBold(context));

    return baseStyle.copyWith(
      fontWeight: FontWeight.bold,
      color: bgColor != null ? bgColor.getSmartColor(context) : null,
    );
  }

  TextStyle _getSettingDropdownTextStyle(BuildContext context) {
    final themeData = CustomButtonTheme.of(context);
    final textStyle = themeData?.inputTextStyleBuilder?.call(context);
    final bgColor = themeData?.inputWrapperBackgroundColor;

    final baseStyle = textStyle ??
        (bgColor != null
            ? AppTextStyles.bodyMedium(context, bgColor)
            : AppTextStyles.bodyMedium(context));

    return baseStyle.copyWith(
      color: bgColor != null ? bgColor.getSmartColor(context) : null,
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
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
        borderSide: BorderSide.none,
      ),
      filled: false,

      // fillColor: Colors.white,
    );
  }

  Widget _buildWrappedInput(BuildContext context, Widget child) {
    final builder = CustomButtonTheme.of(context)?.inputWrapperBuilder ??
        CustomButtonTheme.defaultInputWrapperBuilder;
    if (builder != null) {
      return builder(context, child);
    }
    return InnerShadow(
      borderRadius: BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 1,
          spreadRadius: 1,
          offset: const Offset(0, 0),
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius:
              BorderRadius.circular(LayoutConfig.layoutBorderRadius / 2),
        ),
        child: child,
      ),
    );
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
    FaIconData? iconData,
  }) {
    return _buildSettingContainer(
      context: context,
      borderRadius: BorderRadius.circular(LayoutConfig.layoutBorderRadius),
      icon: iconData,
      title: title,
      child: _buildWrappedInput(
          context,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          )),
    );
  }

  Widget _buildUsernameField(BuildContext context, UserState userState) {
    final textStyle =
        CustomButtonTheme.of(context)?.inputTextStyleBuilder?.call(context);

    return _buildField(
      context,
      iconData: FontAwesomeIcons.user,
      title: coreLang(context).name,
      child: TextFormField(
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
    );
  }

  Widget _buildSettingContainer({
    required BuildContext context,
    required Widget child,
    required String title,
    dynamic icon,
    BorderRadius? borderRadius,
  }) {
    return CustomWrapContainer(
      title: title,
      icon: icon,
      borderRadius: borderRadius,
      backgroundColor: widget.backgroundColor,
      fontFamily: widget.fontFamily,
      child: child,
    );
  }

  Widget _buildFontSizeSlider(BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: FaIconData(Icons.format_size),
      title: coreLang(context).fontSize,
      child: Row(
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
                    settingBloc.add(ChangedFontSize(fontSize: val.round()));
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
      ),
    );
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
      child: Row(
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
      ),
    );
  }

  Widget _buildVibrateToggle(BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: FaIconData(Icons.vibration_rounded),
      title: coreLang(context).vibrate,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildThemedSwitch(
            context,
            Switch(
              value: settingState.isVibrate,
              onChanged: (val) {
                settingBloc.add(ChangedIsVibrate(isVibrate: val));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopScoresSlider(
      BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: FontAwesomeIcons.ribbon,
      title: coreLang(context).topScore,
      child: Row(
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
                      ChangedNumberOfTopBoard(numberOfTopBoard: val.round()),
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
      ),
    );
  }

  Widget _buildOnlyMyRecordsToggle(
      BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: FontAwesomeIcons.userCheck,
      title: coreLang(context).personal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(
      BuildContext context, SettingState settingState) {
    return _buildField(
      context,
      iconData: FontAwesomeIcons.language,
      title: coreLang(context).language,
      child: DropdownButtonFormField<String>(
        initialValue: settingState.locale,
        items: languages.entries
            .map(
              (lang) => DropdownMenuItem<String>(
                value: lang.key,
                child: Text(
                  lang.value,
                  style: AppTextStyles.bodyMedium(
                      context, Theme.of(context).primaryColor),
                ),
              ),
            )
            .toList(),
        onChanged: (val) {
          if (val != null) {
            settingBloc.add(ChangedLocale(locale: val));
          }
        },
        decoration: _buildInputDecoration(context, coreLang(context).anonymous),
        dropdownColor: Theme.of(context).primaryColor,
        style: _getSettingDropdownTextStyle(context),
      ),
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
