import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'core_localizations_de.dart';
import 'core_localizations_en.dart';
import 'core_localizations_es.dart';
import 'core_localizations_fr.dart';
import 'core_localizations_hi.dart';
import 'core_localizations_id.dart';
import 'core_localizations_ja.dart';
import 'core_localizations_th.dart';
import 'core_localizations_vi.dart';
import 'core_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of CoreLocalizations
/// returned by `CoreLocalizations.of(context)`.
///
/// Applications need to include `CoreLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/core_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CoreLocalizations.localizationsDelegates,
///   supportedLocales: CoreLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the CoreLocalizations.supportedLocales
/// property.
abstract class CoreLocalizations {
  CoreLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CoreLocalizations? of(BuildContext context) {
    return Localizations.of<CoreLocalizations>(context, CoreLocalizations);
  }

  static const LocalizationsDelegate<CoreLocalizations> delegate =
      _CoreLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('ja'),
    Locale('th'),
    Locale('vi'),
    Locale('zh')
  ];

  /// Yes button in the confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button in the confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Button to cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Exit button label
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Label for share button
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Restart button label
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// Start button label
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Ready status label
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// Go status label
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// Waiting status text
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// Settings menu label
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// About menu label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// The version label of the application
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Label for name input
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Label for font size setting
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// Label for volume setting
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// Label for vibration setting
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get vibrate;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Title for force update dialog
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// Title for optional update dialog
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// Label for current app version
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get currentVersion;

  /// Label for new available version
  ///
  /// In en, this message translates to:
  /// **'New Version'**
  String get newVersion;

  /// Label for release notes section
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whatsNew;

  /// Message for force update requirement
  ///
  /// In en, this message translates to:
  /// **'This update is required to continue using the app. Please update now.'**
  String get forceUpdateMessage;

  /// Button to postpone optional update
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// Button to proceed with update
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// Button to update app
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Button to check for app updates
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// Section title for app updates
  ///
  /// In en, this message translates to:
  /// **'App Updates'**
  String get appUpdates;

  /// Message prompting user to check for updates
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to check for app updates.'**
  String get tapToCheckUpdates;

  /// Message while checking for updates
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// Message when new version is available
  ///
  /// In en, this message translates to:
  /// **'New version {version} is available! {forceMessage}'**
  String newVersionAvailable(String version, String forceMessage);

  /// Message for force update
  ///
  /// In en, this message translates to:
  /// **'This update is required.'**
  String get thisUpdateRequired;

  /// Message when app is up to date
  ///
  /// In en, this message translates to:
  /// **'You\'re using the latest version!'**
  String get usingLatestVersion;

  /// Error message when update check fails
  ///
  /// In en, this message translates to:
  /// **'Unable to check for updates. {error}'**
  String unableToCheckUpdates(String error);

  /// Default error message
  ///
  /// In en, this message translates to:
  /// **'Please try again later.'**
  String get tryAgainLater;

  /// Message when user dismissed update
  ///
  /// In en, this message translates to:
  /// **'Update available but postponed.'**
  String get updatePostponed;

  /// Welcome the user to the application
  ///
  /// In en, this message translates to:
  /// **'Welcome!!'**
  String get welcome;

  /// Welcome the user to the application
  ///
  /// In en, this message translates to:
  /// **'Welcome {username}!!'**
  String welcomeUser(String username);

  /// Tiêu đề của trang chính
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenu;

  /// Label for anonymous user
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// Label for game level
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// Label for game score
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Label for ranking position
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// Label for the top score
  ///
  /// In en, this message translates to:
  /// **'Top score'**
  String get topScore;

  /// Label for global ranking view
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get global;

  /// Label for personal ranking view
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// Warning when the user performs an important action
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// Warning when the user presses the exit button
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get confirmExit;

  /// Prompt asking the user if they want to exit
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit?'**
  String get doYouWantToExit;

  /// Game over message
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// Button to restart the game
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// Button to return to main menu
  ///
  /// In en, this message translates to:
  /// **'Return to Menu'**
  String get returnToMenu;

  /// Thank you message
  ///
  /// In en, this message translates to:
  /// **'Thank you for playing'**
  String get thankYou;

  /// Detailed thank you message
  ///
  /// In en, this message translates to:
  /// **'Thank you for playing our game. We hope you enjoyed it. If you have any feedback or suggestions, please let us know.'**
  String get thankYouMessage;

  /// Label for author name
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get authorName;

  /// Label for connect with us section
  ///
  /// In en, this message translates to:
  /// **'Connect with us'**
  String get connectWithUs;

  /// Message encouraging users to connect on social media
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or feedback, feel free to reach out to us on our social media channels.'**
  String get connectWithUsMessage;

  /// Difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// Label for difficulty setting in the game
  ///
  /// In en, this message translates to:
  /// **'Difficulty Setting'**
  String get difficultySetting;

  /// Easy difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// Medium difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Hard difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// Very hard difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Very Hard'**
  String get veryHard;

  /// Extreme difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get extreme;

  /// Prompt for user to select the game difficulty
  ///
  /// In en, this message translates to:
  /// **'Select difficulty'**
  String get selectDifficulty;

  /// Holiday event notification with greeting
  ///
  /// In en, this message translates to:
  /// **'Today is {holidayName}, {greeting}'**
  String holidayNotification(String holidayName, String greeting);

  /// New Year holiday name
  ///
  /// In en, this message translates to:
  /// **'New Year'**
  String get holidayNewYear;

  /// New Year greeting
  ///
  /// In en, this message translates to:
  /// **'Happy New Year!'**
  String get greetingNewYear;

  /// Lunar New Year holiday name
  ///
  /// In en, this message translates to:
  /// **'Lunar New Year'**
  String get holidayLunarNewYear;

  /// Lunar New Year greeting in Chinese
  ///
  /// In en, this message translates to:
  /// **'新年快乐! (Xīn Nián Kuài Lè!)'**
  String get greetingLunarNewYear;

  /// Valentine's Day holiday name
  ///
  /// In en, this message translates to:
  /// **'Valentine\'s Day'**
  String get holidayValentine;

  /// Valentine's Day greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Valentine\'s Day!'**
  String get greetingValentine;

  /// Holi holiday name
  ///
  /// In en, this message translates to:
  /// **'Holi'**
  String get holidayHoli;

  /// Holi greeting in Hindi
  ///
  /// In en, this message translates to:
  /// **'होली की शुभकामनाएं! (Holi Ki Shubhkamnayein!)'**
  String get greetingHoli;

  /// Earth Day holiday name
  ///
  /// In en, this message translates to:
  /// **'Earth Day'**
  String get holidayEarthDay;

  /// Earth Day greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Earth Day! Protect our planet!'**
  String get greetingEarthDay;

  /// Easter holiday name
  ///
  /// In en, this message translates to:
  /// **'Easter'**
  String get holidayEaster;

  /// Easter greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Easter!'**
  String get greetingEaster;

  /// Pride Month name
  ///
  /// In en, this message translates to:
  /// **'Pride Month'**
  String get holidayPride;

  /// Pride Month greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Pride! Love is Love!'**
  String get greetingPride;

  /// Halloween holiday name
  ///
  /// In en, this message translates to:
  /// **'Halloween'**
  String get holidayHalloween;

  /// Halloween greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Halloween!'**
  String get greetingHalloween;

  /// Diwali holiday name
  ///
  /// In en, this message translates to:
  /// **'Diwali'**
  String get holidayDiwali;

  /// Diwali greeting in Hindi
  ///
  /// In en, this message translates to:
  /// **'दीपावली की शुभकामनाएं! (Deepavali Ki Shubhkamnayein!)'**
  String get greetingDiwali;

  /// Hanukkah holiday name
  ///
  /// In en, this message translates to:
  /// **'Hanukkah'**
  String get holidayHanukkah;

  /// Hanukkah greeting in Hebrew
  ///
  /// In en, this message translates to:
  /// **'חג חנוכה שמח! (Chag Hanukkah Sameach!)'**
  String get greetingHanukkah;

  /// Christmas holiday name
  ///
  /// In en, this message translates to:
  /// **'Christmas'**
  String get holidayChristmas;

  /// Christmas greeting
  ///
  /// In en, this message translates to:
  /// **'Merry Christmas!'**
  String get greetingChristmas;

  /// Kwanzaa holiday name
  ///
  /// In en, this message translates to:
  /// **'Kwanzaa'**
  String get holidayKwanzaa;

  /// Kwanzaa greeting in Swahili
  ///
  /// In en, this message translates to:
  /// **'Habari Gani!'**
  String get greetingKwanzaa;
}

class _CoreLocalizationsDelegate
    extends LocalizationsDelegate<CoreLocalizations> {
  const _CoreLocalizationsDelegate();

  @override
  Future<CoreLocalizations> load(Locale locale) {
    return SynchronousFuture<CoreLocalizations>(
        lookupCoreLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'ja',
        'th',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_CoreLocalizationsDelegate old) => false;
}

CoreLocalizations lookupCoreLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return CoreLocalizationsDe();
    case 'en':
      return CoreLocalizationsEn();
    case 'es':
      return CoreLocalizationsEs();
    case 'fr':
      return CoreLocalizationsFr();
    case 'hi':
      return CoreLocalizationsHi();
    case 'id':
      return CoreLocalizationsId();
    case 'ja':
      return CoreLocalizationsJa();
    case 'th':
      return CoreLocalizationsTh();
    case 'vi':
      return CoreLocalizationsVi();
    case 'zh':
      return CoreLocalizationsZh();
  }

  throw FlutterError(
      'CoreLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
