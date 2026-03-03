// ignore_for_file: non_constant_identifier_names, constant_identifier_names

/// Common SharedPreferences keys for the game-shell framework.
///
/// Game-specific keys (e.g., TURN_ID, DIFFICULTY) should be defined
/// in the game's own package.
class PreferencesKey {
  static const USERNAME = "username";
  static const FIREBASE_USER_ID = "firebase_user_id";

  static const NUMBER_OF_TOP_BOARD = "number_of_top_board";
  static const ONLY_SHOW_MY_RECORDED = "only_show_my_recorded";
  static const FONT_SIZE = "font_size";
  static const VOL = "vol";
  static const IS_VIBRATE = "is_variant";
  static const LOCALE = "locale";
  static const THEME_MODE = "theme_mode";
}
