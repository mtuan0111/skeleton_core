// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'core_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class CoreLocalizationsTh extends CoreLocalizations {
  CoreLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get yes => 'ใช่';

  @override
  String get no => 'ไม่';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get ok => 'ตกลง';

  @override
  String get exit => 'ออก';

  @override
  String get share => 'แชร์';

  @override
  String get restart => 'เริ่มใหม่';

  @override
  String get start => 'เริ่ม';

  @override
  String get ready => 'พร้อม';

  @override
  String get go => 'ไป!';

  @override
  String get waiting => 'กำลังรอ';

  @override
  String get setting => 'การตั้งค่า';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get name => 'ชื่อ';

  @override
  String get fontSize => 'ขนาดตัวอักษร';

  @override
  String get volume => 'ระดับเสียง';

  @override
  String get vibrate => 'สั่น';

  @override
  String get language => 'ภาษา';

  @override
  String get updateRequired => 'จำเป็นต้องอัปเดต';

  @override
  String get updateAvailable => 'มีอัปเดตใหม่';

  @override
  String get currentVersion => 'เวอร์ชันปัจจุบัน';

  @override
  String get newVersion => 'เวอร์ชันใหม่';

  @override
  String get whatsNew => 'มีอะไรใหม่';

  @override
  String get forceUpdateMessage =>
      'จำเป็นต้องอัปเดตนี้เพื่อใช้งานแอปต่อ โปรดอัปเดตทันที';

  @override
  String get later => 'ภายหลัง';

  @override
  String get updateNow => 'อัปเดตทันที';

  @override
  String get update => 'อัปเดต';

  @override
  String get checkForUpdates => 'ตรวจสอบการอัปเดต';

  @override
  String get appUpdates => 'อัปเดตแอป';

  @override
  String get tapToCheckUpdates => 'แตะปุ่มด้านล่างเพื่อตรวจสอบการอัปเดตแอป';

  @override
  String get checkingForUpdates => 'กำลังตรวจสอบการอัปเดต...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'มีเวอร์ชันใหม่ $version ให้ใช้งาน! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'การอัปเดตนี้จำเป็น';

  @override
  String get usingLatestVersion => 'คุณกำลังใช้เวอร์ชันล่าสุด!';

  @override
  String unableToCheckUpdates(String error) {
    return 'ไม่สามารถตรวจสอบการอัปเดตได้ $error';
  }

  @override
  String get tryAgainLater => 'โปรดลองใหม่ในภายหลัง';

  @override
  String get updatePostponed => 'มีการอัปเดตแต่ถูกเลื่อนออกไป';

  @override
  String get welcome => 'ยินดีต้อนรับ!';

  @override
  String welcomeUser(String username) {
    return 'ยินดีต้อนรับ $username!';
  }

  @override
  String get mainMenu => 'เมนูหลัก';

  @override
  String get anonymous => 'ไม่ระบุชื่อ';

  @override
  String get level => 'ระดับ';

  @override
  String get score => 'คะแนน';

  @override
  String get rank => 'อันดับ';

  @override
  String get topScore => 'คะแนนสูงสุด';

  @override
  String get global => 'ทั่วโลก';

  @override
  String get personal => 'ส่วนตัว';

  @override
  String get areYouSure => 'คุณแน่ใจหรือไม่?';

  @override
  String get confirmExit => 'คุณแน่ใจหรือไม่ว่าต้องการออก?';

  @override
  String get doYouWantToExit => 'คุณต้องการออกหรือไม่?';

  @override
  String get gameOver => 'จบเกม';

  @override
  String get playAgain => 'เล่นอีกครั้ง';

  @override
  String get returnToMenu => 'กลับสู่เมนู';

  @override
  String get thankYou => 'ขอบคุณที่เล่น';

  @override
  String get thankYouMessage =>
      'ขอบคุณที่เล่นเกมของเรา เราหวังว่าคุณจะชอบ หากคุณมีข้อเสนอแนะ โปรดแจ้งให้เราทราบ';

  @override
  String get authorName => 'ผู้สร้าง';

  @override
  String get connectWithUs => 'เชื่อมต่อกับเรา';

  @override
  String get connectWithUsMessage =>
      'หากคุณมีคำถามหรือความคิดเห็น โปรดติดต่อเราผ่านโซเชียลมีเดียวของเรา';

  @override
  String get difficulty => 'ความยาก';

  @override
  String get difficultySetting => 'การตั้งค่าความยาก';

  @override
  String get easy => 'ง่าย';

  @override
  String get medium => 'ปานกลาง';

  @override
  String get hard => 'ยาก';

  @override
  String get veryHard => 'ยากมาก';

  @override
  String get extreme => 'สุดโหด';

  @override
  String get selectDifficulty => 'เลือกระดับความยาก';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'วันนี้เป็นวัน $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'วันปีใหม่';

  @override
  String get greetingNewYear => 'สวัสดีปีใหม่!';

  @override
  String get holidayLunarNewYear => 'วันตรุษจีน';

  @override
  String get greetingLunarNewYear => 'ซินเจียยู่อี่ ซินนี้ฮวดไช้!';

  @override
  String get holidayValentine => 'วันวาเลนไทน์';

  @override
  String get greetingValentine => 'สุขสันต์วันวาเลนไทน์!';

  @override
  String get holidayHoli => 'เทศกาลโฮลี';

  @override
  String get greetingHoli => 'สุขสันต์วันโฮลี!';

  @override
  String get holidayEarthDay => 'วันคุ้มครองโลก';

  @override
  String get greetingEarthDay =>
      'สุขสันต์วันคุ้มครองโลก! ช่วยกันรักษาโลกของเรา!';

  @override
  String get holidayEaster => 'วันอีสเตอร์';

  @override
  String get greetingEaster => 'สุขสันต์วันอีสเตอร์!';

  @override
  String get holidayPride => 'เดือนแห่งความภาคภูมิใจ';

  @override
  String get greetingPride => 'สุขสันต์เดือนแห่งความภาคภูมิใจ! รักคือรัก!';

  @override
  String get holidayHalloween => 'วันฮาโลวีน';

  @override
  String get greetingHalloween => 'สุขสันต์วันฮาโลวีน!';

  @override
  String get holidayDiwali => 'เทศกาลดิวาลี';

  @override
  String get greetingDiwali => 'สุขสันต์วันดิวาลี!';

  @override
  String get holidayHanukkah => 'เทศกาลฮานุคคา';

  @override
  String get greetingHanukkah => 'สุขสันต์วันฮานุคคา!';

  @override
  String get holidayChristmas => 'วันคริสต์มาส';

  @override
  String get greetingChristmas => 'สุขสันต์วันคริสต์มาส!';

  @override
  String get holidayKwanzaa => 'เทศกาลควอนซา';

  @override
  String get greetingKwanzaa => 'สุขสันต์วันควอนซา!';
}
