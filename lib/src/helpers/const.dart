import 'package:flutter/material.dart';

/// Common layout configuration for the game shell.
///
/// Game-specific constants (BLE prefixes, difficulty constants, AdMob IDs, etc.)
/// should be defined in the game package.
class LayoutConfig {
  final BuildContext context;

  // Layout
  static double boxSize = 80;
  static double layoutBorderRadius = 30;

  static double opacityDisabled = 0.5;

  LayoutConfig(this.context);

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LayoutConfig.layoutBorderRadius),
    ),
    foregroundColor: const Color.fromARGB(221, 126, 109, 109),
    shadowColor: Colors.grey,
  );

  BoxDecoration get gradientDecoration => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).secondaryHeaderColor,
      ],
    ),
  );

  BoxDecoration get gradientDecorationReverted => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).secondaryHeaderColor,
      ].reversed.toList(),
    ),
  );

  BoxDecoration get boxDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(LayoutConfig.layoutBorderRadius),
    border: Border.all(color: Theme.of(context).scaffoldBackgroundColor),
  );
}

/// Common language map for supported locales.
const Map<String, String> languages = {
  'en': "English",
  'vi': "Tiếng Việt",
  'es': "Español",
  'zh': "中文",
  'fr': "Français",
  'de': "Deutsch",
  'ja': "日本語",
  'th': "ไทย",
  'id': "Bahasa Indonesia",
  'hi': "हिन्दी",
};

/// Common date/time format strings.
const String timeDateClient = "dd/MM/yyyy hh:mm a";
const String timeDateServer = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
