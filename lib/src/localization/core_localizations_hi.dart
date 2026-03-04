// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'core_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class CoreLocalizationsHi extends CoreLocalizations {
  CoreLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get ok => 'ठीक';

  @override
  String get exit => 'बाहर निकलें';

  @override
  String get share => 'साझा करें';

  @override
  String get restart => 'पुनः आरंभ करें';

  @override
  String get start => 'शुरू करें';

  @override
  String get ready => 'तैयार';

  @override
  String get go => 'जाओ!';

  @override
  String get waiting => 'प्रतीक्षा कर रहा है';

  @override
  String get setting => 'सेटिंग्स';

  @override
  String get about => 'के बारे में';

  @override
  String get version => 'वर्जन';

  @override
  String get name => 'नाम';

  @override
  String get fontSize => 'फ़ॉन्ट आकार';

  @override
  String get volume => 'वॉल्यूम';

  @override
  String get vibrate => 'कंपन';

  @override
  String get language => 'भाषा';

  @override
  String get updateRequired => 'अपडेट आवश्यक';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध';

  @override
  String get currentVersion => 'वर्तमान संस्करण';

  @override
  String get newVersion => 'नया संस्करण';

  @override
  String get whatsNew => 'नया क्या है';

  @override
  String get forceUpdateMessage =>
      'ऐप का उपयोग जारी रखने के लिए यह अपडेट आवश्यक है। कृपया अभी अपडेट करें।';

  @override
  String get later => 'बाद में';

  @override
  String get updateNow => 'अभी अपडेट करें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get checkForUpdates => 'अपडेट देखें';

  @override
  String get appUpdates => 'ऐप अपडेट';

  @override
  String get tapToCheckUpdates =>
      'ऐप अपडेट देखने के लिए नीचे दिए गए बटन पर टैप करें।';

  @override
  String get checkingForUpdates => 'अपडेट की जांच हो रही है...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'नया संस्करण $version उपलब्ध है! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'यह अपडेट आवश्यक है।';

  @override
  String get usingLatestVersion => 'आप नवीनतम संस्करण का उपयोग कर रहे हैं!';

  @override
  String unableToCheckUpdates(String error) {
    return 'अपडेट की जांच करने में असमर्थ। $error';
  }

  @override
  String get tryAgainLater => 'कृपया बाद में पुनः प्रयास करें।';

  @override
  String get updatePostponed => 'अपडेट उपलब्ध है लेकिन स्थगित कर दिया गया है।';

  @override
  String get welcome => 'स्वागत है!';

  @override
  String welcomeUser(String username) {
    return 'स्वागत है $username!';
  }

  @override
  String get mainMenu => 'मुख्य मेनू';

  @override
  String get anonymous => 'बेनामी';

  @override
  String get level => 'स्तर';

  @override
  String get score => 'स्कोर';

  @override
  String get rank => 'रैंक';

  @override
  String get topScore => 'शीर्ष स्कोर';

  @override
  String get global => 'वैश्विक';

  @override
  String get personal => 'व्यक्तिगत';

  @override
  String get areYouSure => 'क्या आपको यकीन है?';

  @override
  String get confirmExit => 'क्या आप वाकई छोड़ना चाहते हैं?';

  @override
  String get doYouWantToExit => 'क्या आप बाहर निकलना चाहते हैं?';

  @override
  String get gameOver => 'खेल खत्म';

  @override
  String get playAgain => 'फिर से खेलें';

  @override
  String get returnToMenu => 'मेनू पर लौटें';

  @override
  String get thankYou => 'खेलने के लिए धन्यवाद';

  @override
  String get thankYouMessage =>
      'हमारा खेल खेलने के लिए धन्यवाद। हमें उम्मीद है कि आपने इसका आनंद लिया। यदि आपके पास कोई प्रतिक्रिया या सुझाव है, तो कृपया हमें बताएं।';

  @override
  String get authorName => 'लेखक';

  @override
  String get connectWithUs => 'हमसे जुड़ें';

  @override
  String get connectWithUsMessage =>
      'यदि आपके पास कोई प्रश्न या टिप्पणी है, तो बेझिझक हमारे सोशल मीडिया चैनलों के माध्यम से हमसे संपर्क करें।';

  @override
  String get difficulty => 'कठिनाई';

  @override
  String get difficultySetting => 'कठिनाई सेटिंग';

  @override
  String get easy => 'आसान';

  @override
  String get medium => 'मध्यम';

  @override
  String get hard => 'कठिन';

  @override
  String get veryHard => 'बहुत कठिन';

  @override
  String get extreme => 'अत्यधिक';

  @override
  String get selectDifficulty => 'कठिनाई चुनें';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'आज $holidayName है, $greeting';
  }

  @override
  String get holidayNewYear => 'नया साल';

  @override
  String get greetingNewYear => 'नया साल मुबारक हो!';

  @override
  String get holidayLunarNewYear => 'चंद्र नव वर्ष';

  @override
  String get greetingLunarNewYear => 'चंद्र नव वर्ष मुबारक हो!';

  @override
  String get holidayValentine => 'वेलेंटाइन डे';

  @override
  String get greetingValentine => 'हैप्पी वेलेंटाइन डे!';

  @override
  String get holidayHoli => 'होली';

  @override
  String get greetingHoli => 'होली मुबारक!';

  @override
  String get holidayEarthDay => 'पृथ्वी दिवस';

  @override
  String get greetingEarthDay =>
      'हैप्पी पृथ्वी दिवस! हमारे ग्रह की रक्षा करें!';

  @override
  String get holidayEaster => 'ईस्टर';

  @override
  String get greetingEaster => 'हैप्पी ईस्टर!';

  @override
  String get holidayPride => 'प्राइड मंथ';

  @override
  String get greetingPride => 'हैप्पी प्राइड मंथ! प्यार प्यार है!';

  @override
  String get holidayHalloween => 'हैलोवीन';

  @override
  String get greetingHalloween => 'हैप्पी हैलोवीन!';

  @override
  String get holidayDiwali => 'दीपावली';

  @override
  String get greetingDiwali => 'दीपावली मुबारक!';

  @override
  String get holidayHanukkah => 'हनुक्काह';

  @override
  String get greetingHanukkah => 'हैप्पी हनुक्काह!';

  @override
  String get holidayChristmas => 'क्रिसमस';

  @override
  String get greetingChristmas => 'मेरी क्रिसमस!';

  @override
  String get holidayKwanzaa => 'क्वांज़ा';

  @override
  String get greetingKwanzaa => 'हैप्पी क्वांज़ा!';
}
