// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'core_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class CoreLocalizationsJa extends CoreLocalizations {
  CoreLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get cancel => 'キャンセル';

  @override
  String get ok => 'OK';

  @override
  String get exit => '終了';

  @override
  String get share => '共有';

  @override
  String get restart => '再起動';

  @override
  String get start => 'スタート';

  @override
  String get ready => '準備完了';

  @override
  String get go => 'ゴー！';

  @override
  String get waiting => '待機中';

  @override
  String get setting => '設定';

  @override
  String get about => 'アプリについて';

  @override
  String get version => 'バージョン';

  @override
  String get name => '名前';

  @override
  String get fontSize => 'フォントサイズ';

  @override
  String get volume => '音量';

  @override
  String get vibrate => '振動';

  @override
  String get language => '言語';

  @override
  String get updateRequired => 'アップデートが必要です';

  @override
  String get updateAvailable => 'アップデートがあります';

  @override
  String get currentVersion => '現在のバージョン';

  @override
  String get newVersion => '新しいバージョン';

  @override
  String get whatsNew => '新機能';

  @override
  String get forceUpdateMessage => 'アプリを引き続き使用するには、この更新が必要です。今すぐ更新してください。';

  @override
  String get later => '後で';

  @override
  String get updateNow => '今すぐ更新';

  @override
  String get update => '更新';

  @override
  String get checkForUpdates => '更新を確認';

  @override
  String get appUpdates => 'アプリアップデート';

  @override
  String get tapToCheckUpdates => '下のボタンをタップして、アプリの更新を確認してください。';

  @override
  String get checkingForUpdates => '更新を確認中...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return '新しいバージョン $version が利用可能です！ $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'この更新は必須です。';

  @override
  String get usingLatestVersion => '最新バージョンを使用しています！';

  @override
  String unableToCheckUpdates(String error) {
    return '更新を確認できませんでした。$error';
  }

  @override
  String get tryAgainLater => '後でもう一度お試しください。';

  @override
  String get updatePostponed => '更新は利用可能ですが延期されました。';

  @override
  String get welcome => 'ようこそ！';

  @override
  String welcomeUser(String username) {
    return 'ようこそ、$usernameさん！';
  }

  @override
  String get mainMenu => 'メインメニュー';

  @override
  String get anonymous => '匿名';

  @override
  String get level => 'レベル';

  @override
  String get score => 'スコア';

  @override
  String get rank => 'ランク';

  @override
  String get topScore => '最高スコア';

  @override
  String get global => 'グローバル';

  @override
  String get personal => '個人';

  @override
  String get areYouSure => 'よろしいですか？';

  @override
  String get confirmExit => '本当に終了しますか？';

  @override
  String get doYouWantToExit => '終了しますか？';

  @override
  String get gameOver => 'ゲームオーバー';

  @override
  String get playAgain => 'もう一度プレイ';

  @override
  String get returnToMenu => 'メニューに戻る';

  @override
  String get thankYou => 'プレイありがとうございます';

  @override
  String get thankYouMessage =>
      '当ゲームをプレイいただきありがとうございます。楽しんでいただけたでしょうか。ご意見やご感想がございましたら、お気軽にお寄せください。';

  @override
  String get authorName => '作者';

  @override
  String get connectWithUs => 'お問い合わせ';

  @override
  String get connectWithUsMessage =>
      'ご質問やご意見がございましたら、ソーシャルメディアチャネルからお気軽にお問い合わせください。';

  @override
  String get difficulty => '難易度';

  @override
  String get difficultySetting => '難易度設定';

  @override
  String get easy => 'かんたん';

  @override
  String get medium => 'ふつう';

  @override
  String get hard => 'むずかしい';

  @override
  String get veryHard => '激ムズ';

  @override
  String get extreme => '究極';

  @override
  String get selectDifficulty => '難易度を選択';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return '今日は$holidayName、$greeting';
  }

  @override
  String get holidayNewYear => 'お正月';

  @override
  String get greetingNewYear => 'あけましておめでとうございます！';

  @override
  String get holidayLunarNewYear => '旧正月';

  @override
  String get greetingLunarNewYear => '旧正月おめでとうございます！';

  @override
  String get holidayValentine => 'バレンタインデー';

  @override
  String get greetingValentine => 'ハッピーバレンタイン！';

  @override
  String get holidayHoli => 'ホーリー';

  @override
  String get greetingHoli => 'ハッピーホーリー！';

  @override
  String get holidayEarthDay => 'アースデイ';

  @override
  String get greetingEarthDay => 'ハッピーアースデイ！地球を守ろう！';

  @override
  String get holidayEaster => 'イースター';

  @override
  String get greetingEaster => 'ハッピーイースター！';

  @override
  String get holidayPride => 'プライド月間';

  @override
  String get greetingPride => 'ハッピープライド！愛は愛！';

  @override
  String get holidayHalloween => 'ハロウィン';

  @override
  String get greetingHalloween => 'ハッピーハロウィン！';

  @override
  String get holidayDiwali => 'ディワリ';

  @override
  String get greetingDiwali => 'ハッピーディワリ！';

  @override
  String get holidayHanukkah => 'ハヌカ';

  @override
  String get greetingHanukkah => 'ハッピーハヌカ！';

  @override
  String get holidayChristmas => 'クリスマス';

  @override
  String get greetingChristmas => 'メリークリスマス！';

  @override
  String get holidayKwanzaa => 'クワンザ';

  @override
  String get greetingKwanzaa => 'ハッピークワンザ！';
}
