import 'package:flutter/material.dart';

/// Base setting model for common game-shell settings.
///
/// Games should extend this class to add game-specific fields
/// (e.g., difficulty, game mode).
///
/// Example:
/// ```dart
/// class NucatchSettingModel extends BaseSettingModel {
///   final Difficulty difficulty;
///   NucatchSettingModel({
///     super.themeMode,
///     super.locale,
///     super.vol,
///     super.isVibrate,
///     super.fontSize,
///     super.numberOfTopBoard,
///     super.onlyShowMyRecorded,
///     this.difficulty = Difficulty.easy,
///   });
/// }
/// ```
class BaseSettingModel {
  final ThemeMode themeMode;
  final String locale;
  final int vol;
  final bool isVibrate;
  final int fontSize;
  final int numberOfTopBoard;
  final bool onlyShowMyRecorded;

  BaseSettingModel({
    this.themeMode = ThemeMode.system,
    this.locale = 'en',
    this.vol = 8,
    this.isVibrate = true,
    this.fontSize = 8,
    this.numberOfTopBoard = 20,
    this.onlyShowMyRecorded = false,
  });

  BaseSettingModel copyWith({
    ThemeMode? themeMode,
    String? locale,
    int? vol,
    bool? isVibrate,
    int? fontSize,
    int? numberOfTopBoard,
    bool? onlyShowMyRecorded,
  }) {
    return BaseSettingModel(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      vol: vol ?? this.vol,
      isVibrate: isVibrate ?? this.isVibrate,
      fontSize: fontSize ?? this.fontSize,
      numberOfTopBoard: numberOfTopBoard ?? this.numberOfTopBoard,
      onlyShowMyRecorded: onlyShowMyRecorded ?? this.onlyShowMyRecorded,
    );
  }
}
