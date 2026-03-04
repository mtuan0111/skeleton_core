// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'core_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class CoreLocalizationsDe extends CoreLocalizations {
  CoreLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get exit => 'Verlassen';

  @override
  String get share => 'Teilen';

  @override
  String get restart => 'Neustart';

  @override
  String get start => 'Starten';

  @override
  String get ready => 'Bereit';

  @override
  String get go => 'Los!';

  @override
  String get waiting => 'Warten';

  @override
  String get setting => 'Einstellungen';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get name => 'Name';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get volume => 'Lautstärke';

  @override
  String get vibrate => 'Vibrieren';

  @override
  String get language => 'Sprache';

  @override
  String get updateRequired => 'Update erforderlich';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get currentVersion => 'Aktuelle Version';

  @override
  String get newVersion => 'Neue Version';

  @override
  String get whatsNew => 'Was ist neu';

  @override
  String get forceUpdateMessage =>
      'Dieses Update ist erforderlich, um die App weiter nutzen zu können. Bitte jetzt aktualisieren.';

  @override
  String get later => 'Später';

  @override
  String get updateNow => 'Jetzt aktualisieren';

  @override
  String get update => 'Aktualisieren';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get appUpdates => 'App-Updates';

  @override
  String get tapToCheckUpdates =>
      'Tippe auf die Schaltfläche unten, um nach App-Updates zu suchen.';

  @override
  String get checkingForUpdates => 'Suche nach Updates...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'Neue Version $version verfügbar! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'Dieses Update ist erforderlich.';

  @override
  String get usingLatestVersion => 'Du verwendest die neueste Version!';

  @override
  String unableToCheckUpdates(String error) {
    return 'Fehler beim Suchen nach Updates. $error';
  }

  @override
  String get tryAgainLater => 'Bitte versuche es später noch einmal.';

  @override
  String get updatePostponed => 'Update verfügbar, aber verschoben.';

  @override
  String get welcome => 'Willkommen!';

  @override
  String welcomeUser(String username) {
    return 'Willkommen $username!';
  }

  @override
  String get mainMenu => 'Hauptmenü';

  @override
  String get anonymous => 'Anonym';

  @override
  String get level => 'Level';

  @override
  String get score => 'Punktzahl';

  @override
  String get rank => 'Rang';

  @override
  String get topScore => 'Bestenliste';

  @override
  String get global => 'Global';

  @override
  String get personal => 'Persönlich';

  @override
  String get areYouSure => 'Bist du sicher?';

  @override
  String get confirmExit => 'Bist du sicher, dass du aufhören möchtest?';

  @override
  String get doYouWantToExit => 'Möchtest du beenden?';

  @override
  String get gameOver => 'Spiel vorbei';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get returnToMenu => 'Zum Menü zurückkehren';

  @override
  String get thankYou => 'Danke fürs Spielen';

  @override
  String get thankYouMessage =>
      'Danke, dass du unser Spiel gespielt hast. Wir hoffen, es hat dir gefallen. Wenn du Feedback oder Vorschläge hast, lass es uns bitte wissen.';

  @override
  String get authorName => 'Autor';

  @override
  String get connectWithUs => 'Verbinde dich mit uns';

  @override
  String get connectWithUsMessage =>
      'Wenn du Fragen oder Kommentare hast, kannst du uns gerne über unsere Social-Media-Kanäle kontaktieren.';

  @override
  String get difficulty => 'Schwierigkeit';

  @override
  String get difficultySetting => 'Schwierigkeitseinstellung';

  @override
  String get easy => 'Leicht';

  @override
  String get medium => 'Mittel';

  @override
  String get hard => 'Schwer';

  @override
  String get veryHard => 'Sehr schwer';

  @override
  String get extreme => 'Extrem';

  @override
  String get selectDifficulty => 'Schwierigkeit wählen';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'Heute ist $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'Neujahr';

  @override
  String get greetingNewYear => 'Frohes Neues Jahr!';

  @override
  String get holidayLunarNewYear => 'Mondneujahr';

  @override
  String get greetingLunarNewYear => 'Frohes Mondneujahr!';

  @override
  String get holidayValentine => 'Valentinstag';

  @override
  String get greetingValentine => 'Fröhlichen Valentinstag!';

  @override
  String get holidayHoli => 'Holi';

  @override
  String get greetingHoli => 'Fröhliches Holi!';

  @override
  String get holidayEarthDay => 'Tag der Erde';

  @override
  String get greetingEarthDay =>
      'Fröhlichen Tag der Erde! Schütze unseren Planeten!';

  @override
  String get holidayEaster => 'Ostern';

  @override
  String get greetingEaster => 'Frohe Ostern!';

  @override
  String get holidayPride => 'Pride-Monat';

  @override
  String get greetingPride => 'Fröhlichen Pride-Monat! Liebe ist Liebe!';

  @override
  String get holidayHalloween => 'Halloween';

  @override
  String get greetingHalloween => 'Fröhliches Halloween!';

  @override
  String get holidayDiwali => 'Diwali';

  @override
  String get greetingDiwali => 'Fröhliches Diwali!';

  @override
  String get holidayHanukkah => 'Chanukka';

  @override
  String get greetingHanukkah => 'Fröhliches Chanukka!';

  @override
  String get holidayChristmas => 'Weihnachten';

  @override
  String get greetingChristmas => 'Frohe Weihnachten!';

  @override
  String get holidayKwanzaa => 'Kwanzaa';

  @override
  String get greetingKwanzaa => 'Fröhliches Kwanzaa!';
}
