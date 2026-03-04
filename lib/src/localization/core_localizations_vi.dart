// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'core_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class CoreLocalizationsVi extends CoreLocalizations {
  CoreLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get cancel => 'Hủy';

  @override
  String get ok => 'OK';

  @override
  String get exit => 'Thoát';

  @override
  String get share => 'Chia sẻ';

  @override
  String get restart => 'Chơi lại';

  @override
  String get start => 'Bắt đầu';

  @override
  String get ready => 'Sẵn sàng';

  @override
  String get go => 'Bắt đầu';

  @override
  String get waiting => 'Đang chờ';

  @override
  String get setting => 'Cài đặt';

  @override
  String get about => 'Giới thiệu';

  @override
  String get version => 'Phiên bản';

  @override
  String get name => 'Tên người chơi';

  @override
  String get fontSize => 'Kích thước phông chữ';

  @override
  String get volume => 'Âm lượng';

  @override
  String get vibrate => 'Rung';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get updateRequired => 'Yêu cầu cập nhật';

  @override
  String get updateAvailable => 'Có bản cập nhật';

  @override
  String get currentVersion => 'Phiên bản hiện tại';

  @override
  String get newVersion => 'Phiên bản mới';

  @override
  String get whatsNew => 'Có gì mới';

  @override
  String get forceUpdateMessage =>
      'Bản cập nhật này là bắt buộc để tiếp tục sử dụng ứng dụng. Vui lòng cập nhật ngay.';

  @override
  String get later => 'Để sau';

  @override
  String get updateNow => 'Cập nhật ngay';

  @override
  String get update => 'Cập nhật';

  @override
  String get checkForUpdates => 'Kiểm tra cập nhật';

  @override
  String get appUpdates => 'Cập nhật ứng dụng';

  @override
  String get tapToCheckUpdates =>
      'Nhấn vào nút bên dưới để kiểm tra cập nhật ứng dụng.';

  @override
  String get checkingForUpdates => 'Đang kiểm tra cập nhật...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'Phiên bản mới $version đã có! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'Bản cập nhật này là bắt buộc.';

  @override
  String get usingLatestVersion => 'Bạn đang sử dụng phiên bản mới nhất!';

  @override
  String unableToCheckUpdates(String error) {
    return 'Không thể kiểm tra cập nhật. $error';
  }

  @override
  String get tryAgainLater => 'Vui lòng thử lại sau.';

  @override
  String get updatePostponed => 'Có bản cập nhật nhưng đã hoãn lại.';

  @override
  String get welcome => 'Chào mừng!!';

  @override
  String welcomeUser(String username) {
    return 'Chào mừng $username!!';
  }

  @override
  String get mainMenu => 'Trang chính';

  @override
  String get anonymous => 'Ẩn danh';

  @override
  String get level => 'Cấp độ';

  @override
  String get score => 'Điểm số';

  @override
  String get rank => 'Hạng';

  @override
  String get topScore => 'Điểm cao nhất';

  @override
  String get global => 'Toàn cầu';

  @override
  String get personal => 'Cá nhân';

  @override
  String get areYouSure => 'Bạn có chắc chắn không?';

  @override
  String get confirmExit => 'Bạn có chắc chắn muốn thoát không?';

  @override
  String get doYouWantToExit => 'Bạn có muốn thoát không?';

  @override
  String get gameOver => 'Kết thúc trò chơi';

  @override
  String get playAgain => 'Chơi lại';

  @override
  String get returnToMenu => 'Về menu';

  @override
  String get thankYou => 'Cảm ơn bạn!';

  @override
  String get thankYouMessage =>
      'Cảm ơn bạn đã chơi trò chơi của chúng tôi. Chúng tôi hy vọng bạn đã thích nó. Nếu bạn có bất kỳ phản hồi hoặc đề xuất nào, xin vui lòng cho chúng tôi biết.';

  @override
  String get authorName => 'Tác giả';

  @override
  String get connectWithUs => 'Kết nối với chúng tôi';

  @override
  String get connectWithUsMessage =>
      'Nếu bạn có bất kỳ câu hỏi hoặc phản hồi nào, hãy liên hệ với chúng tôi qua các kênh truyền thông xã hội của chúng tôi.';

  @override
  String get difficulty => 'Độ khó';

  @override
  String get difficultySetting => 'Cài đặt độ khó';

  @override
  String get easy => 'Dễ';

  @override
  String get medium => 'Trung bình';

  @override
  String get hard => 'Khó';

  @override
  String get veryHard => 'Rất khó';

  @override
  String get extreme => 'Cực kỳ khó';

  @override
  String get selectDifficulty => 'Chọn độ khó';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'Hôm nay là $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'Tết Dương lịch';

  @override
  String get greetingNewYear => 'Chúc mừng năm mới!';

  @override
  String get holidayLunarNewYear => 'Tết Nguyên đán';

  @override
  String get greetingLunarNewYear => 'Chúc mừng năm mới! Vạn sự như ý!';

  @override
  String get holidayValentine => 'Ngày Lễ Tình Nhân';

  @override
  String get greetingValentine => 'Chúc mừng ngày lễ tình nhân!';

  @override
  String get holidayHoli => 'Lễ hội Holi';

  @override
  String get greetingHoli => 'होली की शुभकामनाएं! (Holi Ki Shubhkamnayein!)';

  @override
  String get holidayEarthDay => 'Ngày Trái Đất';

  @override
  String get greetingEarthDay =>
      'Chúc mừng Ngày Trái Đất! Bảo vệ hành tinh của chúng ta!';

  @override
  String get holidayEaster => 'Lễ Phục Sinh';

  @override
  String get greetingEaster => 'Chúc mừng Lễ Phục Sinh!';

  @override
  String get holidayPride => 'Tháng Tự Hào';

  @override
  String get greetingPride => 'Tháng Tự Hào Vui Vẻ! Tình Yêu Là Tình Yêu!';

  @override
  String get holidayHalloween => 'Lễ Halloween';

  @override
  String get greetingHalloween => 'Chúc mừng Halloween!';

  @override
  String get holidayDiwali => 'Lễ hội Diwali';

  @override
  String get greetingDiwali =>
      'दीपावली की शुभकामनाएं! (Deepavali Ki Shubhkamnayein!)';

  @override
  String get holidayHanukkah => 'Lễ Hanukkah';

  @override
  String get greetingHanukkah => 'חג חנוכה שמח! (Chag Hanukkah Sameach!)';

  @override
  String get holidayChristmas => 'Lễ Giáng Sinh';

  @override
  String get greetingChristmas => 'Chúc mừng Giáng Sinh!';

  @override
  String get holidayKwanzaa => 'Lễ Kwanzaa';

  @override
  String get greetingKwanzaa => 'Habari Gani!';
}
