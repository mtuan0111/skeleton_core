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
    this.onNumberOfTopBoardChanged,
  });

  final String title;

  /// Optional builder to inject app-specific settings widgets
  /// after the common settings. Receives the current [SettingState].
  final List<Widget> Function(BuildContext context, SettingState settingState)?
      additionalSettingsBuilder;

  /// Optional callback when the number of top board changes,
  /// so apps can sync their TurnRecordedListBloc.
  final void Function(int numberOfTopBoard)? onNumberOfTopBoardChanged;

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

        return Scaffold(
          body: Container(
            decoration: LayoutConfig(context).gradientDecoration,
            child: CustomScrollView(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Username field
                                      _buildUsernameField(context, userState),
                                      const SizedBox(height: kSpace2XL),
                                      // Font size slider
                                      _buildFontSizeSlider(
                                          context, settingState),
                                      const SizedBox(height: kSpaceL),
                                      // Volume slider
                                      _buildVolumeSlider(context, settingState),
                                      const SizedBox(height: kSpaceL),
                                      // Vibrate toggle
                                      _buildVibrateToggle(
                                          context, settingState),
                                      const SizedBox(height: kSpaceL),
                                      // Top scores slider
                                      _buildTopScoresSlider(
                                          context, settingState),
                                      const SizedBox(height: kSpaceL),
                                      // Only show my recorded toggle
                                      _buildOnlyMyRecordsToggle(
                                          context, settingState),
                                      const SizedBox(height: kSpaceL),
                                      // Language dropdown
                                      _buildLanguageDropdown(
                                          context, settingState),
                                      const SizedBox(height: kSpace2XL),
                                      // App-specific additional settings
                                      if (widget.additionalSettingsBuilder !=
                                          null)
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsernameField(BuildContext context, UserState userState) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        labelText: coreLang(context).name,
        hintText: coreLang(context).anonymous,
        labelStyle: AppTextStyles.titleLarge(context),
        hintStyle: AppTextStyles.withColor(
          AppTextStyles.bodyLarge(context),
          Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            LayoutConfig.layoutBorderRadius,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            LayoutConfig.layoutBorderRadius,
          ),
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            LayoutConfig.layoutBorderRadius,
          ),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 2,
          ),
        ),
      ),
      style: AppTextStyles.titleLarge(context),
      initialValue: userState.model.username,
      onChanged: (value) {
        userBloc.add(UsernameChanged(newUsername: value));
      },
    );
  }

  Widget _buildSettingContainer({
    required BuildContext context,
    required Widget child,
    BorderRadius? borderRadius,
  }) {
    return Container(
      padding: const EdgeInsets.all(kPaddingL),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: borderRadius ??
            BorderRadius.circular(LayoutConfig.layoutBorderRadius / 5),
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );
  }

  Widget _buildFontSizeSlider(BuildContext context, SettingState settingState) {
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
              Icon(
                FontAwesomeIcons.textWidth,
                color: Theme.of(context).colorScheme.onPrimary,
                size: kIconSizeM,
              ),
              const SizedBox(width: kSpaceML),
              Expanded(
                child: Text(
                  coreLang(context).fontSize,
                  style: AppTextStyles.titleLarge(context),
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
                  style: AppTextStyles.bodyLargeBold(context),
                ),
              ),
            ],
          ),
          Slider(
            value: settingState.fontSize.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            inactiveColor:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
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
                color: Theme.of(context).colorScheme.onPrimary,
                size: kIconSizeM,
              ),
              const SizedBox(width: kSpaceML),
              Text(
                coreLang(context).volume,
                style: AppTextStyles.titleLarge(context),
              ),
              const Spacer(),
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
                  settingState.vol.toString(),
                  style: AppTextStyles.bodyLargeBold(context),
                ),
              ),
            ],
          ),
          Slider(
            value: settingState.vol.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            inactiveColor:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
            onChanged: (val) {
              settingBloc.add(ChangedVol(vol: val.round()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVibrateToggle(BuildContext context, SettingState settingState) {
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
            FontAwesomeIcons.waveSquare,
            color: Theme.of(context).colorScheme.onPrimary,
            size: kIconSizeM,
          ),
          const SizedBox(width: kSpaceML),
          Text(
            coreLang(context).vibrate,
            style: AppTextStyles.titleLarge(context),
          ),
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
                FontAwesomeIcons.ribbon,
                color: Theme.of(context).colorScheme.onPrimary,
                size: kIconSizeM,
              ),
              const SizedBox(width: kSpaceML),
              Expanded(
                child: Text(
                  coreLang(context).topScore,
                  style: AppTextStyles.titleLarge(context),
                ),
              ),
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
                  settingState.numberOfTopBoard.toString(),
                  style: AppTextStyles.bodyLargeBold(context),
                ),
              ),
            ],
          ),
          Slider(
            value: settingState.numberOfTopBoard.toDouble(),
            min: 20,
            max: 100,
            divisions: 8,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            inactiveColor:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
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
            FontAwesomeIcons.userCheck,
            color: Theme.of(context).colorScheme.onPrimary,
            size: kIconSizeM,
          ),
          const SizedBox(width: kSpaceML),
          Expanded(
            child: Text(
              coreLang(context).personal,
              style: AppTextStyles.titleLarge(context),
            ),
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
              Icon(
                FontAwesomeIcons.language,
                color: Theme.of(context).colorScheme.onPrimary,
                size: kIconSizeM,
              ),
              const SizedBox(width: kSpaceML),
              Text(
                coreLang(context).language,
                style: AppTextStyles.titleLarge(context),
              ),
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
                      style: AppTextStyles.bodyLarge(context),
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
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 2,
                ),
              ),
            ),
            dropdownColor: Theme.of(context).primaryColor,
            style: AppTextStyles.bodyLarge(context),
          ),
        ],
      ),
    );
  }
}
