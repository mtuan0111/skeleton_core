import 'package:flutter/material.dart';
import 'package:skeleton_core/src/models/base_setting_model.dart';

class SettingState {
  final BaseSettingModel model;
  final bool isLoading;

  /// Transient mute flag — not persisted.
  /// When true, audio is silenced without changing [vol].
  /// Toggling back restores the original [vol].
  final bool isMuted;

  SettingState({
    BaseSettingModel? model,
    this.isLoading = true,
    this.isMuted = false,
  }) : model = model ?? BaseSettingModel();

  SettingState copyWith({
    ThemeMode? themeMode,
    String? locale,
    int? vol,
    bool? isVibrate,
    int? fontSize,
    int? numberOfTopBoard,
    bool? onlyShowMyRecorded,
    bool? isLoading,
    BaseSettingModel? model,
    bool? isMuted,
  }) {
    final currentModel = model ?? this.model;
    return SettingState(
      model: BaseSettingModel(
        themeMode: themeMode ?? currentModel.themeMode,
        locale: locale ?? currentModel.locale,
        vol: vol ?? currentModel.vol,
        isVibrate: isVibrate ?? currentModel.isVibrate,
        fontSize: fontSize ?? currentModel.fontSize,
        numberOfTopBoard: numberOfTopBoard ?? currentModel.numberOfTopBoard,
        onlyShowMyRecorded:
            onlyShowMyRecorded ?? currentModel.onlyShowMyRecorded,
      ),
      isLoading: isLoading ?? this.isLoading,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  String get locale => model.locale;
  int get fontSize => model.fontSize;
  int get vol => model.vol;
  bool get isVibrate => model.isVibrate;
  int get numberOfTopBoard => model.numberOfTopBoard;
  bool get onlyShowMyRecorded => model.onlyShowMyRecorded;
  ThemeMode get themeMode => model.themeMode;
}
